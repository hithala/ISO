//
//  STFilterMajorCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 22/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFilterMajorCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIImageView *selectionImageView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *countLabelWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectionImageviewWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectionImageviewTrailingConstraint;

@end
