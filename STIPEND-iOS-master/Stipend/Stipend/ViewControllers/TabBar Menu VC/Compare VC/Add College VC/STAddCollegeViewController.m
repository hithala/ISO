//
//  STAddCollegeViewController.m
//  Stipend
//
//  Created by sourcebits on 28/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAddCollegeViewController.h"
#import "STCollege.h"
#import "STFavorites.h"
#import "STCompareItem.h"

#import "STAddCollegeCell.h"
#import "STAddCollegeSectionView.h"

#define ROW_HEIGHT                      60.0
#define HEADER_VIEW_HEIGHT              40.0

@interface STAddCollegeViewController ()

@property (nonatomic, retain) NSMutableArray   *selectedColleges;
@property (nonatomic, assign) NSInteger             currentCount;

@end

@implementation STAddCollegeViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(self.localContext == nil) {
        self.localContext = [NSManagedObjectContext MR_context];
    }
    
    self.isFavoriteAllSelected = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"STAddCollegeCell" bundle:nil] forCellReuseIdentifier:@"STAddCollegeCell"];
    
    self.searchBar.placeholder = @"Search";
    self.searchBar.tintColor = [UIColor cursorColor];
    self.searchBar.keyboardType = UIKeyboardTypeASCIICapable;
//    self.searchBar.returnKeyType = UIReturnKeyDefault;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.enablesReturnKeyAutomatically = YES;
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar becomeFirstResponder];
    
    self.selectedColleges = [NSMutableArray new];

    [self setupNavigationBar];
    [self getAllColleges];
    [self initializeRecentSearch];
    
}

- (void) updateSearchResultTableHeaderView {
    
    STAddCollegeSectionView *headerView = (STAddCollegeSectionView *)[self.view viewWithTag:1125];
    
    if(!headerView) {
        headerView = [[NSBundle mainBundle] loadNibNamed:@"STAddCollegeSectionView" owner:self options:nil][0];
        headerView.separatorView.hidden = YES;
        headerView.tag = 1125;
        
        headerView.titleLabel.text = @"FAVORITES";
        headerView.titleLabel.tag = 1126;
        headerView.selectAllButton.tag = 1127;
        
        headerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT);
        
        __weak STAddCollegeViewController *weakSelf = self;

        headerView.selectAllAction = ^{
            if(!weakSelf.isFavoriteAllSelected) {
                weakSelf.isFavoriteAllSelected = YES;
                [weakSelf selectAllFavoriteColleges];
            }
            else {
                weakSelf.isFavoriteAllSelected = NO;
                [weakSelf unSelectAllFavoriteColleges];
            }
        };
        
        self.tableView.tableHeaderView = headerView;
    }
}

- (void) selectAllFavoriteColleges {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isAddedToCompare == NO AND isFavorite == YES"];
    
    NSArray *favoriteListNotInComapre = [[STCollege MR_findAllWithPredicate:predicate inContext:self.localContext] mutableCopy];
    NSInteger favoriteCount = [favoriteListNotInComapre count];

    NSInteger compareItemsCount = [self getCompareListCount];
    
    if((favoriteCount + compareItemsCount) > 15) {
        [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"You may only compare 15 colleges at once."];
    }
    else {
        
        for (NSInteger index = 0; index < [self.searchArray count] ; index++) {
            
            STCollege *selectedCollege = [self.searchArray objectAtIndex:index];
            BOOL isAdded = [selectedCollege.isAddedToCompare boolValue];
            
            if(!isAdded) {
                selectedCollege.isAddedToCompare = [NSNumber numberWithBool:!isAdded];
                [self.selectedColleges addObject:selectedCollege];
            }
        }
        
        [self.tableView reloadData];
        [self validateSelectAllButtonLabel];
    }
}

- (void) unSelectAllFavoriteColleges {
    
    for (NSInteger index = 0; index < [self.searchArray count] ; index++) {
        
        STCollege *selectedCollege = [self.searchArray objectAtIndex:index];
        BOOL isAdded = [selectedCollege.isAddedToCompare boolValue];
        
        if(isAdded) {
            selectedCollege.isAddedToCompare = [NSNumber numberWithBool:!isAdded];
            [self.selectedColleges removeObject:selectedCollege];
        }
    }
    
    [self.tableView reloadData];
    [self validateSelectAllButtonLabel];
}

