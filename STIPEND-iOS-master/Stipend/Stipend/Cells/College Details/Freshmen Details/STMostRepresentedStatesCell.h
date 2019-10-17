//
//  STMostRepresentedStatesCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 08/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMostRepresentedStatesCell : UITableViewCell

@property (nonatomic,retain) NSOrderedSet *mostRepresentedStatesSet;

- (void) updateWithDetails:(NSOrderedSet *) mostRepOrderedSet;

@end
