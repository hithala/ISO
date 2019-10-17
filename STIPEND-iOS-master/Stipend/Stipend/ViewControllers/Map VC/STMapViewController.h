//
//  STMapViewController.h
//  Stipend
//
//  Created by Ganesh Kumar on 13/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapViewControllerDelegate <NSObject>

@optional
- (void)showMenu;
- (void)capturedImage:(UIImage *)image;

@end

@interface STMapViewController :UIViewController<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView                            *mapContainerView;
@property (weak, nonatomic) IBOutlet UITableView                  *searchResultTableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTableviewBottomConstraint;

@property (strong, nonatomic) UIBarButtonItem                             *leftbarButton;
@property (strong, nonatomic) UISearchBar                                   *mySearchBar;

@property (nonatomic,retain) NSMutableArray                                 *searchArray;

//@property (nonatomic, assign) BOOL                                         isPlaceSearch;
@property (nonatomic,assign) BOOL                                     showRecentSearches;
@property (nonatomic, assign) id<MapViewControllerDelegate>                     delegate;

- (void) updateSearchResultTableHeaderView;

@end