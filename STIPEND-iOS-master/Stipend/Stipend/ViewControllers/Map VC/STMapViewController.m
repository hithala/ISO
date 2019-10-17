//
//  STMapViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 13/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STMapViewController.h"
#import "STLocationSearchItem.h"
#import "STLocationManager.h"

#define LATITUDE                        @"latitude"
#define LONGITUDE                       @"longitude"
#define DESCRIPTION                     @"description"

#define SEARCH_ROW_HEIGHT               60.0
#define RECENT_SEARCH_ROW_HEIGHT        50.0

#define TAB_BAR_HEIGHT                  self.tabBarController.tabBar.frame.size.height;

#define MAX_RECENT_SEARCH_COUNT         10
#define MAX_NEARBY_DISTANCE             500000

#define MAP_VIEW_TAG                    1111

@interface STMapViewController ()

@property (nonatomic, retain) NSString *currentLocationIdentifier;
@property (nonatomic, retain) NSString *defaultLocationIdentifier;
@property (nonatomic, retain) NSString *searchBarPlaceholderText;

@property (strong, nonatomic) STCollege         *selectedCollege;
@property (nonatomic, assign) MapSearchType        mapSearchType;


@end

@implementation STMapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.currentLocationIdentifier = @"mapCurrentLocation";
    self.defaultLocationIdentifier = @"mapDefaultLocation";
    
    self.selectedCollege = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIButton *customLeftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeftBarButton.frame = CGRectMake(0, 0, 25, 25);
    [customLeftBarButton setImage:[UIImage imageNamed:@"browser_back"] forState:UIControlStateNormal];
    [customLeftBarButton addTarget:self action:@selector(onLeftBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftbarButton = [[UIBarButtonItem alloc] initWithCustomView:customLeftBarButton];
    
    self.navigationItem.leftBarButtonItem = self.leftbarButton;
    
    self.searchResultTableview.hidden = YES;
    
    self.mySearchBar = [[UISearchBar alloc] init];
    
    self.searchBarPlaceholderText = @"College, City, State Abbreviation";
    
    self.mySearchBar.placeholder = self.searchBarPlaceholderText;
    self.mySearchBar.delegate = self;
    self.mySearchBar.tintColor = [UIColor cursorColor];
    self.mySearchBar.keyboardType = UIKeyboardTypeASCIICapable;
    self.navigationItem.titleView = self.mySearchBar;
    
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    MKMapView *mapView = (MKMapView *)[self.mapContainerView viewWithTag:MAP_VIEW_TAG];
    
    if(mapView) {
        CGRect mapFrame = self.mapContainerView.bounds;
        mapView.frame = mapFrame;
    }
}

- (void) viewWillAppear:(BOOL)animated {
 
    [super viewWillAppear:animated];
        
    STAppDelegate *appDelegate = (STAppDelegate *)[[UIApplication sharedApplication] delegate];
    MKMapView *mapView = [appDelegate mapView];
    [mapView setMapType:MKMapTypeStandard];
    [mapView removeAnnotations:[mapView annotations]];
    mapView.delegate = self;
    mapView.frame = self.mapContainerView.bounds;
    mapView.tag = MAP_VIEW_TAG;
    [self.mapContainerView addSubview:mapView];
    
    if(self.mapSearchType == eSearchTypeName) {
        
        [self populateSelectedCollege:self.selectedCollege];
        
    } else {
        
        if(self.selectedCollege) {
            
            [self populateNearByColleges:self.selectedCollege];
        } else {
            
            BOOL hasLocationAccess = [[STLocationManager sharedManager] hasAccessToLocationServices];
            
            if(hasLocationAccess) {
                
                CLLocation *currentLocation = [[STLocationManager sharedManager] currentLocation];
                
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 800, 800);
                [mapView setRegion:[mapView regionThatFits:region] animated:YES];
                
                MKPointAnnotation *currentLocationPoint = [[MKPointAnnotation alloc] init];
                currentLocationPoint.coordinate = currentLocation.coordinate;
                currentLocationPoint.title = @"Current Location";
                [mapView addAnnotation:currentLocationPoint];
                
            } else {
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"CollegeHunch"
                                                      message:@"Please grant access to location services from device settings."
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
        }
    }
}

- (void)onLeftBarButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark KEYBORAD NOTIFICATIONS

- (void)keyboardDidShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.searchTableviewBottomConstraint.constant = kbSize.height - TAB_BAR_HEIGHT;
    [self.searchResultTableview setNeedsUpdateConstraints];
    [self.searchResultTableview layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.searchTableviewBottomConstraint.constant = 0.0;
    [self.searchResultTableview setNeedsUpdateConstraints];
    [self.searchResultTableview layoutIfNeeded];
}

#pragma mark SEARCH BAR DELEGATES

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if(self.searchArray.count > 0) {
        
        if(self.mapSearchType == eSearchTypeName) {
            
            NSString *collegeName = [[self.searchArray objectAtIndex:0] objectForKey:@"collegeName"];
            
            STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeName == %@", collegeName]];
            
            [self addItemToRecentSearchItem:collegeName forCollegeID:college.collegeID];
            
            [self populateSelectedCollege:college];
            
        } else {
           
            NSString *placeName = [[self.searchArray objectAtIndex:0] objectForKey:@"place"];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"place == %@", placeName];
            
            STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
            
            [self addItemToRecentSearchItem:placeName forCollegeID:college.collegeID];
            
            [self populateNearByColleges:college];
        }
        
        [searchBar resignFirstResponder];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self initializeRecentSearch];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self resetSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(searchBar.text.length == 0) {
        [self initializeRecentSearch];
    }
    else {
        NSString *searchText = searchBar.text;
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"place CONTAINS[cd] %@ OR zipCode CONTAINS[cd] %@ OR collegeName CONTAINS[c] %@", searchText, searchText, searchText];
        
        NSFetchRequest *fetchRequest;
        fetchRequest = [STCollege MR_requestAllSortedBy:@"collegeID" ascending:YES];
        [fetchRequest setResultType: NSDictionaryResultType];
        [fetchRequest setReturnsDistinctResults:YES];
