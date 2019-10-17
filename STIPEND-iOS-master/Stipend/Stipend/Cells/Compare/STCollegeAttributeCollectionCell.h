//
//  STCollegeAttributeCollectionCell.h
//  Stipend
//
//  Created by Arun S on 15/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCollegeAttributeCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel                                *labelName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSeperatorWidthConstraint;

@end
