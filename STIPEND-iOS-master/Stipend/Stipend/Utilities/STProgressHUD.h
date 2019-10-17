//
//  STProgressHUD.h
//  Stipend
//
//  Created by Ganesh Kumar on 13/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STProgressHUD : NSObject

+ (void)showWithStatus:(NSString *)statusText;
+ (void)show;

+ (void)dismissWithStatus:(NSString *)status isSucces:(BOOL)success;
+ (void)dismiss;

+ (void)showInfoWithStatus:(NSString *)statusText;

+ (void)showImage:(UIImage *)image andStatus:(NSString *)statusText;
@end
