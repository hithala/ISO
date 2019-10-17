//
//  STGetDirectionPopupView.h
//  Stipend
//
//  Created by Ganesh Kumar on 21/05/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STGetDirectionPopupView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) void (^cancelActionBlock)(void);
@property (nonatomic, copy) void (^completeActionBlock)(NSMutableDictionary *details);

@property (strong, nonatomic) NSArray                   *mapAppsList;

@property (weak, nonatomic) IBOutlet UITableView  *mapPopUpTableView;
@property (weak, nonatomic) IBOutlet UIButton      *appSelectionTick;

- (IBAction)closePopup:(id)sender;
- (IBAction)appSelectionTickBtn:(id)sender;



@end
