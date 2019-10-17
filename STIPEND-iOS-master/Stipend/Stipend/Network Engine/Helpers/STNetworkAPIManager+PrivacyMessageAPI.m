//
//  STNetworkAPIManager+PrivacyMessageAPI.m
//  
//
//  Created by Ganesh Kumar on 13/04/16.
//
//

#import "STNetworkAPIManager+PrivacyMessageAPI.h"

@implementation STNetworkAPIManager (PrivacyMessageAPI)

- (void) getPrivacyMessage:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    [self GET:@"getPrivacyMessage" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

@end
