//
//  STSocialLoginManager.m
//  Stipend
//
//  Created by Arun S on 21/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STSocialLoginManager.h"
#import "STIntroductionViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#define ABOUT_ME_API_ENDPOINT      @"me"

@interface STSocialLoginManager ()

@property (nonatomic, strong) FBSDKLoginManager *loginManager;

@end

@implementation STSocialLoginManager
@synthesize accountStore,isTwitterShare,isFacebookShare;

+ (STSocialLoginManager *)sharedManager {
    
    static STSocialLoginManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[STSocialLoginManager alloc] init];
    });
    return sharedManager;
}

- (id)init{
    if (self ==  [super init]){
        accountStore = [[ACAccountStore alloc] init];
        isFacebookShare = NO;
        isTwitterShare = NO;
    }
    return self;
}

#pragma mark - Twitter Related Methods

- (void)connectToTwitterAccount {
    
    __weak STSocialLoginManager *weakSelf = self;
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
         if (session) {
             [weakSelf returnUserDataFromTwitter:session.userID];
             STLog(@"signed in as %@", [session userName]);
         } else {
             STLog(@"error: %@", [error localizedDescription]);
             if(weakSelf.socialLoginFailed) {
                 weakSelf.socialLoginFailed(error);
             }
         }
     }];
}

- (void)returnUserDataFromTwitter:(NSString *)userid {
    
    __weak STSocialLoginManager *weakSelf = self;
    
    TWTRAPIClient *twtrApiClient = [[TWTRAPIClient alloc] initWithUserID:userid];
    [twtrApiClient loadUserWithID:userid completion:^(TWTRUser * _Nullable user, NSError * _Nullable error) {
        if(!error) {
            
            NSMutableDictionary *userDetails = [[NSMutableDictionary alloc] init];
            [userDetails setObject:user.userID forKey:kTwitterID];
            
            if(user.name) {
                [userDetails setObject:user.name forKey:kFirstName];
            }
            
            if(weakSelf.socialLoginSuccess){
                weakSelf.socialLoginSuccess(userDetails);
            }else{
                weakSelf.socialLoginFailed(nil);
            }
        } else {
            STLog(@"Error: %@", error);
            if(weakSelf.socialLoginFailed) {
                weakSelf.socialLoginFailed(nil);
            }
        }
    }];
    
    /*
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/users/show.json";
    NSDictionary *params = @{@"id" : userid};
    NSError *clientError;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                             URLRequestWithMethod:@"GET"
                             URL:statusesShowEndpoint
                             parameters:params
                             error:&clientError];
    
    if (request) {
        
        [[[Twitter sharedInstance] APIClient]
         sendTwitterRequest:request
         completion:^(NSURLResponse *response,
                      NSData *data,
                      NSError *connectionError) {
             if (data) {
                 
                 NSError *jsonError;
                 NSDictionary *userDict = [NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:0
                                       error:&jsonError];
                 STLog(@"json = %@",userDict);
                 
                 NSMutableDictionary *userDetails = [[NSMutableDictionary alloc] init];
                 [userDetails setObject:[userDict objectForKey:@"id"] forKey:kTwitterID];
                 
                 if([userDict objectForKey:@"name"]) {
                     [userDetails setObject:[userDict objectForKey:@"name"] forKey:kFirstName];
                 }
                 
                 if(weakSelf.socialLoginSuccess){
                     weakSelf.socialLoginSuccess(userDetails);
                 }else{
                     weakSelf.socialLoginFailed(nil);
                 }
             }
             else {
                 STLog(@"Error: %@", connectionError);
                 if(weakSelf.socialLoginFailed) {
                     weakSelf.socialLoginFailed(nil);
                 }
             }
         }];
    }
    else {
        STLog(@"Error: %@", clientError);
        
        if(weakSelf.socialLoginFailed) {
            weakSelf.socialLoginFailed(nil);
        }
    } */
}

