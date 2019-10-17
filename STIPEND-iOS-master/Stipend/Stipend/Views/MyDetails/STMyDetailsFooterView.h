//
//  STMyDetailsFooterView.h
//  Stipend
//
//  Created by Arun S on 23/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMyDetailsFooterView : UIView

@property (nonatomic, strong) void (^privacyActionBlock)(void);

- (IBAction)onPrivacyButtonAction:(id)sender;

@end
