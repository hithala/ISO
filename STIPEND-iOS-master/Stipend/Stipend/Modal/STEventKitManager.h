//
//  STEventKitManager.h
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 10/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
@import EventKit;

@interface STEventKitManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;

@property (nonatomic, assign) BOOL           isGranted;

+ (STEventKitManager *)sharedManager;

- (void)addEventToCalenderWithDetails:(NSDictionary *)infoDict;
- (void)updateAuthorizationStatusToAccessEventStore:(NSDictionary *)infoDict;

@end
