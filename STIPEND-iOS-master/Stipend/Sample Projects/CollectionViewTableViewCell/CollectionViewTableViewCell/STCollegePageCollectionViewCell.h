//
//  STCollegePageCollectionViewCell.h
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 26/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
@import EventKit;


#import "Constants.h"

@interface STCollegePageCollectionViewCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *ibTableView;
@property (strong, nonatomic) EKCalendar *calendar;
@property (nonatomic, assign) CollegePageSection collegePageSection;
@property (nonatomic) BOOL isAccessToEventStoreGranted;

@end
