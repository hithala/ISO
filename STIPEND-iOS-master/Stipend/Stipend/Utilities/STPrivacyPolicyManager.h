//
//  STPrivacyPolicyManager.h
//  Stipend
//
//  Created by sourcebits on 04/02/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STPrivacyPolicyManager : NSObject

+(STPrivacyPolicyManager *) sharedManager;

- (void)checkIfPrivacyMessageIsUpdatedAndShowInView:(UIView *)parentView;
- (void)updatePrivacyMessageAsSeenWithID:(NSString *)messageID;

- (void)setupInitialStatusForPrivacyPolicyIfNeed;

@end
