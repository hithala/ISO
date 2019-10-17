//
//  STMyDetailsViewController.h
//  Stipend
//
//  Created by Mahesh A on 12/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STUser.h"

typedef enum {
    kEditMode,
    kViewMode
}ProfileSelectionMode;

@interface STMyDetailsViewController : UITableViewController

@property (nonatomic, strong) NSMutableDictionary *profileDataSourceDictionary;

@property (nonatomic,retain) UITapGestureRecognizer                *tapGesture;
@property (nonatomic, assign) ProfileSelectionMode               selectionMode;

@end
