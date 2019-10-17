//
//  STLocationViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 11/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STLocationViewController.h"
#import "STGetDirectionPopupView.h"

@import Contacts;

#define MAX_NEARBY_DISTANCE     804672  // 500 miles in meters

@interface STLocationViewController () {
    
    CLLocationCoordinate2D currentCollegeCoordinate;
    
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) NSString *currentLocationIdentifier;
@property (nonatomic, retain) NSString *defaultLocationIdentifier;

@end

@implementation STLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Location";
    
    self.currentLocationIdentifier = @"currentLocation";
    self.defaultLocationIdentifier = @"defaultLocation";
    
    double latitude = [[self.locationDetails objectForKey:COLLEGE_LATITUDE] doubleValue];
    double longitude = [[self.locationDetails objectForKey:COLLEGE_LONGITUDE] doubleValue];
    
    currentCollegeCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    self.getDirectionButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.getDirectionButton.layer.shadowOpacity = 0.8;
    self.getDirectionButton.layer.shadowRadius = 12;
    self.getDirectionButton.layer.shadowOffset = CGSizeMake(12.0f, 12.0f);
    
    self.selectedSegmentIndex = 0;
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    MKMapView *mapView = (MKMapView *)[self.mapContainerView viewWithTag:2222];

    if(mapView) {
        CGRect mapFrame = self.mapContainerView.bounds;
        mapView.frame = mapFrame;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    STAppDelegate *appDelegate = (STAppDelegate *)[[UIApplication sharedApplication] delegate];
    MKMapView *mapView = [appDelegate mapView];
    [mapView removeAnnotations:[mapView annotations]];
    mapView.delegate = self;
    CGRect mapFrame = self.mapContainerView.bounds;
    mapView.frame = mapFrame;
    mapView.tag = 2222;
    
    [self.mapContainerView addSubview:mapView];
    [self updateMapTypeWithIndexValue:self.selectedSegmentIndex];
}

- (IBAction)changeMapTypeWithSegmentControl:(UISegmentedControl *)segmentController {
    
    NSInteger selectedIndex = segmentController.selectedSegmentIndex;
    self.selectedSegmentIndex = selectedIndex;
    [self updateMapTypeWithIndexValue:self.selectedSegmentIndex];
}

- (void)updateMapTypeWithIndexValue:(NSInteger)indexValue {
    
    MKMapView *mapView = (MKMapView *)[self.mapContainerView viewWithTag:2222];

    [mapView removeAnnotations:mapView.annotations];
    
    if(indexValue == 0) {
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCollegeCoordinate, 500, 500);
        [mapView setRegion:[mapView regionThatFits:region] animated:YES];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = currentCollegeCoordinate;
        point.title = [self.locationDetails objectForKey:KEY_LABEL];
        [mapView addAnnotation:point];
    }
    else {
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCollegeCoordinate, MAX_NEARBY_DISTANCE, MAX_NEARBY_DISTANCE);
        [mapView setRegion:[mapView regionThatFits:region] animated:YES];
        
         [self getNearByColleges];
        
    }
}

- (void)getNearByColleges {
    
    NSPredicate *collegeIDPredicate = [NSPredicate predicateWithFormat:@"collegeID != %@", self.collegeID];
    
    NSArray *collegesList = [STCollege MR_findAllSortedBy:@"collegeID" ascending:YES withPredicate:collegeIDPredicate];
    
    
    CLLocationDistance maxRadius = MAX_NEARBY_DISTANCE; // in meters
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:currentCollegeCoordinate.latitude longitude:currentCollegeCoordinate.longitude];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(STCollege *college, NSDictionary *bindings) {
        
        @autoreleasepool {
            
            double lattitude = [college.appleLattitude doubleValue];
            double longitude = [college.appleLongitude doubleValue];
            
            CLLocation *collegeLocation = [[CLLocation alloc] initWithLatitude:lattitude longitude:longitude];
            
            return ([collegeLocation distanceFromLocation:targetLocation] <= maxRadius);
        }
    }];
    
    NSArray *closeLocations = [collegesList filteredArrayUsingPredicate:predicate];
    
    MKMapView *mapView = (MKMapView *)[self.mapContainerView viewWithTag:2222];

    for(STCollege *college in closeLocations) {

        @autoreleasepool {
            
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.coordinate = CLLocationCoordinate2DMake([college.appleLattitude doubleValue], [college.appleLongitude doubleValue]);
            point.title = college.collegeName;
            point.subtitle = college.place;
            [mapView addAnnotation:point];
        }
    }
}

