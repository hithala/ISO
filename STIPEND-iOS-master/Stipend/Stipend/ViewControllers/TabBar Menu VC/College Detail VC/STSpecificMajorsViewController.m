//
//  STSpecificMajorsViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 18/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import "STSpecificMajorsViewController.h"
#import "STSpecificMajorsHeaderView.h"
#import "STSpecificMajorCell.h"

#define TABLEVIEW_HEADER_HEIGHT      44.0
#define ROW_HEIGHT                   44.0

@interface STSpecificMajorsViewController ()

@end

@implementation STSpecificMajorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Specific Majors";
    [self.tableView registerNib:[UINib nibWithNibName:@"STSpecificMajorCell" bundle:nil] forCellReuseIdentifier:@"STSpecificMajorCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"STSpecificMajorsHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"STSpecificMajorsHeaderView"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = ROW_HEIGHT;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.specificMajors.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STSpecificMajorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STSpecificMajorCell" forIndexPath:indexPath];
    
    STSpecificMajor *specificMajor = [self.specificMajors objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = specificMajor.name;
    cell.studentCount.text = [NSString stringWithFormat:@"%@", specificMajor.studentCount];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    STSpecificMajorsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"STSpecificMajorsHeaderView"];
    UIView *backgroundView = [[UIView alloc] initWithFrame:headerView.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    headerView.backgroundView = backgroundView;
    return headerView;
}

@end
