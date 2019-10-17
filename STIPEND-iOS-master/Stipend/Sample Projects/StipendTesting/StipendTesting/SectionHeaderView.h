//
//  SectionHeaderView.h
//  StipendTesting
//
//  Created by Ganesh Kumar on 28/05/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIImageView *ibSectionHeaderIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibSectionHeaderName;
@property (weak, nonatomic) IBOutlet UIImageView *ibSectionHeaderArrow;
@property (weak, nonatomic) IBOutlet UIButton *ibTapButton;

- (IBAction)clickAction:(UIButton *)sender;

@property (nonatomic, copy) void (^clickActionBlock)(NSInteger tag);
@end
