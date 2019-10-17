//
//  STCollegeDetailViewController+ShareAdditions.m
//  Stipend
//
//  Created by Arun S on 24/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCollegeDetailViewController+ShareAdditions.h"

#define ACTION_TYPE_VIEW_HEIGHT           70.0
#define TABLE_VIEW_HEADER_OFFSET_Y        64.0

@implementation STCollegeDetailViewController (ShareAdditions)

- (UIImage *)createShareScreenShotImageFromView:(STShareImageView *)shareImageView {
    
    UIImage *screenShotImage = [self screenshotOfHeaderView:self.mainTableView];
    shareImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.mainTableView.bounds), screenShotImage.size.height + ACTION_TYPE_VIEW_HEIGHT + (ACTION_TYPE_VIEW_HEIGHT/2.0));
    shareImageView.ibSnapShotImgView.image = screenShotImage;
    
    CGRect viewRect = shareImageView.bounds;
    
    UIGraphicsBeginImageContext(viewRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [shareImageView.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"image.png"];
    
    if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
        STLog(@"Success");
    }else{
        STLog(@"Failure");
    }
    return image;
}

- (void)createShareScreenShotImageFromTableView:(STShareImageView *)shareImageView{
    UIImage *screenShotImage = [self screenshotOfHeaderView:self.mainTableView];
    shareImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.mainTableView.bounds), screenShotImage.size.height + ACTION_TYPE_VIEW_HEIGHT);
    shareImageView.ibSnapShotImgView.image = screenShotImage;
    [shareImageView layoutIfNeeded];
    
    CGRect viewRect = shareImageView.bounds;
    
    UIGraphicsBeginImageContext(viewRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [shareImageView.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"image.png"];
    
    if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
        STLog(@"Success");
    }else{
        STLog(@"Failure");
    }
}

- (UIImage *)screenshotOfHeaderView:(UITableView *)tableView {
    
    CGPoint originalOffset = [tableView contentOffset];
    CGRect headerRect = [tableView tableHeaderView].frame;
    headerRect.size.height -= ACTION_TYPE_VIEW_HEIGHT;
    
    [tableView scrollRectToVisible:headerRect animated:NO];
    UIImage *headerScreenshot = [self screenshotForCroppingRect:headerRect];
    [tableView setContentOffset:originalOffset animated:NO];
    
    return headerScreenshot;
}

- (UIImage *)screenshotForCroppingRect:(CGRect)croppingRect {
    
    UIGraphicsBeginImageContextWithOptions(croppingRect.size, NO, [UIScreen mainScreen].scale);
    // Create a graphics context and translate it the view we want to crop so
    // that even in grabbing (0,0), that origin point now represents the actual
    // cropping origin desired:
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context == NULL) return nil;
    CGContextTranslateCTM(context, -croppingRect.origin.x, -croppingRect.origin.y);
    
    [self.view layoutIfNeeded];
    [self.view.layer renderInContext:context];
    
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshotImage;
}

@end
