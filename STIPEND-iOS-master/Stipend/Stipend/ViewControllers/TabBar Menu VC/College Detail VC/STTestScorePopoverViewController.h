//
//  STTestScorePopoverViewController.h
//  Stipend
//
//  Created by Suman Roy on 30/03/17.
//  Copyright © 2017 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STTestScorePopoverViewController : UIViewController <UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentSATScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentSATScoreIdentifier;

@end
