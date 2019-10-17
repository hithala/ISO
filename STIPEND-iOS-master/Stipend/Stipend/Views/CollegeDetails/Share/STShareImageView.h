//
//  STShareImageView.h
//  Stipend
//
//  Created by sourcebits on 18/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STShareImageView : UIView
@property (weak, nonatomic) IBOutlet UIView *ibTopNavigationView;
@property (weak, nonatomic) IBOutlet UIImageView *ibSnapShotImgView;
@property (weak, nonatomic) IBOutlet UILabel *ibTextLabel;
@property (weak, nonatomic) IBOutlet UIView *ibSpacierView;
@property (weak, nonatomic) IBOutlet UILabel *ibDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibHeaderLabel;

@end
