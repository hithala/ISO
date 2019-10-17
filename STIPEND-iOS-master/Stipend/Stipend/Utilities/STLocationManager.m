//
//  STLocationManager.m
//  Stipend
//
//  Created by Arun S on 04/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STLocationManager.h"

@implementation STLocationManager

+(STLocationManager *) sharedManager {
    
    static STLocationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

- (id)init {
    
    self = [super init];
    if(self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100; // meters
        self.locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

- (void)startUpdatingLocation {
    
    STLog(@"Starting location updates");
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    STLog(@"Location service failed with error %@", error);
    self.currentLocation = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations {
    
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;
}

-(BOOL)hasAccessToLocationServices {
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    BOOL shouldFetchLocation = NO;
    
    if (locationAllowed && (self.currentLocation != nil)) {
        shouldFetchLocation = YES;
    }
    
    return shouldFetchLocation;
}

@end
