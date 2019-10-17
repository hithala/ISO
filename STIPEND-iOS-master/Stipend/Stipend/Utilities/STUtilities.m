//
//  STUtilities.m
//  
//
//  Created by Ganesh Kumar on 13/04/16.
//
//

#import "STUtilities.h"
#import "STPrivacyPolicyPopupView.h"
#import "STPrivacyPolicyManager.h"
#import "STWebViewController.h"

@implementation STUtilities

+ (void)showPrivacyPolicyViewWithMessageDetails:(NSDictionary *)messageDetails andMessageID:(NSString *)messageID andShowInView:(UIView *)parentView {
    
    STPrivacyPolicyPopupView *popUpview = [STPrivacyPolicyPopupView shareView];
    
//    [popUpview showInView:[[[UIApplication sharedApplication] delegate] window] withMessageDetails:messageDetails];
    
    [popUpview showInView:parentView withMessageDetails:messageDetails];

    __weak STPrivacyPolicyPopupView *weakPopUpView = popUpview;
    
    popUpview.closeActionBlock = ^{
        [weakPopUpView removeFromSuperview];
        [[STPrivacyPolicyManager sharedManager] updatePrivacyMessageAsSeenWithID:messageID];
    };
    
    popUpview.learnMoreActionBlock = ^(NSString *hyperlinkUrl){
        
        STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
        webView.urlString = hyperlinkUrl;
        webView.titleText = @"Learn More";
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
        
        [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:navController animated:YES completion:nil];
        
        [weakPopUpView removeFromSuperview];
        [[STPrivacyPolicyManager sharedManager] updatePrivacyMessageAsSeenWithID:messageID];
    };
    
    popUpview.linkActionBlock = ^(NSURL *hyperlinkUrl){
        
        STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
        webView.urlString = [hyperlinkUrl absoluteString];
        webView.titleText = @"";

        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];

        [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:navController animated:YES completion:nil];
//        [weakPopUpView removeFromSuperview];
//        [[STPrivacyPolicyManager sharedManager] updatePrivacyMessageAsSeenWithID:messageID];
    };
}

@end
