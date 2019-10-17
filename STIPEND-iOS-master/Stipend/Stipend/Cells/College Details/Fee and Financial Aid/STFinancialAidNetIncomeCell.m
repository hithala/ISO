//
//  STFinancialAidNetIncomeCell.m
//  Stipend
//
//  Created by Ganesh kumar on 12/07/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import "STFinancialAidNetIncomeCell.h"
#import "STFinancialListView.h"

#define FEE_LIST_BASE_TAG               100

#define ROW_HEIGHT                      50.0

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"

@implementation STFinancialAidNetIncomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.topSeparatorViewHeightConstraint.constant = 0.5f;
    self.bottomSeparatorViewHeightConstraint.constant = 0.5f;
    self.endSeparatorViewHeightConstraint.constant = 0.5f;
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.questionmarkView addGestureRecognizer:singleTap];
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer {
    if(self.imageClickActionBlock) {
        self.imageClickActionBlock(self.questionmarkView, CGRectZero, 4);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithNetIncomeDetails:(NSOrderedSet *)netHouseHoldIncomeDetails {

    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.netHouseholdIncome = netHouseHoldIncomeDetails;
    [self updateNetincomeDetails];
    [self setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateNetincomeDetails];
}

- (void)updateNetincomeDetails {

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

    for(int i = 0; i < self.netHouseholdIncome.count; i++) {
        
        STFinancialListView *listView = (STFinancialListView *)[self viewWithTag:(FEE_LIST_BASE_TAG + i)];
        STCHouseholdIncome *houseHoldIncome = [self.netHouseholdIncome objectAtIndex:i];
        
        if(!listView) {
            listView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialListView" owner:self options:nil][0];
            listView.tag = (FEE_LIST_BASE_TAG + i);
            listView.frame = CGRectMake(0, ((i * ROW_HEIGHT)), self.containerView.frame.size.width, ROW_HEIGHT);
            listView.cellSeparatorHeightConstraint.constant = 0.5f;
            [self.containerView addSubview:listView];
        } else {
            listView.frame = CGRectMake(0, ((i * ROW_HEIGHT)), self.containerView.frame.size.width, ROW_HEIGHT);
        }
        
        listView.ibLabelField.text = [houseHoldIncome.key capitalizedString];
        if(houseHoldIncome.value.integerValue > 0) {
            listView.ibLabelValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:houseHoldIncome.value]];
        } else {
            listView.ibLabelValue.text = @"";
        }

//        if(i == 0) {
//            [listView updatQuestionMarkView];
//        }
        
        if(i == (self.netHouseholdIncome.count - 1)) {
            listView.cellSeparatorHeightConstraint.constant = 0.0f;
        }
        
//        __weak STFinancialAidNetIncomeCell *weakSelf = self;
//        __weak STFinancialListView *weakListView = listView;
//
//        CGRect listViewRect = weakListView.frame;
//        listViewRect.origin.y += 65.0f;
//
//        listView.imageClickActionBlock = ^(UIImageView *questionMarkview){
//            if(weakSelf.imageClickActionBlock) {
//                weakSelf.imageClickActionBlock(questionMarkview, listViewRect, 1);
//            }
//        };
    }
}

@end
