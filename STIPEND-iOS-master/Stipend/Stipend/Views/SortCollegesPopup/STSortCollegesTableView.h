//
//  STSortCollegesTableView.h
//  Stipend
//
//  Created by sourcebits on 06/01/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSortCollegesTableView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,retain) NSMutableArray     *sortTypesDataSource;

@property (nonatomic, copy) void (^cancelActionBlock)(void);
@property (nonatomic, copy) void (^completeActionBlock)(SortType sortType);

@property (weak, nonatomic) IBOutlet UITableView  *popUpTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSeparatorHeightConstraint;

- (IBAction)closePopup:(id)sender;

- (void)configureView;

@end
