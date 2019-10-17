//
//  STFavoritesViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 13/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFavoritesViewController.h"
#import "STFavoriteCell.h"
#import "STCollegeDetailViewController.h"
#import "STFavorites.h"

#define ROW_HEIGHT      60.0


@interface STFavoritesViewController () {
    
}

@end

@implementation STFavoritesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupNavigationBar];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STFavoriteCell" bundle:nil] forCellReuseIdentifier:@"FavoriteCell"];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getAllFavorites];
}

- (void)getAllFavorites {
    
    self.localContext = [NSManagedObjectContext MR_context];

    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];

    self.favoritesItems = [[localUser favorites] mutableCopy];
    
    __weak STFavoritesViewController *weakSelf = self;

    if(!([[STUserManager sharedManager] isGuestUser]) && !([STUserManager sharedManager].favoritesUpdates)) {
        [STProgressHUD show];
        [[STNetworkAPIManager sharedManager] getFavoriteCollegesForCurrentUserWithSuccess:^(id response) {
            [STProgressHUD dismiss];
            [STUserManager sharedManager].favoritesUpdates = true;
            [weakSelf getAllFavorites];
        } failure:^(NSError *error) {
            [STProgressHUD dismiss];
        }];
    } else {
        [self updateView];
    }
}

- (void) updateView {
    
    if(self.favoritesItems && ([self.favoritesItems count] > 0)) {
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
        
        [self.tableView reloadData];
    }
    else {
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
        [super setEditing:NO animated:YES];
    }
    
    [self updateRightBarButtonItems];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [super setEditing:NO animated:YES];
    [self.tableView setEditing:NO animated:NO];
}

// Setting navigation bar with menu, share and edit button
- (void)setupNavigationBar {
    
    self.title = @"Favorites";
    
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButtonAction:)];
}

// Favorites list editing mode changing
- (void)editORDoneRows {
    
    if(self.editing) {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self doneButtonAction];
    }
    else {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }

    [self.tableView reloadData];
}

- (void) updateRightBarButtonItems {

    if((self.favoritesItems) && (self.favoritesItems.count > 0)) {
                
        if(self.editing) {
            UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(editORDoneRows)];
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton, nil];
        }
        else {
            UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editORDoneRows)];
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton, nil];
        }
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)doneButtonAction {
    
    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];
    localUser.favorites = self.favoritesItems;
    
    __weak STFavoritesViewController *weakSelf = self;

    [STProgressHUD show];

    [weakSelf.localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        [[STNetworkAPIManager sharedManager] updateFavoriteCollegesForCurrentUserWithSuccess:^(id response) {
            [STProgressHUD dismiss];
        } failure:^(NSError *error) {
            [STProgressHUD dismiss];
            [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Something went wrong, please try later"];
        }];
    }];
}

// Favorites share action
- (void)shareFavorites {
    STLog(@"Share action");
}

// Left bar button item action
- (void) onMenuButtonAction:(id)sender {
    
    CGRect viewRect = self.view.frame;
    viewRect.size.width = self.view.frame.size.width*0.75;
    
    UIGraphicsBeginImageContext(viewRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.navigationController.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.delegate capturedImage:image];
    [self.delegate showMenu];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.favoritesItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"FavoriteCell";
    
    STFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    STFavorites *favorite = [self.favoritesItems objectAtIndex:indexPath.row];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", favorite.collegeID];    
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    cell.ibCollegeName.text = college.collegeName;
    cell.ibCollegePlace.text = [NSString stringWithFormat:@"%@, %@", college.city, college.state];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.editing) {
       return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        @try { // Added try block to avoid the app crash in iOS 11 for deleting the rows
            STFavorites *favorite = [self.favoritesItems objectAtIndex:indexPath.row];
            
            [STProgressHUD show];
            
            NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObject:favorite.collegeID forKey:kCollegeID];
            [details setObject:[NSNumber numberWithBool:NO] forKey:kShouldUpdateDatabase];
            
            [[STNetworkAPIManager sharedManager] removeCollegeFromFavouriteWithDetails:details success:^(id response) {
                
                [STProgressHUD dismiss];
                
                STFavorites *favorite = [self.favoritesItems objectAtIndex:indexPath.row];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", favorite.collegeID];
                STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
                
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    STCollege *localCollege = [college MR_inContext:localContext];
                    localCollege.isFavorite = [NSNumber numberWithBool:NO];
                }];
                
                [self.favoritesItems removeObjectAtIndex:indexPath.row];
                
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView endUpdates];
                
                [self doneButtonAction];
                
                [self updateView];
                
            } failure:^(NSError *error) {
                [STProgressHUD dismiss];
            }];
        }
        @catch (NSException *exception) {
            STLog(@"%@", exception);
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    STFavorites *favorite = [self.favoritesItems objectAtIndex:indexPath.row];
    
//    STCollegeDetailViewController *detailViewController = [[STCollegeDetailViewController alloc] initWithNibName:@"STCollegeDetailViewController" bundle:nil];
    
    UIStoryboard *tabBarStoryBoard = [UIStoryboard storyboardWithName:@"TabBarMenu" bundle:nil];
    
    STCollegeDetailViewController *detailViewController = [tabBarStoryBoard instantiateViewControllerWithIdentifier:@"STCollegeDetailViewController"];
    
    detailViewController.isPresenting = YES;
    detailViewController.collegeID = favorite.collegeID;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    detailViewController.edgesForExtendedLayout = UIRectEdgeNone;
    [self presentViewController:navController animated:YES completion:nil];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    STFavorites *dictToMove = self.favoritesItems[fromIndexPath.row];
    [self.favoritesItems removeObjectAtIndex:fromIndexPath.row];
    [self.favoritesItems insertObject:dictToMove atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    STLog(@"Favorites dealloc");
    
    self.delegate = nil;
    self.favoritesItems = nil;
}

@end