- (void)logoutFromTwitter {
   /* Deletes the local Twitter user session from this app. This will not remove the system Twitter account nor make a network request to invalidate the session.*/
    
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    NSString *userID = store.session.userID;
    [store logOutUserID:userID];
}
#pragma mark Custom Activity View Methods
/*
- (void)presentActivityViewController:(STCollegeDetailViewController *)controller withShareImage:(UIImage *)shareImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"image.png"];
    
    NSString *text = @"Check out the college I found using the CollegeHunch app! Find yours at collegehunch.com";
    UIImage *imageFromFile = [UIImage imageWithContentsOfFile:filePath];

    NSArray *objectsToShare = @[text,imageFromFile];
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc] initWithActivityItems:objectsToShare
                                      applicationActivities:nil];
    
    [activityVC setValue:@"College Search the Easy Way!" forKey:@"subject"];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeAirDrop,UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypeAssignToContact];
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed){
        NSString *title = nil;
        NSString *message = nil;
        NSString *shareType = nil;
        if ( [activityType isEqualToString:UIActivityTypeMail] ){
            title = @"Mail";
            message = completed?@"Mail action performed successfully":@"There was problem in sending mail.";
            shareType = @"Mail";
        }else if ( [activityType isEqualToString:UIActivityTypePostToTwitter] ){
            title = @"Twitter";
             message = completed?@"Posted successfully to Twitter.":@"There was problem in posting to Twitter.";
            shareType = @"Twitter";
        }else if ( [activityType isEqualToString:UIActivityTypePostToFacebook] ){
            title = @"Facebook";
             message = completed?@"Posted successfully to Facebook.":@"There was problem in posting to Facebook.";
            shareType = @"Facebook";
        }else if ([activityType isEqualToString:UIActivityTypeMessage]){
            message = completed?@"Message sent successfully.":@"There was problem in sending the message.";
            shareType = @"Message";
        }else if ([activityType isEqualToString:UIActivityTypeSaveToCameraRoll]){
            message = completed?@"Saved to camera roll successfully.":@"There was problem in saving to camera roll.";
            shareType = @"Camera Roll";
        }
        else {
            message = completed?@"Message sent successfully.":@"There was problem in sending the message.";
        }
        
        if (activityType != nil && completed) {
            [STProgressHUD showImage:[UIImage imageNamed:@"toast_added"] andStatus:message];
        }
    };
        
    [controller presentViewController:activityVC animated:YES completion:^{
    }];
} */

#pragma mark- Facebook Related Methods

//This API will log into the facebook
- (void)connectToFacebookAccount {

    __weak STSocialLoginManager *weakSelf = self;
    
    //Get the facebook details from settings
    if (accountStore == nil || [accountStore accountTypeWithAccountTypeIdentifier:@"com.apple.facebook"] == nil) {
        NSError *err = [NSError errorWithDomain:@"com.accStore.configurationError" code:0 userInfo:nil];
        self.socialLoginFailed(err);
        return;
    }
    
    ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *permissionDictionary = @{ACFacebookAppIdKey: FACEBOOK_APP_ID,
                                           ACFacebookPermissionsKey: @[@"email"],
                                           };
    
    [accountStore requestAccessToAccountsWithType:FBaccountType options:permissionDictionary  completion:
     ^(BOOL granted, NSError *error) {
         if (granted) {
             
             NSArray *accounts = [weakSelf.accountStore accountsWithAccountType:FBaccountType];
             weakSelf.facebookAccount = [accounts objectAtIndex:0];
             
             if(weakSelf.facebookAccount){
                 [weakSelf getFacebookDetailsFromAccountStore];
              }
             else {
                 weakSelf.socialLoginFailed(error);
                 STLog(@"Facebook account access denied");
             }
         }
         else if(error.code == 6){//If facebook settings nil,Move to Facebook SDK.
             
             [weakSelf connectToFacebookViaSDK];
         }else if(error.code == 7){//If user not allowing the permissions to access the facebook.
             weakSelf.socialLoginFailed(error);
         }else {//Please inform the user to allow your app to enable in the settings
             weakSelf.socialLoginFailed(error);
         }
     }];
}

//Get details from account settings - Facebook
- (void)getFacebookDetailsFromAccountStore {
    
    // Fecth the user details from graph api
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/v2.12/me"];
    NSMutableDictionary * params = nil;
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:requestURL
                                               parameters:params];
    if (request == nil || self.facebookAccount == nil) {
        NSError *err = [NSError errorWithDomain:@"com.facebook.configurationError" code:0 userInfo:nil];
        self.socialLoginFailed(err);
    }
    request.account = self.facebookAccount;
    
    __weak STSocialLoginManager *weakSelf = self;

    [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
        
        if(!error) {
            
            NSDictionary *profileDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if ([profileDict objectForKey:@"error"] != nil){
                [weakSelf attemptRenewCredentials];
                
            }else{
                
                NSMutableDictionary *userDetails = [[NSMutableDictionary alloc] init];
                if([profileDict objectForKey:@"id"]){
                    [userDetails setObject:[profileDict objectForKey:@"id"] forKey:kFacebookID];
                }
                
                if([profileDict objectForKey:@"first_name"]) {
                    [userDetails setObject:[profileDict objectForKey:@"first_name"] forKey:kFirstName];
                }
                
                if([profileDict objectForKey:@"last_name"]) {
                    [userDetails setObject:[profileDict objectForKey:@"last_name"] forKey:kLastName];
                }
                
                if([profileDict objectForKey:@"email"]) {
                    [userDetails setObject:[profileDict objectForKey:@"email"] forKey:kEmailID];
                }
                
                if([profileDict objectForKey:@"name"]) {
                    [userDetails setObject:[profileDict objectForKey:@"name"] forKey:kFirstName];
                }
                
                if(weakSelf.socialLoginSuccess){
                    weakSelf.socialLoginSuccess(userDetails);
                }
            }
            
        }
        else {
            STLog(@"Error in getting details = %@",error.description);
            
            if(weakSelf.socialLoginFailed) {
                weakSelf.socialLoginFailed(error);
            }
        }
    }];
}

