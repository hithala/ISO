//
//  STDrawerMenuCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 13/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STDrawerMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ibMenuIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibMenuName;
@property (weak, nonatomic) IBOutlet UIView *ibMenuSelected;

@end
