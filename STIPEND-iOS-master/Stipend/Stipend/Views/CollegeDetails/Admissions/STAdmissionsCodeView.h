//
//  STAdmissionsCodeView.h
//  Stipend
//
//  Created by Ganesh Kumar on 25/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCAdmissionCodes.h"

@interface STAdmissionsCodeView : UIView

@property (weak, nonatomic) IBOutlet UILabel    *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;


- (void)updateViewWithdetails:(STCAdmissionCodes *)details;

@end