/// MKMapview delegates
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if(([view.annotation coordinate].latitude != currentCollegeCoordinate.latitude) && ([view.annotation coordinate].longitude != currentCollegeCoordinate.longitude)) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCollegeView:)];
        [view addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        [view removeGestureRecognizer:recognizer];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString* annotationIdentifier = @"Annotation";
    
    if(([annotation coordinate].latitude == currentCollegeCoordinate.latitude) && ([annotation coordinate].longitude == currentCollegeCoordinate.longitude)) {
        annotationIdentifier = self.currentLocationIdentifier;
    } else {
        annotationIdentifier = self.defaultLocationIdentifier;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView) {
        
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        
        if(([annotation coordinate].latitude != currentCollegeCoordinate.latitude) && ([annotation coordinate].longitude != currentCollegeCoordinate.longitude)) {
           
            UIButton *rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightArrow setFrame:CGRectMake(0,0,10,15)];
            [rightArrow setBackgroundImage:[UIImage imageNamed:@"disclosure_icon"] forState:UIControlStateNormal];
            
            customPinView.rightCalloutAccessoryView = rightArrow;
        }
        
        customPinView.canShowCallout = YES;
//        customPinView.pinColor = MKPinAnnotationColorRed;
        customPinView.pinTintColor = [UIColor redColor];
        
        return customPinView;
        
    } else {
        
//        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.pinTintColor = [UIColor redColor];
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void)showCollegeView:(UITapGestureRecognizer *)gesture {
    
    MKAnnotationView *annotationView = (MKAnnotationView *)gesture.view;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeName == %@ && place == %@", [annotationView.annotation title], [annotationView.annotation subtitle]];
    
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    if(college) {
        [self presentCollegeWithCollegeID:college.collegeID];
        
        MKMapView *mapView = (MKMapView *)[self.mapContainerView viewWithTag:2222];
        [mapView deselectAnnotation:annotationView.annotation animated:NO];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeName == %@ && place == %@", [view.annotation title], [view.annotation subtitle]];
    
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    if(college) {
        [self presentCollegeWithCollegeID:college.collegeID];
        [mapView deselectAnnotation:view.annotation animated:NO];
    }
    
}

- (void) presentCollegeWithCollegeID:(NSNumber *) collegeID {
    
//    STCollegeDetailViewController *detailViewController = [[STCollegeDetailViewController alloc] initWithNibName:@"STCollegeDetailViewController" bundle:nil];
    
    UIStoryboard *tabBarStoryBoard = [UIStoryboard storyboardWithName:@"TabBarMenu" bundle:nil];
    
    STCollegeDetailViewController *detailViewController = [tabBarStoryBoard instantiateViewControllerWithIdentifier:@"STCollegeDetailViewController"];
    
    detailViewController.collegeID = collegeID;
    detailViewController.isPresenting = YES;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    detailViewController.edgesForExtendedLayout = UIRectEdgeNone;
    [self presentViewController:navController animated:YES completion:nil];
}


- (IBAction)onGetDirectionClick:(id)sender {
    
    __weak STLocationViewController *weakSelf = self;
    
    NSMutableArray *mapAppsList = [[NSMutableArray alloc] init];
    
    NSDictionary *appDetails = @{@"appIcon":@"apple_map_icon", @"appName":@"Apple Maps", @"appType":@"1"};
    [mapAppsList addObject:appDetails];
    
    BOOL isGoogleMapsInstalled = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps://"]];
    
    if(isGoogleMapsInstalled) {
        NSDictionary *appDetails = @{@"appIcon":@"google_map_icon", @"appName":@"Google Maps", @"appType":@"2"};
        [mapAppsList addObject:appDetails];
    }
    
    NSInteger mapAppType = [[[[STUserManager sharedManager] getCurrentUserInDefaultContext] defaultMapAppType] integerValue];

    if(!isGoogleMapsInstalled && (mapAppType == eMapAppTypeGoogleMaps)) {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"CollegeHunch"
                                              message:@"Google maps not installed in this device, do you want to continue with apple maps?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        __weak STLocationViewController *weakSelf = self;
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [weakSelf openDirectionsMapsOfType:eMapAppTypeAppleMaps withDetails:nil shouldAlwaysOpen:YES];
        }];
        
        [alertController addAction:noAction];
        [alertController addAction:yesAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
       
        if(mapAppType == eMapAppTypeAlwaysAsk) {
            
            UIView *popupBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
            popupBackgroundView.tag = 2201;
            
            STGetDirectionPopupView *popupView = [[[NSBundle mainBundle] loadNibNamed:@"STGetDirectionPopupView" owner:self options:nil] firstObject];
            popupView.frame = CGRectMake(0, 0, (self.view.frame.size.width - 40.0), (201.0 + (mapAppsList.count * 60.0)));
            popupView.center = self.view.center;
            popupView.mapAppsList = mapAppsList;
            
            [popupBackgroundView addSubview:popupView];
            [self.navigationController.view addSubview:popupBackgroundView];
            
            popupBackgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f];
            
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
            
            popupView.completeActionBlock = ^(NSMutableDictionary * details) {
                
                NSInteger mapType = [[details objectForKey:@"kMapType"] integerValue];
                BOOL shouldAlwaysOpen = [[details objectForKey:@"kShouldAlwaysOpen"] boolValue];
                
                if(mapType == 1) {
                    [weakSelf openDirectionsMapsOfType:eMapAppTypeAppleMaps withDetails:details shouldAlwaysOpen:shouldAlwaysOpen];
                } else if (mapType == 2) {
                    [weakSelf openDirectionsMapsOfType:eMapAppTypeGoogleMaps withDetails:details shouldAlwaysOpen:shouldAlwaysOpen];
                }
            };
            
            popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                popupView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                
            }];
        }
        else {
            
            [self openDirectionsMapsOfType:mapAppType withDetails:nil shouldAlwaysOpen:YES];
        }
    }
}

