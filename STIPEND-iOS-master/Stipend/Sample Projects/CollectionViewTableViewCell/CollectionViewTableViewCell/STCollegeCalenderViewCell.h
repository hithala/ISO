//
//  STCollegeCalenderViewCell.h
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

typedef enum {
   
    kCalenderViewTypeImportantDates = 0,
    kCalenderViewTypeOtherDates     = 1,
    kCalenderViewTypeFooter         = 2
}CalenderViewType;
#import <UIKit/UIKit.h>

@interface STCollegeCalenderViewCell : UITableViewCell

@property (nonatomic, assign) CalenderViewType calenderViewType;

- (void)loadViews:(CalenderViewType)viewType withDataSource:(NSMutableDictionary *)dataSourceDictionary;

@end
