//
//  STCollegeDetailViewController+ShareAdditions.h
//  Stipend
//
//  Created by Arun S on 24/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCollegeDetailViewController.h"
#import "STShareImageView.h"

@interface STCollegeDetailViewController (ShareAdditions)

- (UIImage *)createShareScreenShotImageFromView:(STShareImageView *)shareImageView;

- (void)createShareScreenShotImageFromTableView:(STShareImageView *)shareImageView;
@end
