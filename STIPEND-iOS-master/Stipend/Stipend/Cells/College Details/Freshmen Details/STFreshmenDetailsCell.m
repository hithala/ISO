//
//  STFreshmenDetailsCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 09/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STFreshmenDetailsCell.h"
#import "STFreshmenDetailCellView.h"

#define FRESHMEN_BASE_TAG               3567
#define FRESHMEN_DETAILS_ROW_HEIGHT     60.0

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"

@implementation STFreshmenDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) updateFreshmenWithDetails:(NSOrderedSet *) detailsSet {
 
    self.freshmenDetails = detailsSet;
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self updateFreshmenDetails];
    [self setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateFreshmenDetails];
}

- (void) updateFreshmenDetails {
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSInteger count = self.freshmenDetails.count;
    
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
            freshmenItemFrame.origin.y = ((i/2) * FRESHMEN_DETAILS_ROW_HEIGHT);
            freshmenItemFrame.size.width = ([self bounds].size.width/2.0);
            freshmenItemFrame.size.height = FRESHMEN_DETAILS_ROW_HEIGHT;
        }
        else {
            freshmenItemFrame.origin.x = ([self bounds].size.width/2.0);
            freshmenItemFrame.origin.y = ((i/2) * FRESHMEN_DETAILS_ROW_HEIGHT);
            freshmenItemFrame.size.width = ([self bounds].size.width/2.0);
            freshmenItemFrame.size.height = FRESHMEN_DETAILS_ROW_HEIGHT;
        }
        
        freshmenItemView.frame = freshmenItemFrame;

        STCFreshmanDetailItem * item = [self.freshmenDetails objectAtIndex:i];
        
        NSString *key = [item.key capitalizedString];
        
        freshmenItemView.keyLabel.text = [item.key capitalizedString];
        
        if(([key isEqualToString:@"Acceptance Rate"]) || ([key isEqualToString:@"From Out Of State"]) || ([key isEqualToString:@"From Public High School"]) || ([key isEqualToString:@"Receiving Financial Aid"]) || ([key isEqualToString:@"Admitted Early Decision"] || [key isEqualToString:@"Enrolled Early Decision"]) || ([key isEqualToString:@"Admitted From Wait List"]) || ([key isEqualToString:@"6-Year Graduation Rate"]) || ([key isEqualToString:@"Undergrads Off Campus"]) || ([key isEqualToString:@"Undergrads 25 Or Older"])) {
            
            if([key isEqualToString:@"Acceptance Rate"]) {
                freshmenItemView.keyValue.text = [NSString stringWithFormat:@"%.1f%%",[item.value floatValue]];
            }
            else {
                freshmenItemView.keyValue.text = [NSString stringWithFormat:@"%@%%",item.value];
            }
        }
        else if([key isEqualToString:@"Average Financial Aid"]) {
            freshmenItemView.keyValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
        }
        else {
            freshmenItemView.keyValue.text = [NSString stringWithFormat:@"%@",[formatter stringFromNumber:item.value]];
        }
    }
}

- (void)dealloc {
    self.freshmenDetails = nil;
}

@end
