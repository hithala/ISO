//
//  STPrivacyPolicyManager.m
//  Stipend
//
//  Created by sourcebits on 04/02/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import "STPrivacyPolicyManager.h"

@implementation STPrivacyPolicyManager

+(STPrivacyPolicyManager *) sharedManager {
    
    static STPrivacyPolicyManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

- (void)checkIfPrivacyMessageIsUpdatedAndShowInView:(UIView *)parentView {
    
    NSString *previousMessageID = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_SEEN_PRIVACY_POLICY_ID];
    
    if(previousMessageID) {
        
        [[STNetworkAPIManager sharedManager] getPrivacyMessage:^(id response) {
            STLog(@"%@", response);
            
            NSInteger errorCode = [[response objectForKey:kErrorCode] integerValue];
            
            if (errorCode == 0) {
                
                NSDictionary *messageDict = [response objectForKey:@"PrivacyMessage"];
                
                NSString *messageID = [[messageDict objectForKey:@"privacyMessageID"] stringValue];
                
                if (![self compareLastMessageIDWithNewMessageID:messageID]) {
                    [STUtilities showPrivacyPolicyViewWithMessageDetails:messageDict andMessageID:messageID andShowInView:parentView];
                }
            }
            
        } failure:^(NSError *error) {
            STLog(@"%@", error);
        }];
    }
}

- (BOOL)compareLastMessageIDWithNewMessageID:(NSString *)newMessageID {
    
    NSString *previousMessageID = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_SEEN_PRIVACY_POLICY_ID];

    if ([previousMessageID isEqualToString:newMessageID]) {
        return YES;
    } else {
        return NO;
    }
    
    return YES;
}


- (void)updatePrivacyMessageAsSeenWithID:(NSString *)messageID {
    
    [[NSUserDefaults standardUserDefaults] setObject:messageID forKey:LAST_SEEN_PRIVACY_POLICY_ID];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)setupInitialStatusForPrivacyPolicyIfNeed {
    
    NSString *previousMessageID = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_SEEN_PRIVACY_POLICY_ID];
    
    if(!previousMessageID) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:LAST_SEEN_PRIVACY_POLICY_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSDate *)getDateFromString:(NSString *)string {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:string];
    
    return dateFromString;
}

- (NSString *)getStringFromDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    
    return stringDate;
}


@end
