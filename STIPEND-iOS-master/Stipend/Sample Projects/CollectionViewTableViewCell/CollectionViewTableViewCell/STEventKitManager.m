//
//  STEventKitManager.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 10/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STEventKitManager.h"

@implementation STEventKitManager

+ (STEventKitManager *)sharedManager {
    static STEventKitManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return self;
}
@end
