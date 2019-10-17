//
//  STCompareSectionsViewController.h
//  Stipend
//
//  Created by Arun S on 08/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCompareSectionsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView  *tableView;

@property (nonatomic,retain) NSMutableArray    *sectionArray;
@property (nonatomic,assign) NSInteger     selectedItemIndex;

@property (nonatomic, copy) void (^doneActionBlock)(NSInteger index);

@end
