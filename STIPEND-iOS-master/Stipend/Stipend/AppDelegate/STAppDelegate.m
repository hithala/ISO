//
//  STAppDelegate.m
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAppDelegate.h"
#import "STSocialLoginManager.h"
#import "STCompareViewController.h"
#import "STTabBarController.h"
#import "STPrivacyPolicyManager.h"

@import Firebase;

@interface STAppDelegate ()

@end

@implementation STAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Setting up MagicalRecord
//    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Stipend"];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    STLog(@"%@", [paths objectAtIndex:0]);
    
    // Blocking main thread to display slpash screen for 2 seconds.
    [NSThread sleepForTimeInterval:1.5];

    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Stipend"];
    
//    [[STUserManager sharedManager] resetFilterWithCompletion:nil];

    BOOL isFilterKey = [[NSUserDefaults standardUserDefaults] boolForKey:FILTER_STATUS];
    [[STUserManager sharedManager] setIsFilterApplied:isFilterKey];
    
    // In-App Purchase register for transaction observer
    [STInAppPurchaseManager sharedInstance];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
//    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];

    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class], [UINavigationBar class]]] setTintColor:[UIColor whiteColor]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:18.0f],
                                                           } forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                                           NSFontAttributeName: [UIFont fontWithName:@"Avenir-Medium" size:18.0f],
                                                           }];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor aquaColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_bar"]forState:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"search_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"search_clear"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [[UISearchBar appearance] setSearchTextPositionAdjustment:UIOffsetMake(10.0, 0.0)];
    
    // Customising TabBar appearance  
    [[UITabBar appearance] setTintColor:[UIColor aquaColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
//                                                                                                 NSForegroundColorAttributeName: [UIColor colorWithRed:0.0/255.0 green:113.0/255.0 blue:128.0/255.0 alpha:1.0],
//                                                                                                 NSFontAttributeName: [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0],
//                                                                                                 }];
//
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{
                                                                                                                 NSForegroundColorAttributeName: [UIColor colorWithRed:0.0/255.0 green:113.0/255.0 blue:128.0/255.0 alpha:1.0],
                                                                                                                 NSFontAttributeName: [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0],
                                                                                                                 }];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    NSNumber *userID =  [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    
    if(userID) {
        
//        UIStoryboard *drawerMenuStoryboard = [UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil];
//        STDrawerBaseViewController *drawerBaseViewController = [drawerMenuStoryboard instantiateViewControllerWithIdentifier:@"DrawerBaseViewController"];
//        
//        self.window.rootViewController = drawerBaseViewController;
        
        UIStoryboard *tabBarMenuStoryboard = [UIStoryboard storyboardWithName:@"TabBarMenu" bundle:nil];
        STTabBarController *tabBarController = [tabBarMenuStoryboard instantiateViewControllerWithIdentifier:@"TabBarControllerID"];
        
        self.window.rootViewController = tabBarController;
        
    } else {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *introductionNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"IntroductionNavigationController"];
        
        self.window.rootViewController = introductionNavigationController;
    }
    
    // Checking for new privacy message if any
//    [[STPrivacyPolicyManager sharedManager] checkIfPrivacyMessageIsUpdated];
    
    //Notify User settings changed.
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountStoreChanged:) name:ACAccountStoreDidChangeNotification object:nil];
    
    [self.window makeKeyAndVisible];
    
    // Firebase Initialization
    [FIRApp configure];

    [Fabric with:@[CrashlyticsKit]];
    [[Twitter sharedInstance] startWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(nonnull UIApplicationExtensionPointIdentifier)extensionPointIdentifier {
    
    if (extensionPointIdentifier == UIApplicationKeyboardExtensionPointIdentifier) {
        return NO;
    }
    return YES;
}

- (MKMapView *) mapView {
    
    static MKMapView *_mapview = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mapview = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    
    return _mapview;
}

- (void)accountStoreChanged:(NSNotification *)notification{
    STLog(@"Account Changed");
    [[STSocialLoginManager sharedManager] attemptRenewCredentials];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {

    if([url.scheme localizedCaseInsensitiveContainsString:TWITTER_SCHEME]) {
        
         return [[Twitter sharedInstance] application:application openURL:url options:options];
        
    } else if([url.scheme localizedCaseInsensitiveContainsString:FACEBOOK_SCHEME]) {
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:nil];
        
    }
    
    return NO;
}

@end
