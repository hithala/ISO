//
//  STFreshmenDetailsCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 09/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFreshmenDetailsCell : UITableViewCell

@property (nonatomic,retain) NSOrderedSet      *freshmenDetails;

- (void) updateFreshmenWithDetails:(NSOrderedSet *) detailSet;

@end
