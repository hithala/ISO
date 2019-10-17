//
//  STAdmissionsCodeView.m
//  Stipend
//
//  Created by Ganesh Kumar on 25/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAdmissionsCodeView.h"

#define ROW_HEIGHT                      70.0

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_ICON_TYPE                   @"kIconTypeKey"

@implementation STAdmissionsCodeView

- (void)updateViewWithdetails:(STCAdmissionCodes *)details {
    
    self.titleLabel.text = [NSString stringWithFormat:@"%04ld",(long)[details.value integerValue]];
    self.subtitleLabel.text = details.key;
}

- (void)dealloc {
    
}

@end
