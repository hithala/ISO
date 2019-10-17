//
//  STFilterCheckboxCell.h
//  Stipend
//
//  Created by Arun S on 18/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFilterCheckboxCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton     *checkBoxButton;
@property (weak, nonatomic) IBOutlet UILabel          *titleLabel;
@property (nonatomic,retain) NSIndexPath           *cellIndexPath;

@property (nonatomic, assign) BOOL                     isSelected;

@property (nonatomic, strong) void (^didUpdateCellActionBlock)(id);

- (IBAction)onCheckBoxButtonAction:(id)sender;

@end
