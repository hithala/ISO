//
//  STLoginTextCell.h
//  Stipend
//
//  Created by Arun S on 07/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STLoginTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel                                            *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField                                        *valueField;
@property (weak, nonatomic) IBOutlet UIView                                          *seperatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint                  *seperatorHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView                                  *astreikImageView;

@property (nonatomic,retain) NSIndexPath                                             *cellIndexPath;

@property (nonatomic, strong) void (^didUpdateCellActionBlock)(id);
@property (nonatomic, strong) void (^didStartEditingActionBlock)(id);
@property (nonatomic, strong) void (^didEndEditingActionBlock)(id);
@property (nonatomic, strong) void (^didClickReturnActionBlock)(id);

@end