//        [fetchRequest setPredicate:predicate];

        
        BOOL valid = false;
        
        // Omitting entirely search by Zip Code
        
//        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
//        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self.mySearchBar.text];
//        
//        valid = [alphaNums isSupersetOfSet:inStringSet];
//        
        if (!valid) {
            
            NSString *placePredicateString = [NSString stringWithFormat:@"place CONTAINS[c] \"%@\"", searchText];
            NSString *namePredicateString = [NSString stringWithFormat:@"collegeName CONTAINS[c] \"%@\"", searchText];
            
            STUser *localUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
            
            if ([localUser.isAdmin boolValue] == NO) {
                placePredicateString = [NSString stringWithFormat:@"%@ AND isActive ==%@", placePredicateString, [NSNumber numberWithBool:YES]];
                namePredicateString = [NSString stringWithFormat:@"%@ AND isActive ==%@", namePredicateString, [NSNumber numberWithBool:YES]];
            }
            
            
            NSArray *collegeArray = [STCollege MR_findAllWithPredicate:[NSPredicate predicateWithFormat:placePredicateString]];
            
            if(collegeArray.count > 0) {
                [fetchRequest setPropertiesToFetch:@[@"place"]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:placePredicateString];
                [fetchRequest setPredicate:predicate];
                self.mapSearchType = eSearchTypePlace;
            } else {
                [fetchRequest setPropertiesToFetch:@[@"collegeName"]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:namePredicateString];
                [fetchRequest setPredicate:predicate];
                self.mapSearchType = eSearchTypeName;
            }
//            self.isPlaceSearch = YES;
        }
        else {
//            self.isPlaceSearch = NO;
            NSString *zipCodePredicateString = [NSString stringWithFormat:@"zipCode CONTAINS[c] \"%@\"", searchBar.text];
            
            STUser *localUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
            
            if ([localUser.isAdmin boolValue] == NO) {
                zipCodePredicateString = [NSString stringWithFormat:@"%@ AND isActive ==%@", zipCodePredicateString, [NSNumber numberWithBool:YES]];
            }

            
           [fetchRequest setPropertiesToFetch:@[@"zipCode"]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:zipCodePredicateString];
            [fetchRequest setPredicate:predicate];
            self.mapSearchType = eSearchTypeZIP;
        }

        
        NSArray *collegeArray = [STCollege MR_executeFetchRequest:fetchRequest];
        
        
        self.searchArray = [NSMutableArray arrayWithArray:collegeArray];
        
        [self toggleSearch:NO];
        
        if([self.searchArray count] == 0) {
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
            messageLabel.text = @"No Results";
            messageLabel.textColor = [UIColor lightGrayColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:25];
            [messageLabel sizeToFit];
            
            self.searchResultTableview.backgroundView = messageLabel;
        }
        else {
            self.searchResultTableview.backgroundView = nil;
        }
    }
}

