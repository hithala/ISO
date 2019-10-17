//
//  STProgressHUD.m
//  Stipend
//
//  Created by Ganesh Kumar on 13/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STProgressHUD.h"
#import "SVProgressHUD.h"

@implementation STProgressHUD

+ (void)showWithStatus:(NSString *)statusText {
    
    [SVProgressHUD setForegroundColor:[UIColor aquaColor]];
    [SVProgressHUD showWithStatus:statusText maskType:SVProgressHUDMaskTypeBlack];
    
}

+ (void)show {
    [SVProgressHUD setForegroundColor:[UIColor aquaColor]];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
}

+ (void)dismissWithStatus:(NSString *)status isSucces:(BOOL)success {
    
    [SVProgressHUD setForegroundColor:[UIColor aquaColor]];

    if (success) {
        [SVProgressHUD showSuccessWithStatus:status maskType:SVProgressHUDMaskTypeBlack];
    } else {
        [SVProgressHUD showErrorWithStatus:status maskType:SVProgressHUDMaskTypeBlack];
    }
    
}

+ (void)dismiss{
    [SVProgressHUD dismiss];
}

+ (void)showInfoWithStatus:(NSString *)statusText {
    
    [SVProgressHUD showInfoWithStatus:statusText maskType:SVProgressHUDMaskTypeBlack];

}


+ (void)showImage:(UIImage *)image andStatus:(NSString *)statusText {
    
    [SVProgressHUD setFont:[UIFont fontType:eFontTypeAvenirMedium FontForSize:14]];
    [SVProgressHUD showImage:image status:statusText maskType:SVProgressHUDMaskTypeBlack];
    
}


@end