- (void) openDirectionsMapsOfType:(NSInteger) mapType withDetails:(NSDictionary *) details shouldAlwaysOpen:(BOOL) shouldAlwaysOpen {
    
    NSPredicate *collegeIDPredicate = [NSPredicate predicateWithFormat:@"collegeID == %@", self.collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:collegeIDPredicate];
    
    if(mapType == eMapAppTypeAppleMaps) {
        
        STLog(@"apple maps");
        
        double destinationLat = [college.appleLattitude doubleValue];
        double destinationLong = [college.appleLongitude doubleValue];
        
        CLLocationCoordinate2D destinationCoordinate = CLLocationCoordinate2DMake(destinationLat, destinationLong);
        
        NSDictionary *addressDict = @{
                                      (NSString *) CNPostalAddressStreetKey : college.collegeName
                                      };
        
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoordinate addressDictionary:addressDict];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        [mapItem openInMapsWithLaunchOptions:options];
        
    }
    else if (mapType == eMapAppTypeGoogleMaps) {
        
        CLLocation *currentLocation = [[STLocationManager sharedManager] currentLocation];
        
        double sourceLat = currentLocation.coordinate.latitude;
        double sourceLong = currentLocation.coordinate.longitude;
        
        double destinationLat = [college.googleLattitude doubleValue];
        double destinationLong = [college.googleLongitude doubleValue];
        
        NSString *url = [NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f",sourceLat, sourceLong, destinationLat, destinationLong];
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
    
    if(shouldAlwaysOpen) {
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
            localUser.defaultMapAppType = [NSNumber numberWithInteger:mapType];
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    [self releaseMaps];

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self releaseMaps];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {

    STLog(@"dealloc");
    [self releaseMaps];
    self.locationDetails = nil;
}

- (void) releaseMaps {
    
    MKMapView *mapView = (MKMapView *)[self.mapContainerView viewWithTag:2222];
    
    [mapView removeAnnotations:[mapView annotations]];
    mapView.mapType = MKMapTypeStandard;
    mapView.showsUserLocation = NO;
    mapView.delegate = nil;
    [mapView removeFromSuperview];
    mapView = nil;
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}

@end