- (void)connectToFacebookViaSDK {
    
    __weak STSocialLoginManager *weakSelf = self;
    
    if (self.loginManager == nil) {
        self.loginManager = [[FBSDKLoginManager alloc] init];
    }

    dispatch_sync(dispatch_get_main_queue(), ^{
        
        [self.loginManager logInWithPermissions:@[@"public_profile", @"email"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
                // Process error
                
                if(weakSelf.socialLoginFailed) {
                    weakSelf.socialLoginFailed(error);
                }
            }
            else if (result.isCancelled) {
                // Handle cancellations
                
                NSError *error = [NSError errorWithDomain:@"com.facebook.cancellation"
                                                     code:-57
                                                 userInfo:nil];
                if(weakSelf.socialLoginFailed) {
                    weakSelf.socialLoginFailed(error);
                }
            }
            else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                [weakSelf returnUserData];
            }
        }];
    });
}

//Fetch the details after account store change notification fires.
- (void)attemptRenewCredentials {
    
    // For Twitter and Sina Weibo accounts, this method will prompt the user to go to Settings to re-enter their password.
    // For Facebook accounts, if your access token became invalid due to regular expiration, this method will obtain a new one.
    if (self.facebookAccount == nil || self.accountStore == nil) {
        self.socialLoginFailed(nil);
    }

    [self.accountStore renewCredentialsForAccount:(ACAccount *)self.facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
        
        if(!error) {
            
            switch (renewResult) {
                case ACAccountCredentialRenewResultRenewed:
                    [self getFacebookDetailsFromAccountStore];
                    break;
                case ACAccountCredentialRenewResultRejected:{
                    NSError *err = [NSError errorWithDomain:@"com.facebook.configurationError" code:0 userInfo:nil];
                    self.socialLoginFailed(err);
                }
                    break;
                case ACAccountCredentialRenewResultFailed:{
                    NSError *err = [NSError errorWithDomain:@"com.facebook.configurationError" code:0 userInfo:nil];
                    self.socialLoginFailed(err);
                }
                    break;
                default:
                    break;
            }
            
        }
        else {
            //handle error gracefully
            self.socialLoginFailed(error);
            STLog(@"error from renew credentials%@",error.description);
        }
    }];
}


- (void)returnUserData {
    
    if([FBSDKAccessToken currentAccessToken]) {
        
        __weak STSocialLoginManager *weakSelf = self;
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:ABOUT_ME_API_ENDPOINT];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error) {
            
            if (error == nil) {
                
                STLog(@"facebook connnection");
                NSDictionary *userDict = (NSDictionary *)user;
                
                NSMutableDictionary *userDetails = [[NSMutableDictionary alloc] init];
                [userDetails setObject:[userDict objectForKey:@"id"] forKey:kFacebookID];
                
                if([userDict objectForKey:@"first_name"]) {
                    [userDetails setObject:[userDict objectForKey:@"first_name"] forKey:kFirstName];
                }
                
                if([userDict objectForKey:@"last_name"]) {
                    [userDetails setObject:[userDict objectForKey:@"last_name"] forKey:kLastName];
                }
                
                if([userDict objectForKey:@"email"]) {
                    [userDetails setObject:[userDict objectForKey:@"email"] forKey:kEmailID];
                }
                
                if(![userDict objectForKey:@"first_name"] || ![userDict objectForKey:@"last_name"]) {
                    if([userDict objectForKey:@"name"]) {
                        [userDetails setObject:[userDict objectForKey:@"name"] forKey:kFirstName];
                    }
                }
                
                if(weakSelf.socialLoginSuccess){
                    weakSelf.socialLoginSuccess(userDetails);
                }
            }else {
                STLog(@"facebook connnection error = %@", error.description);
                if(weakSelf.socialLoginFailed) {
                    weakSelf.socialLoginFailed(error);
                    
                }
            }
        }];
    }
}

#pragma mark Facebbok Logout Method
- (void)loggedOutFromFacebook:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock{
    
    if ([FBSDKAccessToken currentAccessToken]) {
        if (self.loginManager != nil) {
            [self.loginManager logOut];
            self.loginManager = nil;
        }
        successBlock(nil);
    } else{
        successBlock(nil);
    }
}

@end


//FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/permissions/" parameters:nil HTTPMethod:@"DELETE"];
//[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){
//    if (error == nil) {
//        weakSelf.isFacebookShare = NO;
//        STLog(@"result = %@",result);
//        successBlock(result);
//    }else{
//        STLog(@"result = %@",result);
//        failureBlock(error);
//    }
//}];
