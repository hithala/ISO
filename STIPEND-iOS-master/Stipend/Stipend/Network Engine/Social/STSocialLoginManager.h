//
//  STSocialLoginManager.h
//  Stipend
//
//  Created by Arun S on 21/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

typedef NS_ENUM(NSInteger, ActivityType) {
    ActivityFacebookType  = 1,
    ActivityTwitterType   = 2,
    ActivityMailType      = 3,
};
#import <Foundation/Foundation.h>
#import <TwitterKit/TWTRKit.h>
#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import "STCollegeDetailViewController.h"

@interface STSocialLoginManager : NSObject 

@property(nonatomic,assign) id   delegate;
@property(nonatomic,strong) ACAccountStore *accountStore;
@property(nonatomic,strong) ACAccount *facebookAccount;

@property(nonatomic,assign) BOOL isFacebookShare;
@property(nonatomic,assign) BOOL isTwitterShare;

@property(nonatomic,weak) STCollegeDetailViewController *controller;

@property(nonatomic,weak) UIImage *shareImage;

+ (STSocialLoginManager *)sharedManager;

- (void)connectToFacebookAccount;
- (void)connectToTwitterAccount;

//- (void)presentActivityViewController:(STCollegeDetailViewController *)controller withShareImage:(UIImage *)shareImage;

-(void)attemptRenewCredentials;

- (void)loggedOutFromFacebook:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void)logoutFromTwitter;

@property (copy, nonatomic) void (^socialLoginSuccess)(NSMutableDictionary *dictionary);
@property (copy, nonatomic) void (^socialLoginFailed)(NSError *error);

//- (void)facebookComposeViewController;

@end