- (void) validateSelectAllButtonLabel {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isAddedToCompare == YES AND isFavorite == YES"];
    NSArray *favoriteListInComapre = [[STCollege MR_findAllWithPredicate:predicate inContext:self.localContext] mutableCopy];
    
    predicate = [NSPredicate predicateWithFormat:@"user == %@", [[STUserManager sharedManager] getCurrentUserInContext:self.localContext]];
    NSArray *favoriteList = [[STFavorites MR_findAllSortedBy:@"collegeID" ascending:YES withPredicate:predicate inContext:self.localContext] mutableCopy];

    
    if([favoriteListInComapre count] < [favoriteList count]) {
        self.isFavoriteAllSelected = NO;
    }
    else {
        self.isFavoriteAllSelected = YES;
    }

    [self updateSelectAllButtonLabel];
}

- (void) updateSelectAllButtonLabel {
    
    STAddCollegeSectionView *headerView = (STAddCollegeSectionView *)[self.view viewWithTag:1125];

    if(headerView) {
        if(self.isFavoriteAllSelected) {
            [headerView.selectAllButton setTitle:@"Unselect All" forState:UIControlStateNormal];
            [headerView.selectAllButton setTitle:@"Unselect All" forState:UIControlStateHighlighted];
        }
        else {
            [headerView.selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
            [headerView.selectAllButton setTitle:@"Select All" forState:UIControlStateHighlighted];
        }
    }
}

- (void)setupNavigationBar {

    self.title = @"Add Colleges";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonAction)];
}

- (NSInteger)getCompareListCount {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isAddedToCompare == YES"];
    NSArray *compareList = [[STCollege MR_findAllWithPredicate:predicate inContext:self.localContext] mutableCopy];
    
    return compareList.count;
}

- (void)getAllColleges {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@", [[STUserManager sharedManager] getCurrentUserInContext:self.localContext]];
    NSArray *favoriteList = [[STFavorites MR_findAllSortedBy:@"collegeID" ascending:YES withPredicate:predicate inContext:self.localContext] mutableCopy];
    
    for(STFavorites *favorite in favoriteList) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", favorite.collegeID];
        STCollege *college = [STCollege MR_findFirstWithPredicate:predicate inContext:self.localContext];
        college.isFavorite = [NSNumber numberWithBool:YES];
    }
    
    predicate = [NSPredicate predicateWithFormat:@"user == %@", [[STUserManager sharedManager] getCurrentUserInContext:self.localContext]];
    NSArray *compareList = [[STCompareItem MR_findAllWithPredicate:predicate inContext:self.localContext] mutableCopy];
    
    for(STCompareItem *compareItem in compareList) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", compareItem.collegeID];
        STCollege *college = [STCollege MR_findFirstWithPredicate:predicate inContext:self.localContext];
        college.isAddedToCompare = [NSNumber numberWithBool:YES];
        
        if(![self.selectedColleges containsObject:college]) {
            [self.selectedColleges addObject:college];
        }
    }
    
    [self.tableView reloadData];
}

- (void)cancelButtonAction {
    
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonAction {

    [self.searchBar resignFirstResponder];

    [STProgressHUD show];
    [self saveAllCollegesAddedToComapare];
}

- (void) saveCompareItems {
    
    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];
    NSArray *oldCompareList = [[localUser compareItems] mutableCopy];
    
    __weak STAddCollegeViewController *weakSelf = self;
    __block NSInteger count = 0;

    for (STCompareItem *item in oldCompareList) {
        
        STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@",item.collegeID] inContext:self.localContext];
        
        if([[college isAddedToCompare] boolValue]) {
            count++;
            if(count == [oldCompareList count]) {
                [weakSelf checkAndDismissDoneBlockWithCompletionIndex:count totalIndex:[oldCompareList count]];
            }
        }
        else {
            
            NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:college.collegeID,kCollegeID, nil];
            [details setObject:[NSNumber numberWithBool:YES] forKey:kShouldUpdateDatabase];
            
            [[STNetworkAPIManager sharedManager] removeCollegeFromCompareWithDetails:details success:^(id response) {
                
                count++;
                
                if(count == [oldCompareList count]) {
                    [weakSelf checkAndDismissDoneBlockWithCompletionIndex:count totalIndex:[oldCompareList count]];
                }
            } failure:^(NSError *error) {
                
                count++;
                if(count == [oldCompareList count]) {
                    [weakSelf checkAndDismissDoneBlockWithCompletionIndex:count totalIndex:[oldCompareList count]];
                }
            }];
        }
    }
    
    if([oldCompareList count] == 0) {
        [weakSelf checkAndDismissDoneBlockWithCompletionIndex:count totalIndex:[oldCompareList count]];
    }
}

