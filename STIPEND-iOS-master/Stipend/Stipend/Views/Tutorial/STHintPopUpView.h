//
//  STHintPopUpView.h
//  Stipend
//
//  Created by Ganesh kumar on 11/07/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STHintPopUpView : UIView

@property (nonatomic, assign) int imageviewXPosition;
@property (nonatomic, assign) int position;

@property (nonatomic, weak) IBOutlet UIView* backgroundView;
@property (nonatomic, weak) IBOutlet UILabel* textLabel;

@end
