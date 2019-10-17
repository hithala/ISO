//
//  STMapViewManager.h
//  Stipend
//
//  Created by Ganesh Kumar on 18/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface STMapViewManager : NSObject<MKMapViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) MKMapView *mapView;

+(STMapViewManager *) sharedManager;

@end