- (void) updateSearchResultTableHeaderView {
    
    UIView *tableHeaderView = [self.view viewWithTag:1125];
    
    if(!tableHeaderView) {
        
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.searchResultTableview.bounds.size.width, 50.0)];
        tableHeaderView.tag = 1125;
        tableHeaderView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 15.0, self.searchResultTableview.bounds.size.width - 30.0, 25.0)];
        titleLabel.tag = 1126;
        titleLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:14.0];
        titleLabel.text = @"RECENT SEARCHES";
        titleLabel.textColor = [UIColor cellLabelTextColor];
        
        [tableHeaderView addSubview:titleLabel];
        
        self.searchResultTableview.tableHeaderView = tableHeaderView;
    }
}

- (void) initializeRecentSearch {
    
//    self.navigationItem.leftBarButtonItem = nil;
    [self.mySearchBar setShowsCancelButton:YES animated:YES];
    self.mySearchBar.placeholder = @"Search";

    [self updateSearchResultTableHeaderView];

    self.searchResultTableview.backgroundColor = [UIColor whiteColor];
    self.searchResultTableview.hidden = NO;
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSMutableOrderedSet *recentSearchSet = [NSMutableOrderedSet orderedSetWithOrderedSet:currentUser.locationSearch];
    self.searchArray = [NSMutableArray arrayWithArray:[[recentSearchSet reversedOrderedSet] array]];

    [self toggleSearch:YES];
}

- (void) toggleSearch:(BOOL) showRecentSearch {
    
    if(showRecentSearch) {
        self.showRecentSearches = YES;
        
        UIView *headerView = self.searchResultTableview.tableHeaderView;
        UILabel *titleLabel = (UILabel *)[headerView viewWithTag:1126];
        [titleLabel setText:@"RECENT SEARCHES"];
        [self.searchResultTableview reloadData];
    }
    else {
        self.showRecentSearches = NO;
        
        UIView *headerView = self.searchResultTableview.tableHeaderView;
        UILabel *titleLabel = (UILabel *)[headerView viewWithTag:1126];
        [titleLabel setText:@"SEARCH RESULTS"];
        
        [self.searchResultTableview reloadData];
    }
}

- (void) resetSearch {
    
    [self.searchArray removeAllObjects];
    [self.searchResultTableview reloadData];

    self.navigationItem.leftBarButtonItem = self.leftbarButton;
    [self.mySearchBar setShowsCancelButton:NO animated:YES];
    self.searchResultTableview.hidden = YES;

    self.mySearchBar.text = @"";
    self.mySearchBar.placeholder = self.searchBarPlaceholderText;
    
//    if([UIScreen mainScreen].bounds.size.width >= 375) {
//        self.mySearchBar.placeholder = @"Search By Town, State or ZIP Code";
//    } else {
//        self.mySearchBar.placeholder = @"Search By Town, State or ZIP..";
//    }
}

