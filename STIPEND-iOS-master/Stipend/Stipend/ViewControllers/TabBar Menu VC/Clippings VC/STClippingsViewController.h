//
//  STClippingsViewController.h
//  Stipend
//
//  Created by Ganesh Kumar on 13/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol ClippingsViewControllerDelegate <NSObject>

@optional
- (void)showMenu;
- (void)capturedImage:(UIImage *)image;

@end

@interface STClippingsViewController : UIViewController<MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView                *tableView;
@property (nonatomic, weak) IBOutlet UIView                     *emptyView;

@property (nonatomic,retain) NSMutableArray           *clippingsDataSource;
@property (nonatomic,retain) NSMutableArray               *clippedColleges;

@property (nonatomic, assign) id<ClippingsViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL                              isSelected;


@end
