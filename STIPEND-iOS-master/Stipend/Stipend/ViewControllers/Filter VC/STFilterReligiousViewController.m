//
//  STFilterReligiousViewController.m
//  Stipend
//
//  Created by Ganesh kumar on 02/07/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#define STATE_VIEW_CELLIDENTIFIER    @"STFilterStateCell"
#define TABLEVIEW_HEADER_HEIGHT      44.0
#define ROW_HEIGHT                   44.0
#define KEY_FILTER_RELIGIOUS         @"kFilterReligious"

#import "STFilterReligiousViewController.h"
#import "STFilterStateCell.h"
#import "STFilterStateHeaderView.h"

@interface STFilterReligiousViewController ()
@property (nonatomic, strong) NSArray *religiousListArray;
@end

@implementation STFilterReligiousViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Religious Affiliation";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self updateHeaderAndFooterView];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterStateCell" bundle:nil] forCellReuseIdentifier:STATE_VIEW_CELLIDENTIFIER];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];

    self.localContext = [NSManagedObjectContext MR_defaultContext];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"STCollege"];
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.propertiesToFetch = @[@"religiousAffiliation"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"religiousAffiliation" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    fetchRequest.returnsDistinctResults = YES;
    

//    NSArray *dictionaries = [self.localContext executeFetchRequest:fetchRequest error:nil];
//    STLog(@"list: %@", dictionaries);
//    STLog(@"list count: %lu", (unsigned long)dictionaries.count);
//
    NSArray *religiousAffiliations = [self.localContext executeFetchRequest:fetchRequest error:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *dict, NSDictionary *unused) {
        if(dict.allKeys.count > 0) {
            return true;
        }
        return false;
    }];
    
    self.religiousListArray = [religiousAffiliations filteredArrayUsingPredicate:predicate];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView setContentOffset:CGPointMake(0, -20)];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
}

- (void)doneAction {
    
    NSString *selectedReligious;
    
    if(self.selectedReligiousList.count > 0) {
        selectedReligious = [self.selectedReligiousList componentsJoinedByString:@","];
    } else {
        selectedReligious = @"All";
    }
    
    NSDictionary *notificationDict = @{KEY_FILTER_RELIGIOUS : selectedReligious};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kFilterReligiousDidChangeNameNotification" object:nil userInfo:notificationDict];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateHeaderAndFooterView{
    __weak STFilterReligiousViewController *weakSelf = self;
    STFilterStateHeaderView *headerView = (STFilterStateHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"STFilterStateHeaderView" owner:self options:nil].firstObject;
    headerView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), TABLEVIEW_HEADER_HEIGHT);
    NSString *headerLabelText = headerView.labelField.text;
    
    if(![weakSelf.selectedReligiousList containsObject:headerLabelText]) {
        headerView.checkmarkView.hidden = YES;
    }
    
    headerView.onHeaderActionBlock = ^{
        
        if(![weakSelf.selectedReligiousList containsObject:headerLabelText]) {
            [weakSelf onHeaderViewTapped];
        }
    };
    self.tableView.tableHeaderView = headerView;
}

- (void)onHeaderViewTapped{
    STFilterStateHeaderView *headerView = (STFilterStateHeaderView *)[self.tableView tableHeaderView];
    headerView.checkmarkView.hidden = NO;
    
    [self.selectedReligiousList removeAllObjects];
    
    [self.tableView reloadData];
}

- (void)reloadTableHeaderView{
    STFilterStateHeaderView *headerView = (STFilterStateHeaderView *)[self.tableView tableHeaderView];
    headerView.checkmarkView.hidden = YES;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.religiousListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STFilterStateCell *cell = (STFilterStateCell *)[tableView dequeueReusableCellWithIdentifier:STATE_VIEW_CELLIDENTIFIER forIndexPath:indexPath];
    
    NSDictionary *religiousDetailsDict = [self.religiousListArray objectAtIndex:indexPath.row];
    
    cell.labelField.text  = [religiousDetailsDict objectForKey:@"religiousAffiliation"];
    
    cell.checkmarkView.hidden = YES;
    if([self.selectedReligiousList containsObject:cell.labelField.text]) {
        cell.checkmarkView.hidden = NO;
    }

    cell.seperatorView.hidden = NO;
    if (self.religiousListArray.count == (indexPath.row + 1)) {
        cell.seperatorView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *religiousDict = [self.religiousListArray objectAtIndex:indexPath.row];
    
    NSString *religious = [religiousDict objectForKey:@"religiousAffiliation"];
    
    if([self.selectedReligiousList containsObject:religious]) {
        [self.selectedReligiousList removeObject:religious];
    } else {
        [self.selectedReligiousList addObject:religious];
    }
    
    if([[self.selectedReligiousList firstObject] isEqualToString:@"All"]) {
        [self.selectedReligiousList removeObject:@"All"];
    }
    
    [self reloadTableHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:14.0];
    }
}

- (void)dealloc{
    
    self.selectedReligiousList = nil;
    
    STLog(@"Dealloc");
}

@end
