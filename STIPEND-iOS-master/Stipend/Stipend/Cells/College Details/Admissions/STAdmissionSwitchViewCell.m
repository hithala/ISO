//
//  STAdmissionSwitchViewCell.m
//  CollectionViewTableViewCell
//
//  Created by mahesh on 02/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAdmissionSwitchViewCell.h"
#import "STAdmissionsSwitchView.h"

#define ROW_HEIGHT                      50.0
#define BASE_TAG                        100.0
#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_EXPAND                      @"kExpandKey"

#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_VALUES_DICT                 @"kValuesDictKey"
#define KEY_VALID                       @"kValidKey"
#define KEY_ICON                        @"kIconKey"
#define KEY_ICON_TYPE                   @"kIconTypeKey"

#define BADGE_0                         @"badge_negative"
#define BADGE_1                         @"badge_positive"
#define BADGE_2                         @"badge_neutral"


@implementation STAdmissionSwitchViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.admissionsSwitchView = [[NSBundle mainBundle] loadNibNamed:@"STAdmissionsSwitchView" owner:self options:nil][0];
    CGRect cellFrame = CGRectMake(0, (0.0), self.bounds.size.width, ROW_HEIGHT);
    self.admissionsSwitchView.frame = cellFrame;
    
    [self.contentView addSubview:self.admissionsSwitchView];
}

- (void)updateCellWithDetails:(STCItem *)item {
    [self.admissionsSwitchView updateViewWithdetails:item withFontType:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    self.admissionsSwitchView = nil;
}

@end
