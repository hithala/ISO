//
//  STNetworkAPIManager+WeatherAPI.h
//  Stipend
//
//  Created by Ganesh Kumar on 23/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager.h"

@interface STNetworkAPIManager (WeatherAPI)

- (void) fetchWeatherDetailsForLattitude:(double)lattitude andLongitude:(double)longitude success:(STSuccessBlock)success failure:(STErrorBlock)failure;

@end
