//
//  STNetworkAPIManager.m
//  Stipend
//
//  Created by Arun S on 22/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager.h"

@implementation STNetworkAPIManager

/*
 _sharedClient = [[FFAPIService alloc] initWithBaseURL:[NSURL URLWithString:kFFBaseUrl]];
 _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
 [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
 AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
 [policy setValidatesDomainName:NO];
 [policy setAllowInvalidCertificates:YES];
 [policy setValidatesDomainName:NO];
 _sharedClient.securityPolicy = policy;
 */

+ (STNetworkAPIManager *) sharedManager {

    static STNetworkAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[STNetworkAPIManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        
        if ([BASE_URL  isEqual: DEVELOPMENT_BASE_URL]) {
            AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            [policy setValidatesDomainName:NO];
            [policy setAllowInvalidCertificates:YES];
            [policy setValidatesDomainName:NO];
            sharedManager.securityPolicy = policy;
        }
        
    });
    
    return sharedManager;
}

- (id)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    if(self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)addDefaultHeaders {
    
}

- (void)addAuthHeaders {
    
    NSString *authkey = @"";
    
    if(authkey) {
        [self.requestSerializer setValue:authkey forHTTPHeaderField:@"kAuthKey"];
    }
}

- (BOOL) isNullValueForObject:(id) object {
    
    if(object && (![object isEqual:[NSNull null]])) {
        return NO;
    }
    
    return YES;
}


@end
