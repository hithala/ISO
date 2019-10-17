//
//  STWeatherSegmentControl.h
//  Stipend
//
//  Created by Arun S on 26/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STWeatherSegmentControlDelegate <NSObject>
@required
- (void)didClickSegmentAtIndex:(NSUInteger)index;

@optional

@end

@interface STWeatherSegmentControl : UIView

@property (nonatomic,retain) NSArray                                            *items;
@property (nonatomic,assign) NSInteger                                        fontMode;
@property (nonatomic,assign) NSUInteger                                  selectedIndex;
@property (nonatomic,assign) id<STWeatherSegmentControlDelegate>              delegate;

- (void) updateSegmentControlWithItems:(NSArray *) itemArray;

@end

