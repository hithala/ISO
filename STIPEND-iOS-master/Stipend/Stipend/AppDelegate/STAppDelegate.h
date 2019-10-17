//
//  STAppDelegate.h
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TWTRKit.h>
#import <Crashlytics/Crashlytics.h>
#import <MapKit/MapKit.h>

@interface STAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow          *window;

- (MKMapView *) mapView;

@end

