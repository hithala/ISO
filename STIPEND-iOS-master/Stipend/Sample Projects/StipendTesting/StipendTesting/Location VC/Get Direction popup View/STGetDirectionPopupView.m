//
//  STGetDirectionPopupView.m
//  StipendTesting
//
//  Created by Ganesh Kumar on 21/05/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STGetDirectionPopupView.h"
#import "STMapAppCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface STGetDirectionPopupView ()

@end

@implementation STGetDirectionPopupView
@synthesize cancelActionBlock;
@synthesize mapAppsList;


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


- (IBAction)appSelectionTickBtn:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if(button.tag == 0) {
        button.tag = 1;
        [button setImage:[UIImage imageNamed:@"tickMark_selected.jpg"] forState:UIControlStateNormal];
    } else {
        button.tag = 0;
        [button setImage:[UIImage imageNamed:@"tickMark_unselected.jpg"] forState:UIControlStateNormal];
    }
}


- (IBAction)closePopup:(id)sender {
   self.cancelActionBlock();
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mapAppsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"mapAppCell";
    
    STMapAppCell *cell = (STMapAppCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = (STMapAppCell *)[[NSBundle mainBundle] loadNibNamed:@"STMapAppCell" owner:self options:nil][0];
    }
    
    NSDictionary *appDict= [mapAppsList objectAtIndex:indexPath.row];
    cell.appName.text = [appDict objectForKey:@"appName"];
    cell.appIcon.image = [UIImage imageNamed:[appDict objectForKey:@"appIcon"]];
    cell.appIcon.backgroundColor = [UIColor lightGrayColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *appDict= [mapAppsList objectAtIndex:indexPath.row];
    int appType = [[appDict objectForKey:@"appType"] intValue];
    
    if(appType == 1) {
        NSLog(@"apple maps");
        
        double destinationLat = [[self.latLongDict objectForKey:@"destinationLat"] doubleValue];
        double destinationLong = [[self.latLongDict objectForKey:@"destinationLong"] doubleValue];
        
        CLLocationCoordinate2D destinationCoordinate = CLLocationCoordinate2DMake(destinationLat, destinationLong);
        
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        //[mapItem setName:@"WhereIWantToGo"];
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        [mapItem openInMapsWithLaunchOptions:options];
        
    } else if (appType == 2) {

        NSString *url = [NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f",[[self.latLongDict objectForKey:@"sourceLat"] doubleValue], [[self.latLongDict objectForKey:@"sourceLong"] doubleValue], [[self.latLongDict objectForKey:@"destinationLat"] doubleValue], [[self.latLongDict objectForKey:@"destinationLong"] doubleValue]];
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        
        
    } else if (appType == 3) {
        NSLog(@"waze maps");
    }
    
    self.cancelActionBlock();
}



@end
