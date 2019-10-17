//
//  STLocationViewController.h
//  StipendTesting
//
//  Created by Ganesh Kumar on 11/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface STLocationViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic , strong) NSDictionary *locationDetails;

@property (weak, nonatomic) IBOutlet UIView *pointsOfInterestView;
@property (weak, nonatomic) IBOutlet UIView *nearbyCollegesView;

@property (weak, nonatomic) IBOutlet UIButton *getDirectionButton;


- (IBAction)changeMapTypeWithSegmentControl:(UISegmentedControl*)segmentController;
- (IBAction)onGetDirectionClick:(id)sender;

@end
