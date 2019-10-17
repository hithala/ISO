//
//  STFilterStateViewController.m
//  Stipend
//
//  Created by Arun S on 14/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#define STATE_VIEW_CELLIDENTIFIER    @"STFilterStateCell"
#define TABLEVIEW_HEADER_HEIGHT      44.0
#define ROW_HEIGHT                   44.0
#define KEY_FILTER_STATE_NAME        @"kFilterStateName"
#define KEY_FILTER_STATE_CODE        @"kFilterStateCode"


#import "STFilterStateViewController.h"
#import "STFilterStateCell.h"
#import "STFilterStateHeaderView.h"

@interface STFilterStateViewController ()
@property (nonatomic, strong) NSDictionary *stateListDict;
@property (nonatomic, strong) NSArray *stateListArray;
@property (nonatomic, strong) NSArray *stateIndexTitles;
@end

@implementation STFilterStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"United States";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.stateListDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ListOfUnitedStates" ofType:@"plist"]];
    self.stateListArray = [self.stateListDict objectForKey:@"StatesList"];
    self.stateIndexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    /*if([self.selectedStateNameList containsObject:@"All"]) {
        [self selectAllStates];
    }*/
    
    [self updateHeaderAndFooterView];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterStateCell" bundle:nil] forCellReuseIdentifier:STATE_VIEW_CELLIDENTIFIER];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView setContentOffset:CGPointMake(0, -20)];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
}

- (void)doneAction {

    NSString *selectedStateNames;
    NSString *selectedStateCodes;
    
    if(self.selectedStateNameList.count > 0) {
        selectedStateNames = [self.selectedStateNameList componentsJoinedByString:@","];
    } else {
        selectedStateNames = @"All";
    }
    
    /* if(self.selectedStateNameList.count == 50) {
     selectedStateNames = @"All";
     }*/
    
    if(self.selectedStateCodeList.count > 0) {
        selectedStateCodes = [self.selectedStateCodeList componentsJoinedByString:@","];
    } else {
        selectedStateCodes = @"All";
    }
    
    /* if(self.selectedStateCodeList.count == 50) {
     selectedStateCodes = @"All";
     }*/
    
    NSDictionary *notificationDict = @{KEY_FILTER_STATE_NAME : selectedStateNames, KEY_FILTER_STATE_CODE : selectedStateCodes};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kFilterStateDidChangeNameNotification" object:nil userInfo:notificationDict];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateHeaderAndFooterView{
    __weak STFilterStateViewController *weakSelf = self;
    STFilterStateHeaderView *headerView = (STFilterStateHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"STFilterStateHeaderView" owner:self options:nil].firstObject;
    headerView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.tableView.frame), TABLEVIEW_HEADER_HEIGHT);
    NSString *headerLabelText = headerView.labelField.text;
    
    if(![weakSelf.selectedStateNameList containsObject:headerLabelText]) {
        headerView.checkmarkView.hidden = YES;
    }
    
    /*if(self.selectedStateNameList.count == 50) {
        headerView.checkmarkView.hidden = NO;
    }*/
    
    headerView.onHeaderActionBlock = ^{
        
        if(![weakSelf.selectedStateNameList containsObject:headerLabelText]) {
            [weakSelf onHeaderViewTapped];
        }
    };
    self.tableView.tableHeaderView = headerView;
}

- (void)onHeaderViewTapped{
    STFilterStateHeaderView *headerView = (STFilterStateHeaderView *)[self.tableView tableHeaderView];
    headerView.checkmarkView.hidden = NO;
    
    /*if(self.selectedStateNameList.count == 50) {
        
        headerView.checkmarkView.hidden = YES;
        
        [self.selectedStateNameList removeAllObjects];
        [self.selectedStateCodeList removeAllObjects];
        
    } else {
        
        headerView.checkmarkView.hidden = NO;
        
        [self selectAllStates];
    }*/
    
    [self.selectedStateNameList removeAllObjects];
    [self.selectedStateCodeList removeAllObjects];
    
    [self.tableView reloadData];
}

- (void)reloadTableHeaderView{
    STFilterStateHeaderView *headerView = (STFilterStateHeaderView *)[self.tableView tableHeaderView];
    headerView.checkmarkView.hidden = YES;
    
    /*if(self.selectedStateNameList.count == 50) {
        headerView.checkmarkView.hidden = NO;
    } else {
        headerView.checkmarkView.hidden = YES;
    }*/
    
    /*if(self.selectedStateNameList.count == 0) {
        headerView.checkmarkView.hidden = NO;
    } else {
        headerView.checkmarkView.hidden = YES;
    }*/
    
    [self.tableView reloadData];
}

