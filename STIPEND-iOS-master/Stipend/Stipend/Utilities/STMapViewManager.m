//
//  STMapViewManager.m
//  Stipend
//
//  Created by Ganesh Kumar on 18/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STMapViewManager.h"

@implementation STMapViewManager


+(STMapViewManager *) sharedManager {
    
    static STMapViewManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

- (id)init {
    
    self = [super init];
    if(self != nil) {
        self.mapView = [[MKMapView alloc] init];
        self.mapView.delegate = self;
    }
    return self;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    

}


@end
