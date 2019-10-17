//
//  STFilterCollegeTypeCell.h
//  Stipend
//
//  Created by Arun S on 18/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFilterCollegeTypeCell : UITableViewCell

@property (nonatomic,retain) NSIndexPath           *cellIndexPath;
@property (weak, nonatomic) IBOutlet UILabel           *titleLabel;

@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) NSInteger buttonTag;

@property (nonatomic, strong) void (^didUpdateCellActionBlock)(id);

@end
