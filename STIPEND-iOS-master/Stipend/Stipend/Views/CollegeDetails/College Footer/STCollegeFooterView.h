//
//  STCollegeFooterView.h
//  Stipend
//
//  Created by Arun S on 23/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCollegeFooterView : UIView

@property (nonatomic, copy) void (^backToTop)(void);

- (IBAction)onBackToTopAction:(id)sender;

@end
