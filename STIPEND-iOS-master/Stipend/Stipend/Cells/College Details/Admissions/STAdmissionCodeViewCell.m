//
//  STAdmissionCodeViewCell.m
//  CollectionViewTableViewCell
//
//  Created by mahesh on 01/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAdmissionCodeViewCell.h"
#import "STAdmissionsCodeView.h"

#define ROW_HEIGHT                      70.0

#define BASE_TAG                        100.0
#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_EXPAND                      @"kExpandKey"

#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_VALUES_DICT                 @"kValuesDictKey"
#define KEY_VALID                       @"kValidKey"
#define KEY_ICON                        @"kIconKey"
#define KEY_ICON_TYPE                   @"kIconTypeKey"

@implementation STAdmissionCodeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cellSeparatorHeightConstraint.constant = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateCellWithDetails:(NSOrderedSet *)details {
    
    self.admissionCodesDetails = details;
    [self updateAdmissionCodeDetails];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateAdmissionCodeDetails];
}

- (void)updateAdmissionCodeDetails {
    
    for(int i = 0; i < self.admissionCodesDetails.count; i++) {
        
        CGRect admissionCodeFrame = CGRectZero;

        STAdmissionsCodeView *admissionsCodeView = (STAdmissionsCodeView *)[self viewWithTag:BASE_TAG+i];

        if(!admissionsCodeView) {
            admissionsCodeView = [[NSBundle mainBundle] loadNibNamed:@"STAdmissionsCodeView" owner:self options:nil][0];
            admissionsCodeView.tag = BASE_TAG+i;
            [self.contentView addSubview:admissionsCodeView];
        }
        
        if(i%2 == 0) {
            admissionCodeFrame = CGRectMake(0, ((i * ROW_HEIGHT)), self.bounds.size.width/2, ROW_HEIGHT);
        }
        else {
            admissionCodeFrame = CGRectMake(self.bounds.size.width/2, (((i/2) * ROW_HEIGHT)), self.bounds.size.width/2, ROW_HEIGHT);
        }
        
        admissionsCodeView.frame = admissionCodeFrame;

        STCAdmissionCodes *admissionCode = [self.admissionCodesDetails objectAtIndex:i];
        [admissionsCodeView updateViewWithdetails:admissionCode];
    }
}

- (void)dealloc {
    self.admissionCodesDetails = nil;
}

@end
