//
//  STMostRepresentedStatesCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 08/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STMostRepresentedStatesCell.h"
#import "STMostRepresentedStateView.h"
#import "STCFreshmanRepresentedStates.h"

#define MOST_REP_STATE_TAG      1739


@implementation STMostRepresentedStatesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) updateWithDetails:(NSOrderedSet *) mostRepOrderedSet {
    
    self.mostRepresentedStatesSet = mostRepOrderedSet;
    [self updateStateDetails];
}

- (void) updateStateDetails {
    
    for (NSInteger i = 0 ; i < [self.mostRepresentedStatesSet count]; i++) {
        
        CGFloat stateCellWidth = (self.frame.size.width - 10.0)/5.0;
        
        CGRect stateViewRect = CGRectZero;
        stateViewRect.origin.y += 20.0;
        stateViewRect.origin.x += 5.0 + (i * stateCellWidth);
        stateViewRect.size.width = stateCellWidth;
        stateViewRect.size.height = 100.0;
        
        STMostRepresentedStateView *mostRepStateView = (STMostRepresentedStateView *)[self.contentView viewWithTag:(MOST_REP_STATE_TAG + i)];

        if(!mostRepStateView) {
            mostRepStateView = [[NSBundle mainBundle] loadNibNamed:@"STMostRepresentedStateView" owner:self options:nil][0];
            mostRepStateView.tag = (MOST_REP_STATE_TAG + i);
            [self.contentView addSubview:mostRepStateView];
        }

        STCFreshmanRepresentedStates *mostRepState = [self.mostRepresentedStatesSet objectAtIndex:i];

        mostRepStateView.nameLabel.text = mostRepState.name;
                
        mostRepStateView.stateImageView.image = [UIImage imageNamed:[mostRepState.name lowercaseString]];

        mostRepStateView.frame = stateViewRect;
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateStateDetails];
}

- (void)dealloc {
}

@end
