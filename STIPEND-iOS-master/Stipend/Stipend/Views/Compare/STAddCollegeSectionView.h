//
//  STAddCollegeSectionView.h
//  Stipend
//
//  Created by Ganesh Kumar on 10/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAddCollegeSectionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (copy, nonatomic) void(^selectAllAction)(void);

- (IBAction)onSelectAllAction:(id)sender;

@end
