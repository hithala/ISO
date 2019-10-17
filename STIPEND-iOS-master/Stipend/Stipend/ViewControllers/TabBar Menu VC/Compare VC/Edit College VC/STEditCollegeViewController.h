//
//  STEditCollegeViewController.h
//  Stipend
//
//  Created by Arun S on 08/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STEditCollegeViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITableView             *tableView;
@property (weak, nonatomic) IBOutlet UILabel         *descriptionLabel;

@property (nonatomic,retain) NSManagedObjectContext      *localContext;
@property (nonatomic,retain) NSMutableOrderedSet         *compareItems;

@property (nonatomic, retain) UIButton                   *rightBarButton;

@end
