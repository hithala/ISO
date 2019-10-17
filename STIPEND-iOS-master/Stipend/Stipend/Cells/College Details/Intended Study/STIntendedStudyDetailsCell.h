//
//  STIntendedStudyDetailsCell.h
//  StipendTesting
//
//  Created by Ganesh Kumar on 08/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STIntendedStudyDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel                 *StudentFacultyRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel                 *StudentFacultyRatioValue;

- (void) updateStudentFacultyRatioWithDetails:(NSString *) details;

@end
