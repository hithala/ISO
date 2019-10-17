//
//  STNetworkAPIManager+LoginAPI.h
//  Stipend
//
//  Created by Arun S on 08/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager.h"
#import "STSocialLoginManager.h"

@interface STNetworkAPIManager(LoginAPI)

- (void) signUpUserWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) loginUserWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) loginGuestUserWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) forgotPasswordWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) connectFacebookUserWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) connectTwitterUserWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) updateUserToCoreDataWithDetails:(NSMutableDictionary *) details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void)logout:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

@end
