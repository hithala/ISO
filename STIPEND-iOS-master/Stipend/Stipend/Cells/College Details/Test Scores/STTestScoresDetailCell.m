//
//  STTestScoresDetailCell.m
//  Stipend
//
//  Created by Arun S on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STTestScoresDetailCell.h"
#import "STTestScoresDetailCellView.h"

#import "STCAverageScoreItem.h"

#define TEST_SCORE_BASE_TAG     2543
#define TEST_SCORE_ROW_HEIGHT   80.0

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"

@implementation STTestScoresDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateTestScoresWithDetails:(NSOrderedSet *) detailSet withTestScoresAndGrades:(STCTestScoresAndGrades *) testScoresAndGrades forCollege:(STCollege *)college {
    
    self.shouldShowAstriek = [self shouldShowAstriekForGPA:testScoresAndGrades];
    self.testScoreDetailSet = detailSet;
    self.college = college;
    [self updateTestScoreDetails];
}

- (BOOL) shouldShowAstriekForGPA:(STCTestScoresAndGrades *) testScores {
    
    BOOL showAstriek = YES;
    
    if(testScores.testScoresPieCharts) {
        NSOrderedSet *items = testScores.testScoresPieCharts;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"GPA SCORES"];
        NSOrderedSet *filteredSet = [items filteredOrderedSetUsingPredicate:predicate];
        
        if(filteredSet && ([filteredSet count] > 0)) {
            showAstriek = NO;
        }
        else {
            showAstriek = YES;
        }
    }
    
    
    return showAstriek;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateTestScoreDetails];
}

- (void) updateTestScoreDetails {
    
    NSInteger count = self.testScoreDetailSet.count;
    
    for(int i = 0; i < count ; i++) {
        
        STTestScoresDetailCellView *tesScoreItemView = (STTestScoresDetailCellView *)[self viewWithTag:(TEST_SCORE_BASE_TAG + i)];
        CGRect testScoreItemFrame = CGRectZero;
        
        if(!tesScoreItemView) {
            tesScoreItemView = [[NSBundle mainBundle] loadNibNamed:@"STTestScoresDetailCellView" owner:self options:nil][0];
            tesScoreItemView.tag = (TEST_SCORE_BASE_TAG + i);
            [self.contentView addSubview:tesScoreItemView];
        }
        
        if((i % 3) == 0) {
            testScoreItemFrame.origin.x = 0.0;
            testScoreItemFrame.origin.y = ((i/count) * TEST_SCORE_ROW_HEIGHT);
            testScoreItemFrame.size.width = ([self bounds].size.width/count - 20);
            testScoreItemFrame.size.height = TEST_SCORE_ROW_HEIGHT;
        }
        else if((i % 3) == 1) {
            testScoreItemFrame.origin.x = ([self bounds].size.width/count - 20);
            testScoreItemFrame.origin.y = ((i/count) * TEST_SCORE_ROW_HEIGHT);
            testScoreItemFrame.size.width = ([self bounds].size.width/count + 40);
            testScoreItemFrame.size.height = TEST_SCORE_ROW_HEIGHT;
        }
        else {
            testScoreItemFrame.origin.x = ((2 *([self bounds].size.width/count)) + 20);
            testScoreItemFrame.origin.y = ((i/count) * TEST_SCORE_ROW_HEIGHT);
            testScoreItemFrame.size.width = ([self bounds].size.width/count - 20);
            testScoreItemFrame.size.height = TEST_SCORE_ROW_HEIGHT;
        }
        
        tesScoreItemView.frame = testScoreItemFrame;
        
        STCAverageScoreItem * item = [self.testScoreDetailSet objectAtIndex:i];
        tesScoreItemView.keyLabel.text = item.key;
        
        if([item.key isEqualToString:@"Average GPA"]) {
            
            if(self.shouldShowAstriek) {
                tesScoreItemView.keyValue.text = [NSString stringWithFormat:@"%.2f*",[item.value floatValue]];
            }
            else {
                tesScoreItemView.keyValue.text = [NSString stringWithFormat:@"%.2f",[item.value floatValue]];
            }
        } else if([item.key isEqualToString:@"Average SAT"]) {
        
            if(self.college.averageSATNew.integerValue > 0) {
                tesScoreItemView.keyValue.text = [NSString stringWithFormat:@"%@", self.college.averageSATNew];
            } else {
                tesScoreItemView.keyValue.text = @"N/A";
            }
        } else {
            tesScoreItemView.keyValue.text = [NSString stringWithFormat:@"%@",item.value];
        }
    }
}

- (void)dealloc {
    self.testScoreDetailSet = nil;
}

@end