- (void) saveAllCollegesAddedToComapare {
    
    __weak STAddCollegeViewController *weakSelf = self;
    __block NSInteger count = 0;
    
    
//    NSArray *compareListItems = [STCollege MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"isAddedToCompare == YES"] inContext:self.localContext];
    
//    NSArray *compareListItems = [STCollege MR_findAllSortedBy:@"collegeName" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"isAddedToCompare == YES"] inContext:self.localContext];
    
    NSArray *compareListItems = self.selectedColleges;
    
    NSMutableArray *newList = [NSMutableArray new];
    
    for(STCollege *college in compareListItems) {
        
        NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:college.collegeID,kCollegeID, nil];
        [details setObject:[NSNumber numberWithBool:YES] forKey:kShouldUpdateDatabase];
        
        STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];
        STCompareItem *compareItem = [STCompareItem MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user == %@ and collegeID == %@",localUser, college.collegeID]];
        
        if(compareItem) {
            count++;
            if(count == [compareListItems count]) {
                [weakSelf saveCompareItems];
            }
        }
        else {
            
            [newList addObject:college];
            
//            [[STNetworkAPIManager sharedManager] addCollegeToCompareWithDetails:details success:^(id response) {
//                
//                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//                    STCollege *localCollege = [college MR_inContext:localContext];
//                    localCollege.shouldUpdate = [NSNumber numberWithBool:NO];
//                } completion:^(BOOL contextDidSave, NSError *error) {
//                    count++;
//                    
//                    if(count == [compareListItems count]) {
//                        [weakSelf saveCompareItems];
//                    }
//                }];
//                
//            } failure:^(NSError *error) {
//                count++;
//                if(count == [compareListItems count]) {
//                    [weakSelf saveCompareItems];
//                }
//            }];
        }
    }
    
    if(newList.count > 0) {
        self.currentCount = 0;
        [self addCollegesToCompare:newList success:^(id response) {
            [weakSelf saveCompareItems];
        }];
    }
    
    if([compareListItems count] == 0) {
        [weakSelf saveCompareItems];
    }
}

- (void)addCollegesToCompare:(NSArray *)colleges success:(STSuccessBlock)successBlock {
    
    NSInteger totalCount = colleges.count;
    
    __weak STAddCollegeViewController *weakSelf = self;

    if(self.currentCount < totalCount) {
        
        STCollege *college = [colleges objectAtIndex:self.currentCount];
        
        NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:college.collegeID,kCollegeID, nil];
        [details setObject:[NSNumber numberWithBool:YES] forKey:kShouldUpdateDatabase];
        
        [[STNetworkAPIManager sharedManager] addCollegeToCompareWithDetails:details success:^(id response) {
            
            self.currentCount++;
            
            [weakSelf addCollegesToCompare:colleges success:^(id response) {
                if(successBlock){
                    successBlock([NSNull null]);
                }
            }];
            
        } failure:^(NSError *error) {
            
            self.currentCount++;
            
            [weakSelf addCollegesToCompare:colleges success:^(id response) {
                if(successBlock){
                    successBlock([NSNull null]);
                }
            }];
        }];
        
    } else {
        
        if(successBlock){
            successBlock([NSNull null]);
        }
    }
}

- (void) checkAndDismissDoneBlockWithCompletionIndex:(NSInteger) currentIndex totalIndex:(NSInteger) totalCount {
    
    if(currentIndex == totalCount) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [STProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

#pragma mark KEYBORAD NOTIFICATIONS

- (void)keyboardDidShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
//    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    CGFloat viewHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if(viewHeight >= 812) {
        self.tableViewBottomConstraint.constant = kbSize.height - 30;
    } else {
        self.tableViewBottomConstraint.constant = kbSize.height;
    }
    
    [self.tableView layoutIfNeeded];
    [self.searchBar layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
//    [self.searchBar setShowsCancelButton:NO animated:YES];

    self.tableViewBottomConstraint.constant = 0.0;
    [self.tableView layoutIfNeeded];
    [self.searchBar layoutIfNeeded];
}

#pragma mark SEARCH BAR DELEGATES

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if(self.searchArray.count > 0) {
        [searchBar resignFirstResponder];
    }
    else {
    }
    
//    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(searchBar.text.length == 0) {
        [self initializeRecentSearch];
    }
    else {
        
        NSString *predicateString = [NSString stringWithFormat:@"collegeName CONTAINS[c] \"%@\"", searchBar.text];
        
        STUser *localUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
        
        if ([localUser.isAdmin boolValue] == NO) {
            predicateString = [NSString stringWithFormat:@"%@ AND isActive ==%@", predicateString, [NSNumber numberWithBool:YES]];
        }
        
        @try {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
            
            NSArray *searchResultArray = [STCollege MR_findAllSortedBy:@"collegeName" ascending:YES withPredicate:predicate inContext:self.localContext];
            
            self.searchArray = [NSMutableArray arrayWithArray:searchResultArray];
            
            [self toggleSearch:NO];
            
            if([self.searchArray count] == 0) {
                UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
                messageLabel.text = @"No Results";
                messageLabel.textColor = [UIColor lightGrayColor];
                messageLabel.numberOfLines = 0;
                messageLabel.textAlignment = NSTextAlignmentCenter;
                messageLabel.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:25];
                [messageLabel sizeToFit];
                
                self.tableView.backgroundView = messageLabel;
            }
            else {
                self.tableView.backgroundView = nil;
            }
        }
        @catch(NSException *exception) {
            STLog(@"exception: %@", exception);
        }
    }
}

