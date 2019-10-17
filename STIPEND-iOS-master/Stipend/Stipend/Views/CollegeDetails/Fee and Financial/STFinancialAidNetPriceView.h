//
//  STFinancialAidNetPriceView.h
//  Stipend
//
//  Created by Ganesh kumar on 10/07/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFinancialAidNetPriceView : UIView

@property (weak, nonatomic) IBOutlet UILabel *fieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *fieldValue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorHeightConstraint;

@property (nonatomic, strong) IBOutlet UIImageView* questionmarkView;

@property (nonatomic, copy) void (^imageClickActionBlock)(UIImageView* questionMarkview);

@end
