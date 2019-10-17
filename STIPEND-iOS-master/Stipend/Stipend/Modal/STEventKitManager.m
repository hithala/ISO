//
//  STEventKitManager.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 10/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STEventKitManager.h"

@interface STEventKitManager ()
@end

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

- (void)addEventToCalenderWithDetails:(NSDictionary *)infoDict {
    
    [self updateAuthorizationStatusToAccessEventStore:infoDict];
}

- (void)updateAuthorizationStatusToAccessEventStore:(NSDictionary *)infoDict {
    
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authorizationStatus) {
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            
//            __weak STEventKitManager *weakSelf = self;
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Calendar Access Denied"
                                                  message:@"To enable CollegeHunch to access your calendar, you must grant it access by going to Settings/CollegeHunch/Calendar."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [weakSelf openDeviceSettings];
//            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            
            id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
            if([rootViewController isKindOfClass:[UINavigationController class]]) {
                rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
            }
            if([rootViewController isKindOfClass:[UITabBarController class]]) {
                rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
            }
            [rootViewController presentViewController:alertController animated:YES completion:nil];
            
            break;
        }
            
        case EKAuthorizationStatusAuthorized:{
            [self addAnEvent:infoDict];
        }
            break;
        case EKAuthorizationStatusNotDetermined: {
            
            __weak STEventKitManager *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                                                         completion:^(BOOL granted, NSError *error) {
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                 
                                                                                 if(granted) {
                                                                                     if(!self.isGranted) {
                                                                                         self.isGranted = YES;
                                                                                         [weakSelf addAnEvent:infoDict];
                                                                                     }
                                                                                 }
                                                                             });
                                                                         }];
            break;
        }
    }
}

//- (void)openDeviceSettings {
//
//    NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    if ([[UIApplication sharedApplication] canOpenURL:settingsUrl]) {
//        [[UIApplication sharedApplication] openURL:settingsUrl];
//    }
//}

- (void)addAnEvent:(NSDictionary *)infoDict {
        
    NSString *dateString = [infoDict objectForKey:@"kEventDateString"];
    
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSNumber *day = [NSNumber numberWithInteger:[[dateArray objectAtIndex:2] integerValue]];
    NSNumber *month = [NSNumber numberWithInteger:[[dateArray objectAtIndex:1] integerValue]];
    NSNumber *year = [NSNumber numberWithInteger:[[dateArray objectAtIndex:0] integerValue]];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setNanosecond:0];
    [components setDay:[day intValue]];
    [components setMonth:[month intValue]];
    [components setYear:[year intValue]];
    NSDate *formatedDate = [calendar dateFromComponents:components];
    
    
    EKEvent *event = [EKEvent eventWithEventStore:[STEventKitManager sharedManager].eventStore];
    event.title = [[infoDict objectForKey:@"kEventDescription"] capitalizedString];
    [event setTimeZone:[NSTimeZone systemTimeZone]];
    event.startDate = formatedDate;
    event.endDate = formatedDate;
    event.allDay = YES;
    [event setCalendar:[[STEventKitManager sharedManager].eventStore defaultCalendarForNewEvents]];
    
    NSString *predicateString= [NSString stringWithFormat:@"title == \"%@\"", event.title];
    NSPredicate *matches = [NSPredicate predicateWithFormat:predicateString];
    
    NSArray *datedEvents = [self.eventStore eventsMatchingPredicate:[self.eventStore predicateForEventsWithStartDate:event.startDate endDate:event.endDate calendars:nil]]; //search in all calendars

    NSArray *matchingEvents = [datedEvents filteredArrayUsingPredicate:matches];

    if(matchingEvents && ([matchingEvents count] > 0)) {
        [STProgressHUD showImage:[UIImage imageNamed:@"toast_added"] andStatus:@"Event already added to Calendar"];
    }
    else {
        NSError *err = nil;
        [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        
        if(!err) {
            
            NSString *body = [NSString stringWithFormat:@"\"%@\" Event added to Calendar",[[infoDict objectForKey:@"kEventDescription"] capitalizedString]];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Event Added"
                                                                                     message:body
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            
            id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
            if([rootViewController isKindOfClass:[UINavigationController class]]) {
                rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
            }
            if([rootViewController isKindOfClass:[UITabBarController class]]) {
                rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
            }
            [rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    }
}

@end