- (void)selectAllStates {
    
    [self.selectedStateNameList removeAllObjects];
    [self.selectedStateCodeList removeAllObjects];
    
    
    for(NSDictionary *stateDetailsDict in self.stateListArray){
        
        NSArray *stateDetailsArray = [stateDetailsDict objectForKey:@"StateNames"];
        
        for(NSDictionary *stateDict in stateDetailsArray) {
            
            NSString *stateName = [stateDict objectForKey:@"StateName"];
            
            if([self.selectedStateNameList containsObject:stateName]) {
                [self.selectedStateNameList removeObject:stateName];
            } else {
                [self.selectedStateNameList addObject:stateName];
            }
            
            if([[self.selectedStateNameList firstObject] isEqualToString:@"All"]) {
                [self.selectedStateNameList removeObject:@"All"];
            }
            
            NSString *stateCode = [stateDict objectForKey:@"StateCode"];
            
            if([self.selectedStateCodeList containsObject:stateCode]) {
                [self.selectedStateCodeList removeObject:stateCode];
            } else {
                [self.selectedStateCodeList addObject:stateCode];
            }
            
            if([[self.selectedStateCodeList firstObject] isEqualToString:@"All"]) {
                [self.selectedStateCodeList removeObject:@"All"];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.stateListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSDictionary *stateDetailsDict = [self.stateListArray objectAtIndex:section];
    NSArray *stateDetailsArray = [stateDetailsDict objectForKey:@"StateNames"];
    return stateDetailsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STFilterStateCell *cell = (STFilterStateCell *)[tableView dequeueReusableCellWithIdentifier:STATE_VIEW_CELLIDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *stateDetailsDict = [self.stateListArray objectAtIndex:indexPath.section];
    NSArray *stateDetailsArray = [stateDetailsDict objectForKey:@"StateNames"];
    NSDictionary *stateDict = [stateDetailsArray objectAtIndex:indexPath.row];
    
    cell.labelField.text  = [stateDict objectForKey:@"StateName"];
    
    cell.checkmarkView.hidden = YES;
    if([self.selectedStateNameList containsObject:cell.labelField.text]) {
        cell.checkmarkView.hidden = NO;
    }
    
    cell.seperatorView.hidden = NO;
    if (stateDetailsArray.count == (indexPath.row + 1)) {
        cell.seperatorView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *stateDetailsDict = [self.stateListArray objectAtIndex:indexPath.section];
    NSArray *stateDetailsArray = [stateDetailsDict objectForKey:@"StateNames"];
    NSDictionary *stateDict = [stateDetailsArray objectAtIndex:indexPath.row];
    
    NSString *stateName = [stateDict objectForKey:@"StateName"];
    NSString *stateCode = [stateDict objectForKey:@"StateCode"];

    if([self.selectedStateNameList containsObject:stateName]) {
        [self.selectedStateNameList removeObject:stateName];
    } else {
        [self.selectedStateNameList addObject:stateName];
    }
    
    if([[self.selectedStateNameList firstObject] isEqualToString:@"All"]) {
        [self.selectedStateNameList removeObject:@"All"];
    }
    
    if([self.selectedStateCodeList containsObject:stateCode]) {
        [self.selectedStateCodeList removeObject:stateCode];
    } else {
        [self.selectedStateCodeList addObject:stateCode];
    }
    
    if([[self.selectedStateCodeList firstObject] isEqualToString:@"All"]) {
        [self.selectedStateCodeList removeObject:@"All"];
    }
    
    [self reloadTableHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ROW_HEIGHT;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.stateIndexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *stateDetailsDict = [self.stateListArray objectAtIndex:section];
    NSString *sectionTile = [stateDetailsDict objectForKey:@"SectionTitle"];
    return sectionTile;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    NSPredicate *predExists = [NSPredicate predicateWithFormat:
                               @"%K MATCHES[c] %@",@"SectionTitle",title];
    NSInteger getIndex = [self.stateListArray indexOfObjectPassingTest:
                        ^(id obj, NSUInteger idx, BOOL *stop) {
                            return [predExists evaluateWithObject:obj];
                        }];
    STLog(@"getIndex == %ld",(long)getIndex);
    return getIndex;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:14.0];
    }
}

#pragma UIView Unload Methods
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSString *selectedStateNames;
    NSString *selectedStateCodes;
    
    if(self.selectedStateNameList.count > 0) {
        selectedStateNames = [self.selectedStateNameList componentsJoinedByString:@","];
    } else {
        selectedStateNames = @"All";
    }
    
    if(self.selectedStateCodeList.count > 0) {
        selectedStateCodes = [self.selectedStateCodeList componentsJoinedByString:@","];
    } else {
        selectedStateCodes = @"All";
    }

    NSDictionary *notificationDict = @{KEY_FILTER_STATE_NAME : selectedStateNames, KEY_FILTER_STATE_CODE : selectedStateCodes};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kFilterStateDidChangeNameNotification" object:nil userInfo:notificationDict];
    
} */

- (void)dealloc{
    
    self.selectedStateNameList = nil;
    self.selectedStateCodeList = nil;
    
    STLog(@"Dealloc");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
