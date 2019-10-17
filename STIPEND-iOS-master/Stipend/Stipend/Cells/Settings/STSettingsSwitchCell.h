//
//  STSettingsSwitchCell.h
//  Stipend
//
//  Created by Arun S on 20/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSettingsSwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel             *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch            *switchView;

- (IBAction)onToggleSwitchAction:(id)sender;

@end
