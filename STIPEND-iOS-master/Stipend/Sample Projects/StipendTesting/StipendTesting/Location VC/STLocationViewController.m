//
//  STLocationViewController.m
//  StipendTesting
//
//  Created by Ganesh Kumar on 11/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STLocationViewController.h"
#import "STGetDirectionPopupView.h"


#define COLLEGE_LATITUDE                @"kCollegeLatitudeKey"
#define COLLEGE_LONGITUDE               @"kCollegeLongitudeKey"
#define COLLEGE_NAME                    @"kCollegeNameKey"

@interface STLocationViewController () {
    
    CLLocationCoordinate2D collegeCoordinate;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@end

@implementation STLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"location details : %@", self.locationDetails);
    
    self.title = @"Location";
    
    double latitude = [[self.locationDetails objectForKey:COLLEGE_LATITUDE] doubleValue];
    double longitude = [[self.locationDetails objectForKey:COLLEGE_LONGITUDE] doubleValue];
    
    collegeCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    
    NSString *collegeName = [[[self.locationDetails objectForKey:COLLEGE_NAME] componentsSeparatedByString:@" "] objectAtIndex:0];
    
    NSString *getDirectButtonTitle = [NSString stringWithFormat:@"Get Directions to %@", collegeName];
    
    [self.getDirectionButton setTitle:getDirectButtonTitle forState:UIControlStateNormal];
    
    [self updateMapTypeWithIndexValue:0];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }

}


// Corelocation delegate methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError: %@", error);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"Location details: %@", [locations firstObject]);
    currentLocation = [locations firstObject];
    [locationManager stopUpdatingLocation];
}


// MKMapview delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString* AnnotationIdentifier = @"Annotation";
    
    MKPinAnnotationView *customPinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
   // MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    
    MKPointAnnotation *annotationPoint = annotation;
    
    if (!customPinView) {
        
        if (annotationPoint.coordinate.latitude == collegeCoordinate.latitude && annotationPoint.coordinate.longitude == collegeCoordinate.longitude){
            
            customPinView.image = [UIImage imageNamed:@"currentLocation.png"];
            customPinView.backgroundColor = [UIColor greenColor];
        }
        
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        
    } else {
        
        customPinView.annotation = annotation;
    }
    
    return customPinView;
}


- (IBAction)changeMapTypeWithSegmentControl:(UISegmentedControl *)segmentController {
    
    NSInteger selectedIndex = segmentController.selectedSegmentIndex;
    
    [self updateMapTypeWithIndexValue:selectedIndex];

}

- (void)updateMapTypeWithIndexValue:(NSInteger)indexValue {
    

    if(indexValue == 0) {
        
        [self.pointsOfInterestView setHidden:NO];
        [self.nearbyCollegesView setHidden:YES];
        
        MKMapView *pointsOfInterestMapView = (MKMapView *)[self.pointsOfInterestView viewWithTag:100];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(collegeCoordinate, 800, 800);
        [pointsOfInterestMapView setRegion:[pointsOfInterestMapView regionThatFits:region] animated:YES];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = collegeCoordinate;
        point.title = [self.locationDetails objectForKey:COLLEGE_NAME];
        [pointsOfInterestMapView addAnnotation:point];
        
       /* double latitude = [[self.locationDetails objectForKey:COLLEGE_LATITUDE] doubleValue];
        double longitude = [[self.locationDetails objectForKey:COLLEGE_LONGITUDE] doubleValue];
        
        latitude += 0.0001;
        longitude += 0.0001;
        
        MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
        point1.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        point1.title = [self.locationDetails objectForKey:COLLEGE_NAME];
        [pointsOfInterestMapView addAnnotation:point1]; */
        
    } else {
        
        [self.pointsOfInterestView setHidden:YES];
        [self.nearbyCollegesView setHidden:NO];
        
        MKMapView *nearbyCollegesMapView = (MKMapView *)[self.nearbyCollegesView viewWithTag:101];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(collegeCoordinate, 1500, 1500);
        [nearbyCollegesMapView setRegion:[nearbyCollegesMapView regionThatFits:region] animated:YES];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = collegeCoordinate;
        point.title = [self.locationDetails objectForKey:COLLEGE_NAME];
        [nearbyCollegesMapView addAnnotation:point];
        
    }
}

- (IBAction)onGetDirectionClick:(id)sender {
    
    UIView *popupBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    popupBackgroundView.tag = 2201;
    
    NSDictionary *latLongDict = @{@"sourceLat":[NSNumber numberWithDouble:currentLocation.coordinate.latitude] ,@"sourceLong":[NSNumber numberWithDouble:currentLocation.coordinate.longitude],@"destinationLat":[NSNumber numberWithDouble:collegeCoordinate.latitude],@"destinationLong":[NSNumber numberWithDouble:collegeCoordinate.longitude]};
    
    NSMutableArray *mapAppsList = [[NSMutableArray alloc] init];
    
    NSDictionary *appDetails = @{@"appIcon":@"appleMaps.png", @"appName":@"Apple Maps", @"appType":@"1"};
    [mapAppsList addObject:appDetails];
    
    BOOL isGoogleMapsInstalled = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps://"]];
    
    
    if(isGoogleMapsInstalled) {
        NSDictionary *appDetails = @{@"appIcon":@"googleMaps.png", @"appName":@"Google Maps", @"appType":@"2"};
        [mapAppsList addObject:appDetails];
    }
    
    
    STGetDirectionPopupView *popupView = [[[NSBundle mainBundle] loadNibNamed:@"STGetDirectionPopupView" owner:self options:nil] firstObject];
    popupView.frame = CGRectMake(0, 0, self.view.frame.size.width-40, 201+mapAppsList.count*60);
    popupView.center = self.view.center;
    popupView.mapAppsList = mapAppsList;
    popupView.latLongDict = latLongDict;
    
    [popupBackgroundView addSubview:popupView];
    [self.navigationController.view addSubview:popupBackgroundView];
    
    popupBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    
    
    popupView.cancelActionBlock = ^{
        UIView *popupview = [self.navigationController.view viewWithTag:2201];
        
        popupview.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            popupview.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished){
            popupview.hidden = YES;
            [popupview removeFromSuperview];
        }];
        
    };
    
    popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        popupView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
