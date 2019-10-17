//
//  STCollegeCalenderViewCell.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#define CALENDER_VIEW_FOOTER_HEIGHT 139.0

#import "STCollegeCalenderViewCell.h"
#import "STImportantDateView.h"
#import "STOtherDateView.h"
#import "STCalenderFooterView.h"

@interface STCollegeCalenderViewCell ()

@property (nonatomic, assign) CGRect importantDateViewFrame;
@property (nonatomic, assign) CGRect otherDatesViewFrame;
@property (nonatomic, strong) STCalenderFooterView *footerDateView;

@end
@implementation STCollegeCalenderViewCell

@synthesize importantDateViewFrame,otherDatesViewFrame,footerDateView;

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (footerDateView != nil) {
        footerDateView.frame = CGRectMake(0,otherDatesViewFrame.size.height + otherDatesViewFrame.origin.y ,[UIScreen mainScreen].applicationFrame.size.width , 139.0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadViews:(CalenderViewType)viewType withDataSource:(NSMutableDictionary *)dataSourceDictionary{
    
    switch (viewType) {
        case kCalenderViewTypeImportantDates:{
            STImportantDateView *dateView = [[STImportantDateView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 182.0)];
            dateView.importantDatesViewDict = dataSourceDictionary;
            [dateView loadViews];
            importantDateViewFrame = dateView.frame;
            [self.contentView addSubview:dateView];
        }
        break;
        case kCalenderViewTypeOtherDates:{
            STOtherDateView *otherDateView = [[STOtherDateView alloc] initWithFrame:CGRectMake(0, importantDateViewFrame.size.height + 20.0, self.frame.size.width, 4 * 65.0)];

            [otherDateView loadViews];
            otherDatesViewFrame = otherDateView.frame;
            [self.contentView addSubview:otherDateView];
        }
        break;
        case kCalenderViewTypeFooter:{
            footerDateView = [[NSBundle mainBundle] loadNibNamed:@"STCalenderFooterView" owner:self options:nil][0];//[STCalenderFooterView loadFromNib];
            CGRect viewFrame = CGRectMake(0,otherDatesViewFrame.size.height + otherDatesViewFrame.origin.y ,[UIScreen mainScreen].applicationFrame.size.width , 139.0);
            footerDateView.frame = viewFrame;
            [self.contentView addSubview:footerDateView];
        }
            break;

        default:
            break;
    }
}

@end
