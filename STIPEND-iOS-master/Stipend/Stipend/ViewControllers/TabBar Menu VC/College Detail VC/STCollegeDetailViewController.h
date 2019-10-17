//
//  STCollegeDetailViewController.h
//  Stipend
//
//  Created by Arun S on 10/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "STCollegesListViewController.h"

@class STClippingsDragNDropView;

@interface STCollegeDetailViewController : UIViewController<MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView              *mainTableView;

@property (nonatomic, strong) NSDictionary                   *collegeDetails;
@property (nonatomic, strong) STCollege                             *college;
@property (nonatomic, retain) NSNumber                            *collegeID;
@property (nonatomic, retain) NSMutableArray                *collegeSections;

@property (nonatomic,assign) NSInteger                                 index;
@property (nonatomic,assign) CGFloat                       tableHeaderHeight;

@property (nonatomic,assign) BOOL                               isPresenting;
@property (nonatomic,assign) CGPoint                            scrollOffset;

@property (nonatomic,retain) NSMutableArray          *presentedCollegesStack;

@property (nonatomic, weak) IBOutlet UIView                *networkErrorView;

@property (copy, nonatomic) void(^mapClickedAction)(NSDictionary *locationDetails, NSNumber *collegeID);
@property (copy, nonatomic) void(^similarSchoolAction)(NSNumber *collegeID);
@property (copy, nonatomic) void(^updateNavigationBarWithCollegeDetails)(NSNumber *collegeID);
@property (copy, nonatomic) void(^sortActionBlock)(void);
@property (copy, nonatomic) void(^privacyPopupActionBlock)(void);

- (IBAction)onReloadAction:(id)sender;

- (void) resetValues;
- (void) initializeValues;

@end
