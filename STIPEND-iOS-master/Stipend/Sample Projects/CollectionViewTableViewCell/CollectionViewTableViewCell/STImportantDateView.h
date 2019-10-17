//
//  STImportantDateView.h
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 23/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STImportantDateView : UIView

@property (nonatomic,weak) NSMutableDictionary *importantDatesViewDict;

@property (nonatomic, strong) void (^didDateAddedActionBlock)();

- (void)loadViews;
@end
