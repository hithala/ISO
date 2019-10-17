//
//  STLocationViewController.h
//  Stipend
//
//  Created by Ganesh Kumar on 11/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface STLocationViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) NSDictionary       *locationDetails;
@property (nonatomic, strong) NSNumber                 *collegeID;

@property (weak, nonatomic) IBOutlet UIView     *mapContainerView;

@property (assign, nonatomic) NSInteger        selectedSegmentIndex;

@property (weak, nonatomic) IBOutlet UIButton *getDirectionButton;


- (IBAction)changeMapTypeWithSegmentControl:(UISegmentedControl*)segmentController;
- (IBAction)onGetDirectionClick:(id)sender;

- (void) openDirectionsMapsOfType:(NSInteger) mapType withDetails:(NSDictionary *) details shouldAlwaysOpen:(BOOL) shouldAlwaysOpen;

@end
