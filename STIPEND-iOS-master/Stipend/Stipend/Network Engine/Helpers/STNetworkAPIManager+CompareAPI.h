//
//  STNetworkAPIManager+CompareAPI.h
//  Stipend
//
//  Created by Arun S on 08/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager.h"
#import <StoreKit/StoreKit.h>

@interface STNetworkAPIManager (CompareAPI)

- (void) getCompareCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) addCollegeToCompareWithDetails:(NSMutableDictionary *)details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) removeCollegeFromCompareWithDetails:(NSMutableDictionary *)details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) syncCompareCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;
- (void) updateCompareCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) updateUserCompareToCoreDataWithDetails:(NSMutableDictionary *)details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) exportColleges:(NSArray *)colleges toEmailId:(NSString *)emailId success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) updateExportTransactionDetails:(SKPaymentTransaction *)transaction forMailId:(NSString *)emailId success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

@end
