//
//  STExportEmailView.h
//  Stipend
//
//  Created by Soucebits on 29/09/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STExportEmailView : UIView

+ (STExportEmailView *)loadFromNib;

+ (STExportEmailView *)shareView;
- (void)showInView:(UIView *)view;

@property (nonatomic, copy) void (^cancelActionBlock)(void);
@property (nonatomic, copy) void (^sendActionBlock)(NSString * emailString);

@end
