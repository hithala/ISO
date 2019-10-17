//
//  STFilterSpecificMajorsViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 22/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import "STFilterSpecificMajorsViewController.h"
#import "STFilterMajorCell.h"

@interface STFilterSpecificMajorsViewController ()

@property (nonatomic, strong) NSArray  *specificMajors;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) NSArray *searchedSpecificMajors;
@property (nonatomic, strong) NSMutableArray *selectedSpecificMajors;

@property (nonatomic, strong) STFilter *filter;
@property (nonatomic, strong) STBroadMajor *broadMajor;

@property (nonatomic, assign) BOOL isSelectedAll;

@end

@implementation STFilterSpecificMajorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Specific Majors";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterMajorCell" bundle:nil] forCellReuseIdentifier:@"STFilterMajorCell"];

    self.selectedSpecificMajors = [[NSMutableArray alloc] init];

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

    if(self.localContext == nil) {
        self.localContext = [NSManagedObjectContext MR_defaultContext];
    }

    self.specificMajors = [self.majorDetails objectForKey:@"specificMajors"];

    if(self.searchString.length != 0) {
        self.searchBar.text = self.searchString;
        self.isSearching = YES;
        [self searchForString:self.searchString];
    }

    self.filter = [STFilter MR_findFirstInContext:self.localContext];
    NSOrderedSet *majors = self.filter.majors;

    NSString *code = [self.majorDetails objectForKey:@"code"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code=%@", code];

    self.broadMajor = [majors filteredOrderedSetUsingPredicate:predicate].firstObject;

    if(self.broadMajor) {
        if(self.broadMajor.specificMajors.count > 0) {
            for(STSpecificMajor *major in self.broadMajor.specificMajors) {
                NSDictionary *specificMajor = @{@"name": major.name, @"code": major.code};
                [self.selectedSpecificMajors addObject:specificMajor];
            }
        } else {
            if(self.searchedSpecificMajors.count <= 0) {
                self.searchedSpecificMajors = self.specificMajors;
                self.selectedSpecificMajors = [NSMutableArray arrayWithArray:self.specificMajors];
            }
        }
    }

    [self updateSelectAllState];
}

- (void)onDoneButtonAction:(id)sender {
    
    NSString *majorCode = [self.majorDetails objectForKey:@"code"];
    NSString *majorName = [self.majorDetails objectForKey:@"name"];
    NSString *majorNickName = [self.majorDetails objectForKey:@"nickName"];

    NSMutableOrderedSet *majors = [NSMutableOrderedSet orderedSetWithOrderedSet:self.filter.majors];

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

    if(self.selectedSpecificMajors.count > 0) {
        
        NSMutableOrderedSet *specificMajors = [NSMutableOrderedSet orderedSet];
        
        for(NSDictionary * dict in self.selectedSpecificMajors) {
            
            NSString *name = [dict objectForKey:@"name"];
            NSString *code = [dict objectForKey:@"code"];
            
            STSpecificMajor *major = [STSpecificMajor MR_createEntityInContext:self.localContext];
            major.name = name;
            major.code = code;
            [specificMajors addObject:major];
        }
        broadMajor.specificMajors = specificMajors;
    } else {
        [majors removeObject:broadMajor];
        [broadMajor MR_deleteEntityInContext:self.localContext];
        if(self.resetUpdateActionBlock != nil) {
            self.resetUpdateActionBlock();
        }
    }

    self.filter.majors = majors;
    
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
    self.searchedSpecificMajors = self.specificMajors;
    [self updateSelectAllState];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    self.isSearching = NO;
    self.searchedSpecificMajors = nil;
    [self updateSelectAllState];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    self.isSearching = NO;
    [self.tableView reloadData];
    [self updateSelectAllState];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSString *trimmedString = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(trimmedString.length != 0) {
        [self searchForString:trimmedString];
        self.isSearching = YES;
    } else {
        self.searchedSpecificMajors = self.specificMajors;
        self.isSearching = NO;
        [self.tableView reloadData];
    }
    [self updateSelectAllState];
}

