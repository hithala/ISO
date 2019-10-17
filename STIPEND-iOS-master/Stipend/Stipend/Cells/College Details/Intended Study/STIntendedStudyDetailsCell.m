//
//  STIntendedStudyDetailsCell.m
//  StipendTesting
//
//  Created by Ganesh Kumar on 08/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STIntendedStudyDetailsCell.h"

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"

@implementation STIntendedStudyDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
     self.cellSeparatorHeightConstraint.constant = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) updateStudentFacultyRatioWithDetails:(NSString *) studentFacultyRatio {
    self.StudentFacultyRatioLabel.text = @"Student:Faculty Ratio";
    
    if(studentFacultyRatio) {
        self.StudentFacultyRatioValue.text = [NSString stringWithFormat:@"%ld:1",(long)[studentFacultyRatio integerValue]];
    } else {
        self.StudentFacultyRatioValue.text = @"N/A";
    }
}

- (void)dealloc {
}

@end
