//
//  STTestScorePopoverViewController.m
//  Stipend
//
//  Created by Suman Roy on 30/03/17.
//  Copyright © 2017 Sourcebits. All rights reserved.
//

#import "STTestScorePopoverViewController.h"

@interface STTestScorePopoverViewController ()

@end

@implementation STTestScorePopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{

    [ super viewWillAppear:animated ];

    CGFloat viewWidth = self.currentSATScoreIdentifier.frame.size.width + self.currentSATScoreLabel.frame.size.width + 30;
    CGFloat viewHeight = self.currentSATScoreIdentifier.frame.size.height + 28;
    
    self.preferredContentSize = CGSizeMake(viewWidth, viewHeight);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{

    return UIModalPresentationNone;
}

@end
