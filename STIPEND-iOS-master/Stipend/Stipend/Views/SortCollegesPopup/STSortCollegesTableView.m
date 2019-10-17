//
//  STSortCollegesTableView.m
//  Stipend
//
//  Created by sourcebits on 06/01/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import "STSortCollegesTableView.h"
#import "STSettingsOptionsCell.h"
#import "STFilter.h"

@interface STSortCollegesTableView ()

@end

@implementation STSortCollegesTableView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)configureView {
    
    self.popUpTableView.scrollEnabled = NO;
    
    self.sortTypesDataSource = [[NSMutableArray alloc] init];
    self.sortTypesDataSource = [self sortTypesDataSource];
    
    self.topSeparatorHeightConstraint.constant = 0.5f;
    self.bottomSeparatorHeightConstraint.constant = 0.5f;
    
    [self.popUpTableView registerNib:[UINib nibWithNibName:@"STSettingsOptionsCell" bundle:nil] forCellReuseIdentifier:@"STSettingsOptionsCell"];
    
}


- (NSMutableArray *) sortTypesDataSource {
    
    NSMutableArray *dataSourceDict = [NSMutableArray array];
    
    NSInteger sortType = [[[[STUserManager sharedManager] getCurrentUserInDefaultContext] sortOrder] integerValue];
    NSString *sortString = sortTypeString(sortType);
    
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Alphabetically",KEY_LABEL,sortString,KEY_VALUE, nil]];
    
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"No. of Freshmen",KEY_LABEL,sortString,KEY_VALUE, nil]];
    
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Average GPA",KEY_LABEL,sortString,KEY_VALUE, nil]];
    
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Average SAT score",KEY_LABEL,sortString,KEY_VALUE, nil]];
    
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Average ACT Composite",KEY_LABEL,sortString,KEY_VALUE, nil]];
    
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Acceptance Rate",KEY_LABEL,sortString,KEY_VALUE, nil]];

    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"6-Year Graduation Rate",KEY_LABEL,sortString,KEY_VALUE, nil]];
    
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Distance",KEY_LABEL,sortString,KEY_VALUE, nil]];
    
    
    return dataSourceDict;
}

- (IBAction)closePopup:(id)sender {
    
    if(self.cancelActionBlock) {
        self.cancelActionBlock();
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.sortTypesDataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STSettingsOptionsCell *contentCell = (STSettingsOptionsCell *)[tableView dequeueReusableCellWithIdentifier:@"STSettingsOptionsCell"];
    contentCell.titleLabelLeadingConstraint.constant = 15.0f;
    
    NSMutableDictionary *sortDetailsDict = [self.sortTypesDataSource objectAtIndex:indexPath.row];
    
    NSString *titleValue = [sortDetailsDict objectForKey:KEY_LABEL];
    
    contentCell.titleLabel.text = titleValue;
    
    NSInteger sortType = [[[[STUserManager sharedManager] getCurrentUserInDefaultContext] sortOrder] integerValue];
    
//    BOOL isFilterApplied = [[STUserManager sharedManager] isFilterApplied];
//
//    if(isFilterApplied) {
//        
//        STFilter *filter = [STFilter MR_findFirst];
//        if (filter != nil) {
//            sortType = [filter.sortOrder integerValue];
//        }
//    }
    
    if([sortTypeString(sortType) isEqualToString:titleValue]) {
        contentCell.checkMarkImageView.hidden = NO;
    } else {
        contentCell.checkMarkImageView.hidden = YES;
    }

    contentCell.accessoryType = UITableViewCellAccessoryNone;
    
    return contentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SortType sortType = eSortTypeAlphabetically;
    
    if(indexPath.row == 0) {
        sortType = eSortTypeAlphabetically;
    }
    else if (indexPath.row == 1) {
        sortType = eSortTypeNoOfFreshmen;
    }
    else if (indexPath.row == 2) {
        sortType = eSortTypeAverageGPA;
    }
    else if (indexPath.row == 3) {
        sortType = eSortTypeAverageSAT;
    }
    else if (indexPath.row == 4) {
        sortType = eSortTypeAverageACT;
    }
    else if (indexPath.row == 5) {
        sortType = eSortTypeAcceptanceRate;
    }
    else if (indexPath.row == 6) {
        sortType = eSortTypeSixYrGraduationRate;
    }
    else if (indexPath.row == 7) {
        sortType = eSortTypeDistance;
    }
    
    
    if(self.completeActionBlock) {
        
        self.completeActionBlock(sortType);
    }
    
    self.cancelActionBlock();

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
