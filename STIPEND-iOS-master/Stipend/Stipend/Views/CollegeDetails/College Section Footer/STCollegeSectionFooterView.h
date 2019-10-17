//
//  STCollegeSectionFooterView.h
//  Stipend
//
//  Created by Arun S on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCollegeSectionFooterView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *topViewSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView                                 *topViewSeparator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView                             *bottomViewSeparator;
@end