#pragma mark SEARCH TABLE VIEW DATASOURCE

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.showRecentSearches) {
        return RECENT_SEARCH_ROW_HEIGHT;
    }
    else {
        return SEARCH_ROW_HEIGHT;
    }
    
    return SEARCH_ROW_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0f];
    cell.textLabel.textColor = [UIColor cellTextFieldTextColor];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    if(!self.showRecentSearches) {
        
//        if (self.isPlaceSearch) {
//            NSString *placeName = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"place"];
//            [cell.textLabel setText:placeName];
//        }
//        else {
//            NSString *zipCode = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"zipCode"];
//            [cell.textLabel setText:zipCode];
//        }
        
        NSString *titleString;
        
        switch (self.mapSearchType) {
            case eSearchTypeName:
                titleString = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"collegeName"];
                break;
            case eSearchTypePlace:
                titleString = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"place"];
                break;
            case eSearchTypeZIP:
                titleString = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"zipCode"];
                break;
                
            default:
                break;
        }
        
        [cell.textLabel setText:titleString];
    }
    else {
        
        STLocationSearchItem *recentSearchItem = [self.searchArray objectAtIndex:indexPath.row];
        [cell.textLabel setText:recentSearchItem.collegeLocation];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(!self.showRecentSearches) {
        
        NSString *location = nil;
        STCollege *college;
        
//        if (self.isPlaceSearch) {
//            NSString *placeName = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"place"];
//            location = placeName;
//            college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"place == %@", placeName]];
//        }
//        else {
//            NSString *zipCode = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"zipCode"];
//            location = zipCode;
//            college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"zipCode == %@", zipCode]];
//        }
        
        switch (self.mapSearchType) {
            case eSearchTypeName: {
                NSString *collegeName = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"collegeName"];
                location = collegeName;
                college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeName == %@", collegeName]];
            }
                break;
            case eSearchTypePlace:{
                NSString *placeName = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"place"];
                location = placeName;
                college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"place == %@", placeName]];
            }
                break;
            case eSearchTypeZIP:{
                NSString *zipCode = [[self.searchArray objectAtIndex:indexPath.row] objectForKey:@"zipCode"];
                location = zipCode;
                college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"zipCode == %@", zipCode]];
            }
                break;
                
            default:
                break;
        }
        
        if(self.mapSearchType == eSearchTypeName) {
            
            [self addItemToRecentSearchItem:location forCollegeID:college.collegeID];
            
            [self populateSelectedCollege:college];
            
        } else {
         
            [self addItemToRecentSearchItem:location forCollegeID:college.collegeID];
            
            [self populateNearByColleges:college];
        }
    }
    else { // Recent Search Items Click
        
        STLocationSearchItem *item = [self.searchArray objectAtIndex:indexPath.row];

        STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", item.collegeID]];
        
        if([item.searchType integerValue] == eSearchTypeName) {
            
            [self populateSelectedCollege:college];
            self.mapSearchType = eSearchTypeName;
            
        } else {
            [self populateNearByColleges:college];
        }
    }
    
    [self.mySearchBar resignFirstResponder];
}


- (void) addItemToRecentSearchItem:(NSString *) location forCollegeID:(NSNumber *) collegeID {
    
    if(location) {
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
            
            STLocationSearchItem *searchItem = [STLocationSearchItem MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeLocation == %@",location]];
            NSMutableOrderedSet *recentSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[localUser locationSearch]];
            
            if(!searchItem) {
                searchItem = [STLocationSearchItem MR_createEntityInContext:localContext];
                searchItem.collegeLocation = location;
                searchItem.collegeID = collegeID;
                searchItem.searchType = [NSNumber numberWithInteger:self.mapSearchType];
                searchItem.user = localUser;
                [recentSet addObject:searchItem];
            }
            else
            {
                for (STLocationSearchItem *item in recentSet) {
                    if([collegeID isEqualToNumber:[item collegeID]]) {
                        [recentSet removeObject:item];
                        [searchItem MR_deleteEntityInContext:localContext];
                        break;
                    }
                }
                
                STLocationSearchItem *newSearchItem = [STLocationSearchItem MR_createEntityInContext:localContext];
                newSearchItem.collegeID = collegeID;
                newSearchItem.collegeLocation = location;
                newSearchItem.searchType = [NSNumber numberWithInteger:self.mapSearchType];
                newSearchItem.user = localUser;
                [recentSet addObject:newSearchItem];
            }
            
            if([recentSet count] > MAX_RECENT_SEARCH_COUNT) {
                STLocationSearchItem *lastItem = [recentSet objectAtIndex:0];
                [lastItem MR_deleteEntityInContext:localContext];
                [recentSet removeObjectAtIndex:0];
            }
            
            localUser.locationSearch = recentSet;
            
        } completion:^(BOOL success, NSError *error) {
            
        }];
    }
}

// Populating selected College on Map

- (void)populateSelectedCollege:(STCollege *)college {
    
    self.selectedCollege = college;
    
    MKMapView *mapView = (MKMapView *)[self.mapContainerView viewWithTag:MAP_VIEW_TAG];
    [mapView removeAnnotations:mapView.annotations];
    
    CLLocationCoordinate2D collegeCoordinate = CLLocationCoordinate2DMake([college.appleLattitude doubleValue], [college.appleLongitude doubleValue]);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(collegeCoordinate, 500, 500);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([college.appleLattitude doubleValue], [college.appleLongitude doubleValue]);
    point.title = college.collegeName;
    point.subtitle = college.place;
    [mapView addAnnotation:point];
}

