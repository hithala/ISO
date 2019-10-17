//
//  STFreshmenGreekLifeCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 11/02/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFreshmenGreekLifeCell : UITableViewCell

@property (nonatomic,retain) NSOrderedSet      *freshmenGreekLifeDetails;

- (void) updateFreshmenWithGreekLifeDetails:(NSOrderedSet *) detailSet;

@end
