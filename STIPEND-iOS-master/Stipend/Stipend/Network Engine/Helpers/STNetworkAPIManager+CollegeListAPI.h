//
//  STNetworkAPIManager+CollegeListAPI.h
//  Stipend
//
//  Created by Ganesh Kumar on 17/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager.h"
#import "STCollege.h"

@interface STNetworkAPIManager (CollegeListAPI)

- (void) fetchCollegeListsWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) updateCollegeListsToCoreDataWithDetails:(NSMutableDictionary *) details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) fetchDefaultCollege:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) fetchCollegeMajorsListWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (NSDictionary *) getCollegesForMajorsCodes:(NSArray *)majorCodes;

@end
