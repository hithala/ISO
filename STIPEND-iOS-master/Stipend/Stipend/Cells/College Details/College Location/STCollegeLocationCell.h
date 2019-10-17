//
//  STCollegeLocationCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface STCollegeLocationCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView                        *snapShotImage;

@property (nonatomic, assign) BOOL                                             isShown;

@property (nonatomic, assign) double                                         lattitude;
@property (nonatomic, assign) double                                         longitude;


@property (weak, nonatomic) IBOutlet UIImageView                     *overlayImageView;

@property (nonatomic,retain) UITapGestureRecognizer                        *tapGesture;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorHeightConstraint;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView    *activityIndicatorView;

@property (nonatomic, copy) void (^mapClickAction)(void);

- (void)updateMapWithLatitude:(double)latitude andLongitude:(double)longitude;

@end
