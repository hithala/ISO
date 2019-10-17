//
//  STCollegeLocationCell.h
//  StipendTesting
//
//  Created by Ganesh Kumar on 11/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface STCollegeLocationCell : UITableViewCell<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;

@property (assign, nonatomic) MKCoordinateRegion region;

@property (nonatomic, copy) void (^mapClickAction)();

- (void)updateMapWithLatitude:(double)latitude andLongitude:(double)longitude andPlaceName:(NSString *)placeName;

@end
