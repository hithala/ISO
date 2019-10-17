//
//  STNetworkAPIManager+WeatherAPI.m
//  Stipend
//
//  Created by Ganesh Kumar on 23/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager+WeatherAPI.h"

#define kDarkSkyAPIKey          @"13a67f8b459006253719417a6a74ffc6"

@implementation STNetworkAPIManager (WeatherAPI)

- (void)fetchWeatherDetailsForLattitude:(double)lattitude andLongitude:(double)longitude success:(STSuccessBlock)success failure:(STErrorBlock)failure {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.darksky.net/forecast/%@/%+f,%+f", kDarkSkyAPIKey, lattitude, longitude];

    [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failure(error);
    }];
}

@end
