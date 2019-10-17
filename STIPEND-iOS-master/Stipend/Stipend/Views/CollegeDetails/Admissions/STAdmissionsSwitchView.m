//
//  STAdmissionsSwitchView.m
//  Stipend
//
//  Created by Ganesh Kumar on 19/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAdmissionsSwitchView.h"

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_ICON_TYPE                   @"kIconTypeKey"

#define BADGE_0                         @"badge_negative"
#define BADGE_1                         @"badge_positive"
#define BADGE_2                         @"badge_neutral"

#define ROW_HEIGHT                      50.0

@implementation STAdmissionsSwitchView


- (void)updateViewWithdetails:(STCItem *)item withFontType:(NSInteger)fontType {
    
    self.cellSeparatorLeadingSpaceConstraint.constant = 15.0f;
    self.ibSeparatorLineView.hidden = NO;
    self.cellSeparatorHeightConstraint.constant = 0.5f;
    
    self.backgroundColor = [UIColor clearColor];
    
    if(fontType == 1) {
        self.ibLabelValue.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:16.0f];
    }
    else {
        self.ibLabelValue.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:15.0f];
    }
    
    self.ibLabelValue.text = item.itemName;
    self.badgeLabel.text = item.badgeText;
    
    CGRect badgeLabelRect = [self.badgeLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.badgeLabel.frame.size.height)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName: self.badgeLabel.font}
                                                               context:nil];
    int badgeLabelWidth = ceilf(badgeLabelRect.size.width);
    
    self.badgeViewWidthConstraint.constant = 50+badgeLabelWidth;
    
    
    NSInteger bageIconType = [item.badgeType integerValue];
    
    switch (bageIconType) {
        case 2:
            self.badgeImageView.image = [UIImage imageNamed:BADGE_0];
            break;
        case 1:
            self.badgeImageView.image = [UIImage imageNamed:BADGE_1];
            break;
        case 3:
            self.badgeImageView.image = [UIImage imageNamed:BADGE_2];
            break;
        case 4:
            self.badgeImageView.image = [UIImage imageNamed:BADGE_2];
            break;
            
        default:
            break;
    }
    
    if([item.itemName isEqualToString:@"Double Majors Allowed?"] || [item.itemName isEqualToString:@"Study Abroad?"]) {
        self.cellSeparatorLeadingSpaceConstraint.constant = 0.0f;
    }
    
    NSString *keyName = item.itemName;
    
    if(([keyName isEqualToString:@"Double Majors Allowed?"]) || ([keyName isEqualToString:@"Study Abroad?"]) || ([keyName isEqualToString:@"Intramurals?"]) || ([keyName isEqualToString:@"Recommendations"]) || ([keyName isEqualToString:@"Interviews"])) {
        self.ibLabelValue.textColor = [UIColor cellLabelTextColor];
        self.ibLabelValue.font = [UIFont fontType:eFontTypeAvenirBook FontForSize:16.0];
    }
    else {
        self.ibLabelValue.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0];
        self.ibLabelValue.textColor = [UIColor cellTextFieldTextColor];
    }
}

- (void)dealloc {
    
}

@end
