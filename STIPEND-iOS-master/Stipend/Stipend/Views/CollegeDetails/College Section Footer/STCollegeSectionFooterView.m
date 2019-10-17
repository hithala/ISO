//
//  STCollegeSectionFooterView.m
//  Stipend
//
//  Created by Arun S on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCollegeSectionFooterView.h"

@implementation STCollegeSectionFooterView

- (void) awakeFromNib {
    [super awakeFromNib];    
    self.topViewSeparatorHeightConstraint.constant = 0.5f;
    self.bottomViewSeparatorHeightConstraint.constant = 0.5f;
}

- (void)dealloc {
    
}

@end
