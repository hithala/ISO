//
//  STCollegeSegmentControl.h
//  Stipend
//
//  Created by Arun S on 29/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STSegmentControlDelegate <NSObject>
@required
- (void)didClickSegmentAtIndex:(NSUInteger)index;

@optional

@end

@interface STCollegeSegmentControl : UIView

@property (nonatomic,retain) NSArray                                     *items;
@property (nonatomic,assign) NSInteger                                 fontMode;
@property (nonatomic,assign) NSUInteger                           selectedIndex;
@property (nonatomic,assign) id<STSegmentControlDelegate>              delegate;

- (void) updateSegmentControlWithItems:(NSArray *) itemArray;

@end
