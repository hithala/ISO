//
//  STFilterMajorsViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 22/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import "STFilterMajorsViewController.h"
#import "STFilterMajorCell.h"
#import "STFilterSpecificMajorsViewController.h"
#import "STFilterMajorHeaderView.h"

@interface STFilterMajorsViewController ()

@property (nonatomic, strong) NSOrderedSet *majors;

@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) NSArray *searchedBroadMajors;
@property (nonatomic, strong) NSMutableArray *selectedBroadMajors;

@property (nonatomic, strong) STFilter *filter;

@end

@implementation STFilterMajorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterMajorCell" bundle:nil] forCellReuseIdentifier:@"STFilterMajorCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterMajorHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"STFilterMajorHeaderView"];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = DEFAULT_ROW_HEIGHT;
    self.tableView.estimatedSectionHeaderHeight = DEFAULT_ROW_HEIGHT;
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, -20, 0);

    [super setEditing:YES animated:YES];
    [self.tableView setEditing:YES animated:YES];
    
    if(self.localContext == nil) {
        self.localContext = [NSManagedObjectContext MR_defaultContext];
    }
    
    // Tableview Customization
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = DEFAULT_ROW_HEIGHT;
    
    // Searchbar Customization
    self.searchBar.placeholder = @"Search";
    self.searchBar.tintColor = [UIColor cursorColor];
    self.searchBar.keyboardType = UIKeyboardTypeASCIICapable;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.enablesReturnKeyAutomatically = YES;
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton setFrame:CGRectMake(0, 0, 45, 30)];
    [rightBarButton setTitle:@"Done" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(onDoneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    
    self.selectedBroadMajors = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Broad Majors";
    
    if(self.broadMajors.count == 0) {
        __weak STFilterMajorsViewController *weakSelf = self;
        [STProgressHUD show];
        [[STNetworkAPIManager sharedManager] getMajorsMasterData:^(id response) {
            [STProgressHUD dismiss];
            weakSelf.broadMajors = [response objectForKey:@"majors"];
            [weakSelf.tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
            [weakSelf updateSelectedMajors];
        } failure:^(NSError *error) {
            [STProgressHUD dismiss];
            [weakSelf.tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
            [weakSelf updateSelectedMajors];
        }];
    } else {
        [self updateSelectedMajors];
    }
}

- (void)updateSelectedMajors {
    
    self.filter = [STFilter MR_findFirstInContext:self.localContext];
    self.majors = self.filter.majors;
    
    if(self.selectedBroadMajors.count == 0 || self.majors.count == 0) {
        if(self.majors.count == 0) {
            self.selectedBroadMajors = [NSMutableArray new];
        } else {
            for(STBroadMajor *broadMajor in self.majors) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", broadMajor.name];
                NSDictionary *dict = [self.broadMajors filteredArrayUsingPredicate:predicate].firstObject;
                if(dict) {
                    [self.selectedBroadMajors addObject:dict];
                }
            }
        }
    }

    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"kFilterMajorDidChangeNameNotification" object:nil];
}

- (void)onDoneButtonAction:(id)sender {
    
    NSMutableOrderedSet *majors = [NSMutableOrderedSet orderedSetWithOrderedSet:self.filter.majors];
    
    for(NSDictionary *majorDetails in self.selectedBroadMajors) {
        
        NSString *majorCode = [majorDetails objectForKey:@"code"];
        NSString *majorName = [majorDetails objectForKey:@"name"];
        NSString *majorNickName = [majorDetails objectForKey:@"nickName"];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code=%@", majorCode];

        STBroadMajor *broadMajor = [majors filteredOrderedSetUsingPredicate:predicate].firstObject;

        if(!broadMajor) {
            broadMajor = [STBroadMajor MR_createEntityInContext:self.localContext];
            broadMajor.name = majorName;
            broadMajor.nickName = majorNickName;
            broadMajor.code = majorCode;
            broadMajor.filter = self.filter;
            [majors addObject:broadMajor];
        }

        if(broadMajor) {

            NSArray *specificMajorList = [majorDetails objectForKey:@"specificMajors"];
            NSOrderedSet *specificMajorsList = broadMajor.specificMajors;
            NSMutableOrderedSet *specificMajors = [NSMutableOrderedSet orderedSet];
            
            if(specificMajorsList.count <= 0) {
                for(NSDictionary *specificMajor in specificMajorList) {
                    
                    NSString *specificMajorCode = [specificMajor objectForKey:@"code"];
                    NSString *specificMajorName = [specificMajor objectForKey:@"name"];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code=%@", specificMajorCode];
                    
                    STSpecificMajor *specificMajorr = [specificMajorsList filteredOrderedSetUsingPredicate:predicate].firstObject;
                    
                    if(!specificMajorr) {
                        specificMajorr = [STSpecificMajor MR_createEntityInContext:self.localContext];
                        specificMajorr.name = specificMajorName;
                        specificMajorr.code = specificMajorCode;
                        specificMajorr.broadMajor = broadMajor;
                        [specificMajors addObject:specificMajorr];
                    }
                }
                
                broadMajor.specificMajors = specificMajors;
            }
        }
    }
    
    if(self.selectedBroadMajors.count > 0) {
        self.filter.majors = majors;
    } else {
        self.filter.majors = nil;
    }
    
    [self.localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark KEYBORAD NOTIFICATIONS

- (void)keyboardDidShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
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
    
    self.tableViewBottomConstraint.constant = 0.0;
    [self.tableView layoutIfNeeded];
    [self.searchBar layoutIfNeeded];
}

#pragma mark - Searchbar Delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.isSearching = YES;
    if(self.searchedBroadMajors.count <= 0) {
        self.searchedBroadMajors = self.broadMajors;
    }
}

//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    [searchBar setShowsCancelButton:NO animated:YES];
//    self.isSearching = NO;
//    self.searchedBroadMajors = nil;
//}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.isSearching = NO;
    self.searchedBroadMajors = nil;
    self.selectedBroadMajors = [NSMutableArray new];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSString *trimmedString = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(trimmedString.length != 0) {
        
//        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *majorDetails, NSDictionary *bindings) {
//            NSString *broadMajorName = [majorDetails objectForKey:@"name"];
//            if([broadMajorName rangeOfString:trimmedString options:NSCaseInsensitiveSearch].location != NSNotFound) {
//                return true;
//            } else {
//                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", trimmedString];
//                NSArray *specificMajors = [majorDetails objectForKey:@"specificMajors"];
//                NSArray *filteredSpecificMajors = [specificMajors filteredArrayUsingPredicate:predicate];
//                if(filteredSpecificMajors.count > 0) {
//                    return true;
//                } else {
//                    return false;
//                }
//            }
//            return false;
//        }];
//
//        self.searchedBroadMajors = [self.broadMajors filteredArrayUsingPredicate:predicate];
        self.searchedBroadMajors = self.broadMajors;
        self.isSearching = YES;
    } else {
        self.searchedBroadMajors = self.broadMajors;
        self.isSearching = NO;
    }

    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.isSearching) {
        return self.searchedBroadMajors.count;
    } else {
        return self.broadMajors.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    STFilterMajorHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"STFilterMajorHeaderView"];
    
    NSDictionary *broadMajorDetails = [self.broadMajors objectAtIndex:section];
    
    if(self.isSearching) {
        broadMajorDetails = [self.searchedBroadMajors objectAtIndex:section];
        if([self.selectedBroadMajors containsObject:broadMajorDetails]) {
            [headerView.selectionView setImage:[UIImage imageNamed:@"compare_select_active"] forState:UIControlStateNormal];
        } else {
            [headerView.selectionView setImage:[UIImage imageNamed:@"compare_select_inactive"] forState:UIControlStateNormal];
        }
    }

    headerView.titleLabel.text = [broadMajorDetails objectForKey:@"name"];

    __weak STFilterMajorsViewController *weakSelf = self;
    headerView.headerViewClickActionBlock = ^{
        [weakSelf sectionClickAction:section];
    };

    headerView.majorSelectionActionBlock = ^{
        [weakSelf sectionSelectedAction:section];
    };
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:headerView.bounds];
    backgroundView.backgroundColor = [UIColor whiteColor];
    headerView.backgroundView = backgroundView;

    if(self.isSearching) {
        NSString *trimmedString = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(trimmedString.length != 0) {
            NSArray *specificMajors = [broadMajorDetails objectForKey:@"specificMajors"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", trimmedString];
            NSArray *searchedSpecificMajors = [specificMajors filteredArrayUsingPredicate:predicate];
            if(searchedSpecificMajors.count > 0) {
                NSString *resultCountString = @"";
                if(searchedSpecificMajors.count == 1) {
                    resultCountString = [NSString stringWithFormat:@"%lu Result", (unsigned long)searchedSpecificMajors.count];
                } else {
                    resultCountString = [NSString stringWithFormat:@"%lu Results", (unsigned long)searchedSpecificMajors.count];
                }
                headerView.countLabel.text = resultCountString;
                headerView.countLabelWidthConstraint.constant = 60.0;
                headerView.selectionViewWidthConstraint.constant = 0.0;
                headerView.backgroundButtonView.enabled = YES;
                headerView.disclosureImageView.hidden = NO;
            } else {
                headerView.countLabelWidthConstraint.constant = 0.0;
                headerView.selectionViewWidthConstraint.constant = 25.0;
                headerView.backgroundButtonView.enabled = NO;
                headerView.disclosureImageView.hidden = YES;
            }
        } else {
            headerView.countLabelWidthConstraint.constant = 0.0;
            headerView.selectionViewWidthConstraint.constant = 0.0;
            headerView.backgroundButtonView.enabled = YES;
            headerView.disclosureImageView.hidden = NO;
        }
    } else {
        headerView.countLabelWidthConstraint.constant = 0.0;
        headerView.selectionViewWidthConstraint.constant = 0.0;
        headerView.backgroundButtonView.enabled = YES;
        headerView.disclosureImageView.hidden = NO;
    }

    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(!self.isSearching) {
        NSDictionary *broadMajorDetails = [self.broadMajors objectAtIndex:section];
        NSString *code = [broadMajorDetails objectForKey:@"code"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code=%@", code];
        
        STBroadMajor *broadMajor = [self.majors filteredOrderedSetUsingPredicate:predicate].firstObject;
        
        if(broadMajor) {
            return broadMajor.specificMajors.count;
        }
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    STFilterMajorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterMajorCell" forIndexPath:indexPath];
    
    NSDictionary *broadMajorDetails = [self.broadMajors objectAtIndex:indexPath.section];
    NSString *code = [broadMajorDetails objectForKey:@"code"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code=%@", code];
    
    STBroadMajor *broadMajor = [self.majors filteredOrderedSetUsingPredicate:predicate].firstObject;
    STSpecificMajor *specificMajor = [broadMajor.specificMajors objectAtIndex:indexPath.row];

    cell.titleLabel.text = specificMajor.name;

    cell.countLabelWidthConstraint.constant = 0.0;
    cell.selectionImageviewWidthConstraint.constant = 0.0;
    cell.accessoryType = UITableViewCellAccessoryNone;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        @try {
            
            NSDictionary *broadMajorDetails = [self.broadMajors objectAtIndex:indexPath.section];
            NSString *code = [broadMajorDetails objectForKey:@"code"];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code=%@", code];
            
            STBroadMajor *broadMajor = [self.majors filteredOrderedSetUsingPredicate:predicate].firstObject;
            STSpecificMajor *specificMajor = [broadMajor.specificMajors objectAtIndex:indexPath.row];
            NSUInteger specificMajorsCount = broadMajor.specificMajors.count;
            
            if(specificMajor) {
                [specificMajor MR_deleteEntityInContext:self.localContext];
                specificMajorsCount -= 1;
            }
            
            if(specificMajorsCount <= 0) {
                [broadMajor MR_deleteEntityInContext:self.localContext];
                if([self.selectedBroadMajors containsObject:broadMajorDetails]) {
                    [self.selectedBroadMajors removeObject:broadMajorDetails];
                }
            }
            
            __weak STFilterMajorsViewController *weakSelf= self;
            [self.localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
                [weakSelf.tableView beginUpdates];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableView endUpdates];
            }];
        }
        @catch (NSException *exception) {
            STLog(@"%@", exception);
        }
    }
}

