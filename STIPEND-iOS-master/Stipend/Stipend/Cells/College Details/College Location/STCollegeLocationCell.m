//
//  STCollegeLocationCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCollegeLocationCell.h"

@implementation STCollegeLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.isShown = NO;
    
    self.cellSeparatorHeightConstraint.constant = 0.5f;
    self.overlayImageView.clipsToBounds = YES;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapClicked:)];
    self.tapGesture.numberOfTapsRequired = 1;
    self.tapGesture.numberOfTouchesRequired = 1;
    [self.overlayImageView addGestureRecognizer:self.tapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)mapClicked:(UITapGestureRecognizer *)gesture {
    
    if(self.mapClickAction) {
        self.mapClickAction();
    }
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)layoutSubviews {
   
    [super layoutSubviews];
    
    [self.snapShotImage layoutIfNeeded];
    
    if(!self.isShown) {
        self.isShown = NO;
        [self updateView];
    }
}


- (void)updateMapWithLatitude:(double)latitude andLongitude:(double)longitude {

    self.lattitude = latitude;
    self.longitude = longitude;
    
}

- (void)updateView {

    //if(!self.snapShotImage.image) {
    
    @try {
        
        
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(self.lattitude, self.longitude);
        
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        options.region = MKCoordinateRegionMakeWithDistance(locationCoordinate, 100, 100);
        options.size = self.snapShotImage.frame.size;
        options.scale = [[UIScreen mainScreen] scale];
        
        [self.activityIndicatorView startAnimating];
        
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            if (error) {
                return;
            }
            
            MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
            
            UIImage *image = snapshot.image;
            UIGraphicsBeginImageContextWithOptions(self.snapShotImage.bounds.size, YES, image.scale);
            {
                [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
                
                CGRect rect = CGRectMake(0.0f, 0.0f, self.snapShotImage.bounds.size.width, self.snapShotImage.bounds.size.height);
                
                CGPoint point = [snapshot pointForCoordinate:locationCoordinate];
                if (CGRectContainsPoint(rect, point)) {
                    point.x = point.x + pin.centerOffset.x -
                    (pin.bounds.size.width / 2.0f);
                    point.y = point.y + pin.centerOffset.y -
                    (pin.bounds.size.height / 2.0f);
                    [pin.image drawAtPoint:point];
                }
                
                UIImage *compositeImage = UIGraphicsGetImageFromCurrentImageContext();
                
                self.snapShotImage.image = compositeImage;
                
                [self.activityIndicatorView stopAnimating];
                
            }
            UIGraphicsEndImageContext();
            
        }];
        
    }
    @catch (NSException *exception) {
        STLog(@"%@", exception);
    }
    
   // }
}


- (void)dealloc {
    
    [self.overlayImageView removeGestureRecognizer:self.tapGesture];
    self.mapClickAction = nil;
    self.snapShotImage.image = nil;
}

@end
