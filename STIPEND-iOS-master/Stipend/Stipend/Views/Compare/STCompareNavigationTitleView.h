//
//  STCompareNavigationTitleView.h
//  Stipend
//
//  Created by Arun S on 08/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCompareNavigationTitleView : UIView

@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet UIButton  *titleButton;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *buttonTopConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *buttonTrailingConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *buttonWidthConstraint;

@property (nonatomic, copy) void (^onTitleActionBlock)(void);


- (void) updateNavigationTitleWithCollegeName:(NSString *) title andImageName:(NSString *) imageName;

- (IBAction)onTitleBarButtonAction:(id)sender;

@end
