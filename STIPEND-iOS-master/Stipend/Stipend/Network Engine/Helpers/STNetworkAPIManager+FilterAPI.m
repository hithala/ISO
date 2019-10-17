//
//  STNetworkAPIManager+FilterAPI.m
//  Stipend
//
//  Created by Ganesh Kumar on 22/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager+FilterAPI.h"

@implementation STNetworkAPIManager (FilterAPI)

- (void) getMajorsMasterData:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {

    [self GET:@"getMajorsInfo" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        successBlock(responseObject);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

@end
