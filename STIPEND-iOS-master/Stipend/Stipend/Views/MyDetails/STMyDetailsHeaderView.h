//
//  STMyDetailsHeaderView.h
//  Stipend
//
//  Created by Mahesh A on 21/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMyDetailsHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel            *ibLabelField;
@property (weak, nonatomic) IBOutlet UILabel            *ibLabelValue;

@property (nonatomic, strong) void (^headerViewButtonActionBlock)(void);

- (IBAction)headerViewButtonAction:(id)sender;

@end
