//
//  STFilterAdmissionTypeCell.h
//  Stipend
//
//  Created by Ganesh kumar on 03/01/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFilterAdmissionTypeCell : UITableViewCell

@property (nonatomic,retain) NSIndexPath           *cellIndexPath;
@property (weak, nonatomic) IBOutlet UILabel          *titleLabel;

@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) NSInteger buttonTag;

@property (nonatomic, strong) void (^didUpdateCellActionBlock)(id);

@end
