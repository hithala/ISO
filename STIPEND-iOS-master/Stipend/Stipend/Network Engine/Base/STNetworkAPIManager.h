//
//  STNetworkAPIManager.h
//  Stipend
//
//  Created by Arun S on 22/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^STSuccessBlock)(id response);
typedef void(^STErrorBlock)(NSError *error);

@interface STNetworkAPIManager : AFHTTPSessionManager

+ (STNetworkAPIManager *) sharedManager;
- (void) addDefaultHeaders;
- (void) addAuthHeaders;

- (BOOL) isNullValueForObject:(id) object;

@end
