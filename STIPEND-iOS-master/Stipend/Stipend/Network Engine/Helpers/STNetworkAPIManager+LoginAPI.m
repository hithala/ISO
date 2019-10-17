//
//  STNetworkAPIManager+LoginAPI.m
//  Stipend
//
//  Created by Arun S on 08/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager+LoginAPI.h"
#import "STUser.h"

@implementation STNetworkAPIManager(LoginAPI)

- (void) signUpUserWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    __weak STNetworkAPIManager *weakSelf = self;

    [self POST:@"userSignUp" parameters:details progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf updateUserToCoreDataWithDetails:responseObject forResponseType:eResponseTypeSignUp success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) loginUserWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    __weak STNetworkAPIManager *weakSelf = self;

    [self POST:@"userLogin" parameters:details progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf updateUserToCoreDataWithDetails:responseObject forResponseType:eResponseTypeNormalLogin success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) forgotPasswordWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    __weak STNetworkAPIManager *weakSelf = self;

    [self POST:@"forgotPassword" parameters:details progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf updateUserToCoreDataWithDetails:responseObject forResponseType:eResponseTypeForgotPassword success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) connectFacebookUserWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {

    __weak STNetworkAPIManager *weakSelf = self;

    [self POST:@"fbLogin" parameters:details progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *fName = [details objectForKey:kFirstName];
        NSString *lName = [details objectForKey:kLastName];
        
        NSMutableDictionary *userDetails = [responseObject mutableCopy];
        
        if(![self isNullValueForObject:fName]) {
            [userDetails setObject:fName forKey:kFirstName];
        }
        
        if(![self isNullValueForObject:lName]) {
            [userDetails setObject:lName forKey:kLastName];
        }
        
        [weakSelf updateUserToCoreDataWithDetails:userDetails forResponseType:eResponseTypeFacebook success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) connectTwitterUserWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    __weak STNetworkAPIManager *weakSelf = self;

    [self POST:@"twitterLogin" parameters:details progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *fName = [details objectForKey:kFirstName];
        NSString *lName = [details objectForKey:kLastName];
        
        NSMutableDictionary *userDetails = [responseObject mutableCopy];
        
        if(![self isNullValueForObject:fName]) {
            [userDetails setObject:fName forKey:kFirstName];
        }
        
        if(![self isNullValueForObject:lName]) {
            [userDetails setObject:lName forKey:kLastName];
        }
        
        [weakSelf updateUserToCoreDataWithDetails:userDetails forResponseType:eResponseTypeTwitter success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) loginGuestUserWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
 
    NSUUID *udid = [[UIDevice currentDevice] identifierForVendor];
    NSString *userID = [udid UUIDString];
    NSString *fName = @"Guest";
    NSString *lName = @"User";
    NSString *emailID = @"guestuser@xyz.com";
    
    NSMutableDictionary *guestDetails = [NSMutableDictionary dictionaryWithObjectsAndKeys:userID,kUserID,fName,kFirstName,lName,kLastName,emailID,kEmailID, nil];
    [self updateUserToCoreDataWithDetails:guestDetails forResponseType:eResponseTypeGuestLogin success:successBlock failure:failureBlock];
}

- (void) updateUserToCoreDataWithDetails:(NSMutableDictionary *) details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    NSInteger errorCode = [[details objectForKey:kErrorCode] integerValue];
    
    if(errorCode == -1) {
        
        NSError *error = [NSError errorWithDomain:[details objectForKey:kStatus] code:2000 userInfo:nil];
        failureBlock(error);
        
    } else if (errorCode == 0) {
        
        if(type == eResponseTypeForgotPassword) {
            successBlock(details);
        }
        else if((type == eResponseTypeNormalLogin) || (type == eResponseTypeSignUp) || (type == eResponseTypeGuestLogin) || (type == eResponseTypeTwitter) || (type == eResponseTypeFacebook)) {
            
            NSString *userID;
            
            if(type == eResponseTypeGuestLogin) {
                userID = [details objectForKey:kUserID];
            }
            else {
                NSNumber *userIDVal = [details objectForKey:kUserID];
                userID = [NSString stringWithFormat:@"%@",userIDVal];
            }
            
            if(![self isNullValueForObject:userID]) {
                
                if(userID) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@",userID];
                    STUser *localUser = [STUser MR_findFirstWithPredicate:predicate];
                    
                    if(localUser) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:IS_NEW_USER];
                    }
                    else {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:IS_NEW_USER];
                    }
                }
                
                NSString *fName = [details objectForKey:kFirstName];
                NSString *lName = [details objectForKey:kLastName];
                NSNumber *isAdmin = [details objectForKey:kUserRole];
                NSString *emailID = [details objectForKey:kEmailID];
                NSNumber *pushNotificationState = [details objectForKey:kPushNotificationState];
                NSNumber *sortOrder = [details objectForKey:kUserSortOrder];
                
                id genderTypeValue = [details objectForKey:kGenderType];
                id userTypeValue = [details objectForKey:kUserType];
                
                NSNumber *genderType;
                NSNumber *userType;
                
                if(![self isNullValueForObject:genderTypeValue]) {
                    genderType = [NSNumber numberWithInteger:[genderTypeValue integerValue]];
                }
                
                if(![self isNullValueForObject:userTypeValue]) {
                    userType = [NSNumber numberWithInteger:[userTypeValue integerValue]];
                }
                
                if(userID && (![userID isEqualToString:@""])) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:USER_ID];
                    
                    switch (type) {
                        case eResponseTypeNormalLogin:
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:eLoginTypeNormalUser] forKey:LOGIN_TYPE];
                            break;
                        case eResponseTypeGuestLogin:
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:eLoginTypeGuest] forKey:LOGIN_TYPE];
                            break;
                        case eResponseTypeTwitter:
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:eLoginTypeTwitter] forKey:LOGIN_TYPE];
                            break;
                        case eResponseTypeFacebook:
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:eLoginTypeFacebook] forKey:LOGIN_TYPE];
                            break;
                        default:
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:eLoginTypeNormalUser] forKey:LOGIN_TYPE];
                            break;
                    }
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                        
                        STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                        
                        if(!localUser) {
                            localUser = [STUser MR_createEntityInContext:localContext];
                            
                            if([self isNullValueForObject:pushNotificationState]) {
                                localUser.pushNotificationState = [NSNumber numberWithInt:1];
                            } else {
                                localUser.pushNotificationState = pushNotificationState;
                            }
                            
                            if([self isNullValueForObject:sortOrder]) {
                                localUser.sortOrder = [NSNumber numberWithInt:0];
                            } else {
                                localUser.sortOrder = sortOrder;
                            }
                            
                            localUser.defaultMapAppType = [NSNumber numberWithInteger:eMapAppTypeAlwaysAsk];
                        }
                        
                        localUser.userID = userID;
                        localUser.isAdmin = isAdmin;
                        
                        NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
                        NSString *fullName;
                        
                        if(![self isNullValueForObject:fName]) {
                            localUser.firstName = fName;
                            [properties setObject:fName forKey:@"$first name"];
                            fullName = [NSString stringWithFormat:@"%@", fName];
                        }
                        
                        if(![self isNullValueForObject:lName]) {
                            localUser.lastName = lName;
                            [properties setObject:lName forKey:@"$last name"];
                            fullName = [NSString stringWithFormat:@"%@ %@", fullName, lName];
                        }
                        
                        if(![self isNullValueForObject:emailID]) {
                            localUser.emailID = emailID;
                            [properties setObject:emailID forKey:@"$email"];
                        }
                        
                        if(![self isNullValueForObject:userType]) {
                            localUser.userType = userType;
                            [properties setObject:userTypeString([userType integerValue]) forKey:@"user type"];
                        }
                        
                        if(![self isNullValueForObject:genderType]) {
                            localUser.genderType = genderType;
                            [properties setObject:genderTypeString([genderType integerValue]) forKey:@"gender"];
                        }
                        
                        if(![self isNullValueForObject:fullName]){
                             [properties setObject:fullName forKey:@"$name"];
                        }
                        
                        
                    } completion:^(BOOL success, NSError *error) {
                        
                        [[STUserManager sharedManager] setDefaultCollegeSectionsForCurrentUserIfNeeded];
                        [STUserManager sharedManager].favoritesUpdates = false;
                        [STUserManager sharedManager].compareUpdates = false;
                        [STUserManager sharedManager].clippingsUpdate = false;
                        [STUserManager sharedManager].filterUpdate = false;
                        successBlock([NSNull null]);
                    }];
                }
                else {
                    NSError *error = [NSError errorWithDomain:@"USER ID MISSING" code:111 userInfo:nil];
                    failureBlock(error);
                }
            }
            else {
                NSError *error = [NSError errorWithDomain:@"USER ID MISSING" code:111 userInfo:nil];
                failureBlock(error);
            }
        }
    }
}

- (void)logout:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    NSNumber *loginType = [STUserManager sharedManager].loginType;

    if([[STUserManager sharedManager] isGuestUser]) {
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
            if(localUser) {
                [localUser MR_deleteEntity];
            }
        }
        completion:^(BOOL success, NSError *error) {
            [self resetUserDefaults];
            successBlock(nil);
        }];
    }else if ([loginType integerValue] == eLoginTypeFacebook){
            [[STSocialLoginManager sharedManager] loggedOutFromFacebook:^(id response) {
                [self resetUserDefaults];
                successBlock(nil);
            } failure:^(NSError *error) {
                failureBlock(error);
            }];
    }else if ([loginType integerValue] == eLoginTypeTwitter){
        [self resetUserDefaults];
        [[STSocialLoginManager sharedManager] logoutFromTwitter];
        
        if(successBlock) {
            successBlock(nil);
        }
    }else{
        
        [self resetUserDefaults];
        if(successBlock) {
            successBlock(nil);
        }
    }
}

- (void)resetUserDefaults{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGIN_TYPE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IS_NEW_USER];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FILTER_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