// Getting Neary by colleges and populate them on Map

- (void)populateNearByColleges:(STCollege *)college {
    
    self.selectedCollege = college;
    
    MKMapView *mapView = (MKMapView *)[self.mapContainerView viewWithTag:MAP_VIEW_TAG];
    [mapView removeAnnotations:mapView.annotations];
    
    CLLocationCoordinate2D collegeCoordinate = CLLocationCoordinate2DMake([college.appleLattitude doubleValue], [college.appleLongitude doubleValue]);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(collegeCoordinate, MAX_NEARBY_DISTANCE, MAX_NEARBY_DISTANCE);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
    
    NSArray *collegesList = [STCollege MR_findAllSortedBy:@"collegeID" ascending:YES];
    
    CLLocationDistance maxRadius = MAX_NEARBY_DISTANCE; // in meters
    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:collegeCoordinate.latitude longitude:collegeCoordinate.longitude];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(STCollege *college, NSDictionary *bindings) {
        
        @autoreleasepool {
            
            double lattitude = [college.appleLattitude doubleValue];
            double longitude = [college.appleLongitude doubleValue];
            
            CLLocation *collegeLocation = [[CLLocation alloc] initWithLatitude:lattitude longitude:longitude];
            
            return ([collegeLocation distanceFromLocation:targetLocation] <= maxRadius);
        }
    }];
    
    NSArray *closeLocations = [collegesList filteredArrayUsingPredicate:predicate];
    
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

#pragma mark apple map delagate method

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [mapView setRegion:[mapView regionThatFits:region] animated:YES];
    [mapView setMapType:MKMapTypeStandard];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        [view removeGestureRecognizer:recognizer];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString* annotationIdentifier = @"Annotation";
   
    CLLocation *currentLocation = [[STLocationManager sharedManager] currentLocation];
    
    if ([annotation coordinate].latitude == currentLocation.coordinate.latitude && [annotation coordinate].longitude == currentLocation.coordinate.longitude){
        annotationIdentifier = self.currentLocationIdentifier;
    }
    else{
        annotationIdentifier = self.defaultLocationIdentifier;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView) {
        
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        
        if ([annotation coordinate].latitude == currentLocation.coordinate.latitude && [annotation coordinate].longitude == currentLocation.coordinate.longitude){
            
            customPinView.image = [UIImage imageNamed:@"myCurrentLocation.png"];
        }
        else{
            
            UIButton *rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightArrow setFrame:CGRectMake(0,0,10,15)];
            [rightArrow setBackgroundImage:[UIImage imageNamed:@"disclosure_icon"] forState:UIControlStateNormal];
            
            customPinView.rightCalloutAccessoryView = rightArrow;
        }

        customPinView.animatesDrop = NO;
        customPinView.canShowCallout = YES;
        return customPinView;
        
    } else {
        
        pinView.annotation = annotation;
    
    }

    
    return pinView;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    CLLocation *currentLocation = [[STLocationManager sharedManager] currentLocation];
    
    if(([view.annotation coordinate].latitude != currentLocation.coordinate.latitude) && ([view.annotation coordinate].longitude != currentLocation.coordinate.longitude)) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCollegeView:)];
        [view addGestureRecognizer:tapGestureRecognizer];
    }
}


- (void)showCollegeView:(UITapGestureRecognizer *)gesture {
    
    MKMapView *mapView = (MKMapView *)[self.mapContainerView viewWithTag:MAP_VIEW_TAG];

    MKAnnotationView *annotationView = (MKAnnotationView *)gesture.view;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeName == %@", [annotationView.annotation title]];
    
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    [self presentCollegeWithCollegeID:college.collegeID];
    
    [mapView deselectAnnotation:annotationView.annotation animated:NO];
    
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeName == %@", [view.annotation title]];
    
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    [self presentCollegeWithCollegeID:college.collegeID];
    
    [mapView deselectAnnotation:view.annotation animated:NO];
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

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self releaseMaps];
    
    [self.mySearchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self releaseMaps];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {

    STLog(@"Map dealloc");

    [self releaseMaps];

    self.searchArray = nil;
    self.mySearchBar = nil;
    self.leftbarButton = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void) releaseMaps {
    
    MKMapView *mapView = (MKMapView *)[self.mapContainerView viewWithTag:MAP_VIEW_TAG];
    
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