- (void) initializeRecentSearch {
    
//    NSArray *searchResultArray = [STCollege MR_findAllSortedBy:@"collegeName" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"isFavorite == YES"] inContext:self.localContext];
   // self.searchArray = [NSMutableArray arrayWithArray:searchResultArray];
    self.searchArray = [[NSMutableArray alloc] init];

    [self updateSearchResultTableHeaderView];
    [self validateSelectAllButtonLabel];
    [self toggleSearch:YES];
}

- (void) toggleSearch:(BOOL) showRecentSearch {
    
    if(showRecentSearch) {
        self.showRecentSearches = YES;
        
        STAddCollegeSectionView *headerView = (STAddCollegeSectionView *)self.tableView.tableHeaderView;
        UILabel *titleLabel = (UILabel *)[headerView viewWithTag:1126];
        [titleLabel setText:@"FAVORITES"];
        titleLabel.hidden = NO;
        
        UIButton *selectAllButton = (UIButton *)[headerView viewWithTag:1127];
        selectAllButton.hidden = NO;

        if(self.searchArray && ([self.searchArray count] == 0)) {
            selectAllButton.hidden = YES;
            titleLabel.hidden = YES;
        }
        
        [self.tableView reloadData];
    }
    else {
        self.showRecentSearches = NO;
        
        STAddCollegeSectionView *headerView = (STAddCollegeSectionView *)self.tableView.tableHeaderView;
        UILabel *titleLabel = (UILabel *)[headerView viewWithTag:1126];
        [titleLabel setText:@"SEARCH RESULTS"];
        titleLabel.hidden = NO;

        UIButton *selectAllButton = (UIButton *)[headerView viewWithTag:1127];
        selectAllButton.hidden = YES;
        
        if(self.searchArray && ([self.searchArray count] == 0)) {
            titleLabel.hidden = YES;
        }

        [self.tableView reloadData];
    }
}

- (void) resetSearch {
    
    [self.searchArray removeAllObjects];
}

#pragma mark SEARCH TABLE VIEW DATASOURCE

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ROW_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STAddCollegeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STAddCollegeCell" forIndexPath:indexPath];
    
    if(!self.showRecentSearches) {
        
        STCollege *college = [self.searchArray objectAtIndex:indexPath.row];
        
        BOOL isAdded = [college.isAddedToCompare integerValue];
        
        if(isAdded) {
            cell.selectionImage.image = [UIImage imageNamed:@"compare_select_active"];
        } else {
            cell.selectionImage.image = [UIImage imageNamed:@"compare_select_inactive"];
        }
        
        cell.titleLabel.text = college.collegeName;
        cell.placeLabel.text = college.place;
        
    } else {
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        STCollege *college = [self.searchArray objectAtIndex:indexPath.row];
        
        BOOL isAdded = [college.isAddedToCompare integerValue];
        
        if(isAdded) {
            cell.selectionImage.image = [UIImage imageNamed:@"compare_select_active"];
        } else {
            cell.selectionImage.image = [UIImage imageNamed:@"compare_select_inactive"];
        }
        
        cell.titleLabel.text = college.collegeName;
        cell.placeLabel.text = college.place;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @try {

        STCollege *selectedCollege = [self.searchArray objectAtIndex:indexPath.row];
        
        BOOL isAdded = [selectedCollege.isAddedToCompare boolValue];
        
        if(!isAdded) {
            
            NSInteger compareCount = [self getCompareListCount];
            
            if(compareCount < 15) {
                
                [self.selectedColleges addObject:selectedCollege];
                
                selectedCollege.isAddedToCompare = [NSNumber numberWithBool:!isAdded];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            } else {
                [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"You may only compare 15 colleges at once."];
            }
        } else {
            
            [self.selectedColleges removeObject:selectedCollege];
            
            selectedCollege.isAddedToCompare = [NSNumber numberWithBool:!isAdded];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [self validateSelectAllButtonLabel];
        
        [self.searchBar resignFirstResponder];
        
    } @catch (NSException *exception) {
        STLog(@"%@", exception);
    }
}

- (void)dealloc {
    
    self.searchArray = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
