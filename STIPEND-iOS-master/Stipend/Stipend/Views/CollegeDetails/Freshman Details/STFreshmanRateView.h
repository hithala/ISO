//
//  STFreshmanRateView.h
//  Stipend
//
//  Created by Ganesh Kumar on 07/02/18.
//  Copyright (c) 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STFreshmanRateView;

@interface STFreshmanRateView : UIView

@property (nonatomic, assign) CGFloat   firstPercentage;
@property (nonatomic, assign) CGFloat secondPercentage;
@property (nonatomic, assign) FreshmenItem freshmenItem;

@property (nonatomic, strong) UIImageView* questionmarkView;

@property (nonatomic, copy) void (^imageClickActionBlock)(UIImageView* questionMarkview);

@end