- (void)searchForString:(NSString *)searchString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchString];
    self.searchedSpecificMajors = [self.specificMajors filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isSearching) {
        return self.searchedSpecificMajors.count;
    } else {
        return self.specificMajors.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STFilterMajorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterMajorCell" forIndexPath:indexPath];

    NSDictionary *specificMajorDetails = [self.specificMajors objectAtIndex:indexPath.row];

    @try {
        if(self.isSearching && (self.searchedSpecificMajors && self.searchedSpecificMajors.count > 0)) {
            specificMajorDetails = [self.searchedSpecificMajors objectAtIndex:indexPath.row + 1];
        }
        
        cell.titleLabel.text = [specificMajorDetails objectForKey:@"name"];
        
        if([self.selectedSpecificMajors containsObject:specificMajorDetails]) {
            cell.selectionImageView.image = [UIImage imageNamed:@"compare_select_active"];
        } else {
            cell.selectionImageView.image = [UIImage imageNamed:@"compare_select_inactive"];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionImageviewTrailingConstraint.constant = 15.0;
        cell.countLabelWidthConstraint.constant = 0.0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } @catch (NSException *exception) {
        STLog(@"******* Exception: %@ *******", exception);
        
        cell.titleLabel.text = @"";
        cell.selectionImageView.image = [UIImage new];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionImageviewTrailingConstraint.constant = 0.0;
        cell.countLabelWidthConstraint.constant = 0.0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        
        NSDictionary *specificMajor;
        
        if(self.isSearching) {
            specificMajor = [self.searchedSpecificMajors objectAtIndex:indexPath.row];
        } else {
            specificMajor = [self.specificMajors objectAtIndex:indexPath.row];
        }
        
        if([self.selectedSpecificMajors containsObject:specificMajor]) {
            [self.selectedSpecificMajors removeObject:specificMajor];
        } else {
            [self.selectedSpecificMajors addObject:specificMajor];
        }
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self updateSelectAllState];

    } @catch (NSException *exception) {
        STLog(@"%@", exception);
    }
}

- (IBAction)selectAllAction:(id)sender {
    
    if(self.isSelectedAll) {
        self.selectedSpecificMajors = [NSMutableArray new];
    } else {
        if(self.isSearching) {
            self.selectedSpecificMajors = [NSMutableArray arrayWithArray:self.searchedSpecificMajors];
        } else {
            self.selectedSpecificMajors = [NSMutableArray arrayWithArray:self.specificMajors];
        }
    }
    
    [self.tableView reloadData];
    [self updateSelectAllState];
}

- (void)updateSelectAllState {

    if(self.isSearching) {
        if((self.selectedSpecificMajors.count > 0) && (self.searchedSpecificMajors.count > 0) && (self.selectedSpecificMajors.count >= self.searchedSpecificMajors.count)) {
            self.isSelectedAll = YES;
        } else {
            self.isSelectedAll = NO;
        }
        if(self.searchedSpecificMajors.count > 0) {
            self.selectAllButton.hidden = NO;
        } else {
            self.selectAllButton.hidden = YES;
        }
    } else {
        if((self.selectedSpecificMajors.count > 0) && (self.specificMajors.count > 0) && (self.selectedSpecificMajors.count == self.specificMajors.count)) {
            self.isSelectedAll = YES;
        } else {
            self.isSelectedAll = NO;
        }
        if(self.specificMajors.count > 0) {
            self.selectAllButton.hidden = NO;
        } else {
            self.selectAllButton.hidden = YES;
        }
    }
    
    if(self.isSelectedAll) {
         [self.selectAllButton setTitle:@"Reset" forState:UIControlStateNormal];
    } else {
         [self.selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
    }

    if(self.isSearching) {
        self.searchTitleLabel.hidden = NO;
    } else {
        self.searchTitleLabel.hidden = YES;
    }
}

@end
