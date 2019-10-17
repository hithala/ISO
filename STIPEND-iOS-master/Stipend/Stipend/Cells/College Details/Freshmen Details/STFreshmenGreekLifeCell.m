//
//  STFreshmenGreekLifeCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 11/02/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import "STFreshmenGreekLifeCell.h"
#import "STFreshmenDetailCellView.h"

#define FRESHMEN_BASE_TAG               3567
#define FRESHMEN_DETAILS_ROW_HEIGHT     60.0
#define FRESHMEN_TITLE_VIEW_HEIGHT      45.0

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"


@implementation STFreshmenGreekLifeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) updateFreshmenWithGreekLifeDetails:(NSOrderedSet *) detailsSet {
    
    self.freshmenGreekLifeDetails = detailsSet;
    [self updateFreshmenGreekLifeDetails];
    [self setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateFreshmenGreekLifeDetails];
}

- (void) updateFreshmenGreekLifeDetails {
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSInteger count = self.freshmenGreekLifeDetails.count;
    
    for(int i = 0; i < count ; i++) {
        
        STFreshmenDetailCellView *freshmenItemView = (STFreshmenDetailCellView *)[self viewWithTag:(FRESHMEN_BASE_TAG + i)];
        CGRect freshmenItemFrame = CGRectZero;
        
        if(!freshmenItemView) {
            freshmenItemView = [[NSBundle mainBundle] loadNibNamed:@"STFreshmenDetailCellView" owner:self options:nil][0];
            freshmenItemView.tag = (FRESHMEN_BASE_TAG + i);
            [self.contentView addSubview:freshmenItemView];
        }
        
        if((i % 2) == 0) {
            freshmenItemFrame.origin.x = 0.0;
            freshmenItemFrame.origin.y = FRESHMEN_TITLE_VIEW_HEIGHT;
            freshmenItemFrame.size.width = ([self bounds].size.width/2.0);
            freshmenItemFrame.size.height = FRESHMEN_DETAILS_ROW_HEIGHT;
        }
        else {
            freshmenItemFrame.origin.x = ([self bounds].size.width/2.0);
            freshmenItemFrame.origin.y = FRESHMEN_TITLE_VIEW_HEIGHT;
            freshmenItemFrame.size.width = ([self bounds].size.width/2.0);
            freshmenItemFrame.size.height = FRESHMEN_DETAILS_ROW_HEIGHT;
        }
        
        freshmenItemView.frame = freshmenItemFrame;
        
        STCFreshmanGreekLife * item = [self.freshmenGreekLifeDetails objectAtIndex:i];
        
        freshmenItemView.keyLabel.text = [item.name capitalizedString];
        freshmenItemView.keyValue.text = [NSString stringWithFormat:@"%@%%",item.value];
    }
}

- (void)dealloc {
    self.freshmenGreekLifeDetails = nil;
}


@end
