//
//  STCollegeLocationCell.m
//  StipendTesting
//
//  Created by Ganesh Kumar on 11/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STCollegeLocationCell.h"

@implementation STCollegeLocationCell

- (void)awakeFromNib {
    // Initialization code
    
    self.locationMapView.scrollEnabled = NO;
    self.locationMapView.zoomEnabled = NO;
    //self.locationMapView.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapClicked:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.locationMapView addGestureRecognizer:tapGesture];
    
}

- (void)mapClicked:(UITapGestureRecognizer *)gesture {
    
    self.mapClickAction();
}

- (void)layoutSubviews {
    
    [self.locationMapView setRegion:[self.locationMapView regionThatFits:self.region] animated:YES];
}

- (void)updateMapWithLatitude:(double)latitude andLongitude:(double)longitude andPlaceName:(NSString *)placeName {
    
    double locationLatitude = latitude;
    double locationLongitude = longitude;
    
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(locationLatitude, locationLongitude);
    
    self.region = MKCoordinateRegionMakeWithDistance(locationCoordinate, self.frame.size.width, self.frame.size.height);
    
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = locationCoordinate;
    point.title = placeName;
    [self.locationMapView addAnnotation:point];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!pinView) {
        
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        customPinView.image = [UIImage imageNamed:@"myCurrentLocation.png"];
        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        return customPinView;
        
    } else {
        
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
