//
//  STTabBarController.m
//  Stipend
//
//  Created by sourcebits on 23/12/15.
//  Copyright © 2015 Sourcebits. All rights reserved.
//

#import "STTabBarController.h"
#import "STIntroductionViewController.h"

@interface STTabBarController ()

@property (nonatomic, assign) int previousIndex;

@end

@implementation STTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.previousIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    STLog(@"tab bar selected item : %@", item.title);

    if([item.title isEqualToString:@"Colleges"]) {
        self.previousIndex = 0;
    } else if([item.title isEqualToString:@"Favorites"]) {
        if(STUserManager.sharedManager.isGuestUser) {
            [self showLoginController];
        }
    } else if([item.title isEqualToString:@"Clippings"]) {
        if(STUserManager.sharedManager.isGuestUser) {
            [self showLoginController];
        }
    } else if([item.title isEqualToString:@"Compare"]) {
        if(STUserManager.sharedManager.isGuestUser) {
            [self showLoginController];
        }
    } else if([item.title isEqualToString:@"More"]) {
        self.previousIndex = 4;
    }
}

- (void)showLoginController {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    STIntroductionViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"IntroductionViewController"];
    viewController.hasSkippedLogin = YES;
    viewController.cancelActionBlock = ^{
        self.selectedIndex = self.previousIndex;
    };

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:LOGIN_SCREEN_PRESENTED];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
