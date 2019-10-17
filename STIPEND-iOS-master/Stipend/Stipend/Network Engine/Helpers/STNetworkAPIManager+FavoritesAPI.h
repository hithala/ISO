//
//  STNetworkAPIManager+FavoritesAPI.h
//  Stipend
//
//  Created by Ganesh Kumar on 24/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager.h"

@interface STNetworkAPIManager (FavoritesAPI)

- (void) getFavoriteCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) addCollegeToFavoriteWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) removeCollegeFromFavouriteWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) syncFavoriteCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) updateFavoriteCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) updateUserFavoritesToCoreDataWithDetails:(NSMutableDictionary *)details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
@end
