//
//  STSpecificMajorCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 18/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSpecificMajorCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *studentCount;
@property (nonatomic, weak) IBOutlet UIView *separatorView;

@end
