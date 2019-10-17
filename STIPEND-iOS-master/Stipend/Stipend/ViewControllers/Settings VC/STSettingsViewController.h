//
//  STSettingsViewController.h
//  Stipend
//
//  Created by Mahesh A on 07/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "STHelpViewController.h"
#import "STMyDetailsViewController.h"
#import "STPrivayPolicyViewController.h"
#import "STTermsAndConditionsViewController.h"
#import "STAboutStipendViewController.h"
#import "STCollegePageReorderViewController.h"
#import "STDataDefinitionsViewController.h"

@protocol SettingsViewControllerDelegate <NSObject>

@optional
- (void)showMenu;
- (void)capturedImage:(UIImage *)image;

@end

@interface STSettingsViewController : UITableViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,retain) NSMutableArray *settingsDataSourceDictionary;
@property (nonatomic, assign) id<SettingsViewControllerDelegate>      delegate;
@property(nonatomic,assign) SortType                                  sortType;
@property(nonatomic,assign) MapAppType                              mapAppType;

@end
