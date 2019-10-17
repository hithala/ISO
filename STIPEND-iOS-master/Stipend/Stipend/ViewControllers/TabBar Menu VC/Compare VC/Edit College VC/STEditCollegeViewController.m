//
//  STEditCollegeViewController.m
//  Stipend
//
//  Created by Arun S on 08/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STEditCollegeViewController.h"
#import "STAddCollegeViewController.h"
#import "STCompareItem.h"
#import "STCollege.h"

#import "STFavoriteCell.h"

#define ROW_HEIGHT      60.0

@implementation STEditCollegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Edit Colleges";

    [self.tableView registerNib:[UINib nibWithNibName:@"STFavoriteCell" bundle:nil] forCellReuseIdentifier:@"FavoriteCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction:)];
    //self.navigationItem.leftBarButtonItem = doneButton;

    
    self.rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBarButton setFrame:CGRectMake(0, 0, 35, 30)];
    [self.rightBarButton setTitle:@"Add" forState:UIControlStateNormal];
    [self.rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBarButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.localContext = [NSManagedObjectContext MR_context];
    
    [self getCompareItems];
    
    [self.tableView setEditing:YES animated:YES];
    [self.tableView reloadData];

    [super viewWillAppear:animated];
    
    [self updateDescriptionLabel];
}

- (void) getCompareItems {
    
    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];
    self.compareItems = [[localUser compareItems] mutableCopy];
}

- (IBAction)addButtonAction:(id)sender {
    
    STAddCollegeViewController *addController = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:ADD_COMPARE_STORYBOARD_ID];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)doneButtonAction:(id)sender {
    
    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];
    localUser.compareItems = self.compareItems;
    
    [self.localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)updateDescriptionLabel {
    
    NSInteger compareCount = self.compareItems.count;
    self.descriptionLabel.text = [NSString stringWithFormat:@"Comparing %ld of 15 colleges", (long)compareCount];
    
    if(compareCount == 15) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.rightBarButton.enabled = NO;
            self.rightBarButton.titleLabel.alpha = 0.5;

        }];
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.rightBarButton.enabled = YES;
            self.rightBarButton.titleLabel.alpha = 1.0;
            
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.compareItems.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    STCompareItem *item = self.compareItems[indexPath.row];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", item.collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    cell.ibCollegeName.text = college.collegeName;
    cell.ibCollegePlace.text = [NSString stringWithFormat:@"%@, %@", college.city, college.state];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        @try {
            STCompareItem *item = [self.compareItems objectAtIndex:indexPath.row];
            
            NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:item.collegeID,kCollegeID, nil];
            [details setObject:[NSNumber numberWithBool:NO] forKey:kShouldUpdateDatabase];
            
            __weak STEditCollegeViewController *weakSelf = self;
            
            [STProgressHUD show];
            [[STNetworkAPIManager sharedManager] removeCollegeFromCompareWithDetails:details success:^(id response) {
                
                @try {
                    
                    [STProgressHUD dismiss];
                    
                    STCompareItem *item = [self.compareItems objectAtIndex:indexPath.row];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", item.collegeID];
                    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
                    
                    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                        STCollege *localCollege = [college MR_inContext:localContext];
                        localCollege.isAddedToCompare = [NSNumber numberWithBool:NO];
                    }];
                    
                    [weakSelf.compareItems removeObjectAtIndex:indexPath.row];
                    
                    [tableView beginUpdates];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [tableView endUpdates];
                    
                    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];
                    localUser.compareItems = self.compareItems;
                    
                    [weakSelf.localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    }];
                    
                    [weakSelf updateDescriptionLabel];
                    
                }
                @catch(NSException *exception) {
                    STLog(@"%@", exception);
                    [STProgressHUD dismissWithStatus:@"Something went wrong!, Please try it later" isSucces:false];
                }
                
            } failure:^(NSError *error) {
            }];
        }
        @catch(NSException *exception) {
            STLog(@"%@", exception);
            [STProgressHUD dismissWithStatus:@"Something went wrong!, Please try it later" isSucces:false];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    if(fromIndexPath.row != toIndexPath.row) {
        STCompareItem *item = self.compareItems[fromIndexPath.row];
        [self.compareItems removeObjectAtIndex:fromIndexPath.row];
        [self.compareItems insertObject:item atIndex:toIndexPath.row];
        
        STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];
        localUser.compareItems = self.compareItems;
        
        [STProgressHUD show];

        [self.localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            [[STNetworkAPIManager sharedManager] updateCompareCollegesForCurrentUserWithSuccess:^(id response) {
                [STProgressHUD dismiss];
            } failure:^(NSError *error) {
                [STProgressHUD dismiss];
                [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Something went wrong, please try later"];
            }];
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)dealloc {
    
    self.compareItems = nil;
}

@end
