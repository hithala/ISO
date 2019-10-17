//
//  STCollegeDataCollectionCell.h
//  Stipend
//
//  Created by Arun S on 15/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCollegeDataCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel                                *valueName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSeperatorWidthConstraint;

@end
