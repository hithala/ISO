//
//  STNetworkAPIManager+FilterAPI.h
//  Stipend
//
//  Created by Ganesh Kumar on 22/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager.h"

@interface STNetworkAPIManager (FilterAPI)

- (void) getMajorsMasterData:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

@end
