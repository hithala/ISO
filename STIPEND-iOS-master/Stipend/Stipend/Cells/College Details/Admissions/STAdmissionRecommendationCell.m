//
//  STAdmissionRecommendationCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAdmissionRecommendationCell.h"
#import "STAdmissionsSwitchView.h"

#define ROW_HEIGHT                      44.0
#define TITLE_TAG                       356
#define BASE_TAG                        100

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

@implementation STAdmissionRecommendationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateCellWithDetails:(STCAdmissionItem *)item {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.admissionItem = item;
    [self updateAdmissionDetails];
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateAdmissionDetails];
}

- (void)updateAdmissionDetails {
        
    UILabel *titleLabel = (UILabel *)[self.contentView viewWithTag:TITLE_TAG];
    
    if(!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 8.0, self.frame.size.width - 30.0, 30.0)];
        titleLabel.font = [UIFont fontType:eFontTypeAvenirBook FontForSize:16.0f];
        titleLabel.textColor = [UIColor cellLabelTextColor];
        [titleLabel setTag:TITLE_TAG];
        titleLabel.text = self.admissionItem.title;
        [self.contentView addSubview:titleLabel];
    }
    
    titleLabel.text = self.admissionItem.title;
    titleLabel.frame = CGRectMake(15.0, 8.0, self.frame.size.width - 30.0, 30.0);
    
    for(int i = 0; i < self.admissionItem.items.count; i++) {
        
        STAdmissionsSwitchView *admissionsSwitchView = (STAdmissionsSwitchView *)[self viewWithTag:BASE_TAG+i];
        
        if(!admissionsSwitchView) {
            
            admissionsSwitchView = [[NSBundle mainBundle] loadNibNamed:@"STAdmissionsSwitchView" owner:self options:nil][0];
            
            admissionsSwitchView.tag = BASE_TAG+i;
            admissionsSwitchView.backgroundColor = [UIColor clearColor];
            
            admissionsSwitchView.ibLabelLeadingSpaceConstraint.constant = 30.0f;
            [self.contentView addSubview:admissionsSwitchView];
        }
        
        CGRect cellFrame = CGRectMake(0, ((i * ROW_HEIGHT) + 30.0), self.frame.size.width, ROW_HEIGHT);
        admissionsSwitchView.frame = cellFrame;

        STCItem *subItem = [self.admissionItem.items objectAtIndex:i];
        [admissionsSwitchView updateViewWithdetails:subItem withFontType:2];
    
        if(i != (self.admissionItem.items.count - 1)) {
            admissionsSwitchView.ibSeparatorLineView.hidden = YES;
        }
        
        if([self.admissionItem.title isEqualToString:@"Interviews"]) {
            admissionsSwitchView.ibSeparatorLineView.hidden = YES;
        }
        else {
            admissionsSwitchView.ibSeparatorLineView.hidden = NO;
            if(self.admissionItem.items.count > 1) {
                if(i == (self.admissionItem.items.count - 1)) {
                    admissionsSwitchView.cellSeparatorLeadingSpaceConstraint.constant = 0.0f;
                }
            }
        }
        
        [admissionsSwitchView setNeedsDisplay];
    }
}

- (void)dealloc {
    self.admissionItem = nil;
}

@end
