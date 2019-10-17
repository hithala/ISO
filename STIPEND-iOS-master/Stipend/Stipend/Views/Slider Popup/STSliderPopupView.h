//
//  STSliderPopupView.h
//  Stipend
//
//  Created by Ganesh kumar on 05/09/17.
//  Copyright © 2017 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSliderPopupView : UIView

@property (weak, nonatomic) IBOutlet UILabel *popUpValue;

- (void)updateViewFor: (float)value;

@end
