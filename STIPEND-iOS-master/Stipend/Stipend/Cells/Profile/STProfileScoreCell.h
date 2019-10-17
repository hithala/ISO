//
//  STProfileScoreCell.h
//  Stipend
//
//  Created by Arun S on 11/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STProfileScoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField                 *gpaTextField;
@property (weak, nonatomic) IBOutlet UITextField                 *satTextField;
@property (weak, nonatomic) IBOutlet UITextField                 *actTextField;
@property (weak, nonatomic) IBOutlet UIView                  *gpaSeperatorView;
@property (weak, nonatomic) IBOutlet UIView                   *satSperatorView;
@property (weak, nonatomic) IBOutlet UIView                  *actSeperatorView;
@property (weak, nonatomic) IBOutlet UILabel                         *gpaLabel;
@property (weak, nonatomic) IBOutlet UILabel                         *satLabel;
@property (weak, nonatomic) IBOutlet UILabel                         *actLabel;

@property (nonatomic,retain) NSIndexPath                        *cellIndexPath;

@property (nonatomic, strong) void (^didUpdateCellActionBlock)(id);

@end
