//
//  STSportsDetailsCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCollegeSegmentControl.h"
#import "STCSports.h"

@interface STSportsDetailsCell : UITableViewCell<STSegmentControlDelegate>

@property (nonatomic,strong) STCSports                             *sports;
@property (nonatomic,assign) NSUInteger                      selectedIndex;

@property (nonatomic, copy) void (^toggleAction)(void);

- (void) updateSportsSectionWithDetails:(STCSports *) sportsDetails;

@end
