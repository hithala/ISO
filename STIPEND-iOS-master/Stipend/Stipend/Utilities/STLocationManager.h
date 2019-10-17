//
//  STLocationManager.h
//  Stipend
//
//  Created by Arun S on 04/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface STLocationManager : NSObject <CLLocationManagerDelegate>

+(STLocationManager *) sharedManager;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

- (void)startUpdatingLocation;
- (BOOL)hasAccessToLocationServices;

@end
