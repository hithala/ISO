//
//  STNetworkAPIManager+PrivacyMessageAPI.h
//  
//
//  Created by Ganesh Kumar on 13/04/16.
//
//

#import "STNetworkAPIManager.h"

@interface STNetworkAPIManager (PrivacyMessageAPI)

- (void) getPrivacyMessage:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

@end
