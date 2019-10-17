//
//  STCompareSectionsViewController.m
//  Stipend
//
//  Created by Arun S on 08/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCompareSectionsViewController.h"
#import "STReorderCell.h"

#define ROW_HEIGHT      60.0

@interface STCompareSectionsViewController ()

@end

@implementation STCompareSectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Sections";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    NSMutableDictionary *sectionDetails = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CompareSections" ofType:@"plist"]];
    self.sectionArray = [[NSMutableArray alloc] initWithArray:[sectionDetails objectForKey:@"CompareSections"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonAction:)];
}

- (void) cancelButtonAction:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.sectionArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STReorderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reorderCell" forIndexPath:indexPath];
    
    NSDictionary *sectionDict = [self.sectionArray objectAtIndex:indexPath.row];
    cell.cellIcon.image = [UIImage imageNamed:[sectionDict objectForKey:@"imageName"]];
    cell.cellName.text = [sectionDict objectForKey:@"sectionName"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedItemIndex = indexPath.row;
    
    if(self.doneActionBlock) {
        self.doneActionBlock(self.selectedItemIndex);
    }

    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    self.sectionArray = nil;
    self.doneActionBlock = nil;
    
}

@end
