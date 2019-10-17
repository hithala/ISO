//
//  STNetworkAPIManager+ProfileAPI.h
//  Stipend
//
//  Created by Arun S on 08/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager.h"

@interface STNetworkAPIManager(ProfileAPI)

- (void) updateProfileWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) updateUserProfileToCoreDataWithDetails:(NSMutableDictionary *) details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

//- (void) getFilterPreferencesSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
//- (void) updateFilterPreferences:(NSMutableDictionary *)details resetState:(BOOL)resetState success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (NSMutableDictionary *) getFilterDataSource;

@end
