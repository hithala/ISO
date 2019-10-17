//
//  STAdmissionCodeViewCell.h
//  CollectionViewTableViewCell
//
//  Created by mahesh on 01/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCAdmissionCodes.h"

@interface STAdmissionCodeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView                       *ibSeparatorLineView;

@property (nonatomic, retain) NSOrderedSet                      *admissionCodesDetails;

- (void)updateCellWithDetails:(NSOrderedSet *)details;


@end
