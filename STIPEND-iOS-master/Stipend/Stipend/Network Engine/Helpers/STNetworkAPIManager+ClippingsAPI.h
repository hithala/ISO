//
//  STNetworkAPIManager+ClippingsAPI.h
//  Stipend
//
//  Created by Arun S on 28/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager.h"

@interface STNetworkAPIManager (ClippingsAPI)

- (void) getClippingsForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) addCollegeSectionToClippingsWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) removeCollegeSectionFromClippingsWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) updateClippingsForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) updateClippingsDetailsToCoreDataWithDetails:(NSMutableDictionary *)details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

@end
