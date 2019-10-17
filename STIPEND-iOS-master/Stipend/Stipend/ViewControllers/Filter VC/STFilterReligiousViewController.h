//
//  STFilterReligiousViewController.h
//  Stipend
//
//  Created by Ganesh kumar on 02/07/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFilterReligiousViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray            *selectedReligiousList;
@property (nonatomic,retain) NSManagedObjectContext              *localContext;

@end
