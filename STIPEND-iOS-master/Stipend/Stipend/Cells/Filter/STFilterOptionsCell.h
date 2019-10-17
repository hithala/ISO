//
//  STFilterOptionsCell.h
//  Stipend
//
//  Created by Arun S on 19/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSwitch.h"

@interface STFilterOptionsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel        *labelField;
@property (weak, nonatomic) IBOutlet UIView      *seperatorView;
@property (weak, nonatomic) IBOutlet UIView         *switchView;
@property (weak, nonatomic) IBOutlet UILabel  *statusLabelField;
@property (nonatomic,retain) NSIndexPath         *cellIndexPath;

@property (nonatomic, strong) TTSwitch *mySwitch;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelCenterXPosition;

- (void)updateSwitchWithStatus:(BOOL)status;

@property (nonatomic, strong) void (^didUpdateCellActionBlock)(id);

@end
