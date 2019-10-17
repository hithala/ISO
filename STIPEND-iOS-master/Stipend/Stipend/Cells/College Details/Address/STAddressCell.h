//
//  STAddressCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 01/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView                             *cellIcon;
@property (weak, nonatomic) IBOutlet UITextView                       *addressTextview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorHeightConstraint;

@end