// Section Header Click Action
- (void)sectionClickAction:(NSInteger)section {
    
    self.title = @"";
    
    STFilterSpecificMajorsViewController *specificMajorsViewController = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"FilterSpecificMajorsViewControllerStoryboardID"];
    
    NSString *trimmedString = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSDictionary *broadMajorDetails = [self.broadMajors objectAtIndex:section];
    
    if(self.isSearching) {
        broadMajorDetails = [self.searchedBroadMajors objectAtIndex:section];
    }
    
    specificMajorsViewController.resetUpdateActionBlock = ^{
        if([self.selectedBroadMajors containsObject:broadMajorDetails]) {
            [self.selectedBroadMajors removeObject:broadMajorDetails];
        }
    };
    
    specificMajorsViewController.majorDetails = broadMajorDetails;
    specificMajorsViewController.searchString = trimmedString;
    [self.navigationController pushViewController:specificMajorsViewController animated:YES];
}

// Major Selection Action
- (void)sectionSelectedAction:(NSInteger)section {
    
    if(self.isSearching) {
        NSDictionary *broadMajorDetails = [self.searchedBroadMajors objectAtIndex:section];
        if([self.selectedBroadMajors containsObject:broadMajorDetails]) {
            [self.selectedBroadMajors removeObject:broadMajorDetails];
        } else {
            [self.selectedBroadMajors addObject:broadMajorDetails];
        }

        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

@end
