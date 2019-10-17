//
//  STFilterMajorHeaderView.h
//  Stipend
//
//  Created by Ganesh Kumar on 25/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFilterMajorHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UIButton *selectionView;
@property (nonatomic, weak) IBOutlet UIButton *backgroundButtonView;
@property (nonatomic, weak) IBOutlet UIImageView *disclosureImageView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *countLabelWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectionViewWidthConstraint;

- (IBAction)haderViewSelectionAction:(id)sender;
- (IBAction)selectionAction:(id)sender;

@property (nonatomic, copy) void (^headerViewClickActionBlock)(void);
@property (nonatomic, copy) void (^majorSelectionActionBlock)(void);

@end
