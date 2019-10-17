//
//  STSettingsDetailDisclosureHeaderView.h
//  Stipend
//
//  Created by sourcebits on 31/12/15.
//  Copyright © 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSettingsDetailDisclosureHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureIcon;

- (IBAction)clickAction:(UIButton *)sender;

@property (nonatomic, copy) void (^clickActionBlock)(NSInteger tag);


@end
