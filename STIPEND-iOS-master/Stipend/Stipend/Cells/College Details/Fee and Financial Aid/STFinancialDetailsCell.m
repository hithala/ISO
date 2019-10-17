//
//  STFinancialDetailsCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFinancialDetailsCell.h"
#import "STFinancialListView.h"
#import "STFinancialTotalView.h"
#import "STFinancialAidView.h"
#import "STFinancialAidNetPriceView.h"

#define FEE_LIST_BASE_TAG               100
#define FEE_TOTAL_TAG                   200
#define FEE_AID_TAG                     300
#define FEE_TOGGLE_STATE_TAG            400
#define FEE_SEPARATOR_TAG               500
#define FEE_AVG_DEBT_TAG                600
#define FEE_AVG_NET_PRICE_TAG           700

#define ROW_HEIGHT                      50.0
#define TOGGLE_VIEW_HEIGHT              60.0

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_EXPAND                      @"kExpandKey"

#define KEY_SELECTED_INDEX              @"kSelectedIndexKey"

#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_VALUES_DICT                 @"kValuesDictKey"

@implementation STFinancialDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedIndex = -1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateFeeAndFinancialWithDetails:(STCFeesAndFinancialAid *)details {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.feeAndFinancialDetails = details;
    [self updateFeeAndFinancialDetails];
    [self setNeedsDisplay];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateFeeAndFinancialDetails];
}

- (NSOrderedSet *) getOrderedSetForFeesObjectAtIndex:(NSInteger) index {
    
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    
    if(self.feeAndFinancialDetails.inStateFees) {
        [orderedSet addObject:self.feeAndFinancialDetails.inStateFees];
    }
    
    if(self.feeAndFinancialDetails.outStateFees) {
        [orderedSet addObject:self.feeAndFinancialDetails.outStateFees];
    }
    
    return [orderedSet objectAtIndex:index];
}

- (void)updateFeeAndFinancialDetails {
    
    NSOrderedSet *feesAndFinancialAidSet;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if([self.feeAndFinancialDetails.feesSelectedIndex integerValue] != -1) {
        feesAndFinancialAidSet = [self getOrderedSetForFeesObjectAtIndex:[self.feeAndFinancialDetails.feesSelectedIndex integerValue]];
        self.selectedIndex = [self.feeAndFinancialDetails.feesSelectedIndex integerValue];
    }

    STCollegeSegmentControl *segmentControl = (STCollegeSegmentControl *)[self viewWithTag:(FEE_TOGGLE_STATE_TAG)];

    if(!segmentControl) {
        segmentControl = [[STCollegeSegmentControl alloc] initWithFrame:CGRectZero];
        segmentControl.delegate = self;
        segmentControl.tag = FEE_TOGGLE_STATE_TAG;
        [self.contentView addSubview:segmentControl];
    }
    
    NSMutableArray *itemArray = [self getItemsFromFeesAndFinancialAidList];
    
    segmentControl.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 60.0);
    [segmentControl setSelectedIndex:self.selectedIndex];
    [segmentControl updateSegmentControlWithItems:itemArray];
    
    UIView *separatorView = [self viewWithTag:(FEE_SEPARATOR_TAG)];
    
    if(!separatorView) {
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.frame.size.width, 0.5)];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:separatorView];
    }
    
    for(int i = 0; i < ([feesAndFinancialAidSet count] - 1); i++) {
        
        STFinancialListView *listView = (STFinancialListView *)[self viewWithTag:(FEE_LIST_BASE_TAG + i)];
        
        if(!listView) {
            listView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialListView" owner:self options:nil][0];
            listView.tag = (FEE_LIST_BASE_TAG + i);
            listView.frame = CGRectMake(0, (60 + (i * ROW_HEIGHT)), self.frame.size.width, ROW_HEIGHT);
            listView.cellSeparatorHeightConstraint.constant = 0.5f;
            [self.contentView addSubview:listView];
        }
        else {
            listView.frame = CGRectMake(0, (60 + (i * ROW_HEIGHT)), self.frame.size.width, ROW_HEIGHT);
        }
        
        if([self.feeAndFinancialDetails.feesSelectedIndex integerValue] == 0) {
            
            STCInStateFees *inStateFee = [feesAndFinancialAidSet objectAtIndex:i];
            listView.ibLabelField.text = [inStateFee.key capitalizedString];
            listView.ibLabelValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:inStateFee.value]];
        } else {
            
            STCOutStateFees *outStateFee = [feesAndFinancialAidSet objectAtIndex:i];
            listView.ibLabelField.text = [outStateFee.key capitalizedString];
            listView.ibLabelValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:outStateFee.value]];
        }
    }
    
    STFinancialTotalView *totalView = (STFinancialTotalView *)[self viewWithTag:FEE_TOTAL_TAG];
    
    if(!totalView) {
        totalView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialTotalView" owner:self options:nil][0];
        totalView.tag = FEE_TOTAL_TAG;
        totalView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)), self.frame.size.width, ROW_HEIGHT);
        totalView.cellSeparatorHeightConstraint.constant = 0.5f;
        [self.contentView addSubview:totalView];
    }
    else {
        totalView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)), self.frame.size.width, ROW_HEIGHT);
    }
    
    if([self.feeAndFinancialDetails.feesSelectedIndex integerValue] == 0) {
        
        STCInStateFees *inStateFee = [feesAndFinancialAidSet lastObject];
        totalView.totalFeesLabel.text = [inStateFee.key capitalizedString];
        totalView.totalFeesValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:inStateFee.value]];
    } else {
        
        STCOutStateFees *outStateFee = [feesAndFinancialAidSet lastObject];
        totalView.totalFeesLabel.text = [outStateFee.key capitalizedString];
        totalView.totalFeesValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:outStateFee.value]];
    }
    
    CGFloat totalViewYPosition = totalView.frame.origin.y + 50;
    int indexPosition = 0;

    // Average Financial Aid fields
    if([self.feeAndFinancialDetails.averageFinancialAid intValue] > 0) {
        
        STFinancialAidView *avgFinancialAidView = (STFinancialAidView *)[self viewWithTag:(FEE_AID_TAG + 01)];
//        avgFinancialAidView.backgroundColor = [UIColor greenColor];
        
        int xPosition = 0;
        if ((indexPosition % 2) != 0) {
            xPosition = self.frame.size.width/2;
        }

        int yPosition = (indexPosition / 2) * 80;
        
        if(!avgFinancialAidView) {
            avgFinancialAidView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidView" owner:self options:nil][0];
            avgFinancialAidView.tag = (FEE_AID_TAG + 01);
            avgFinancialAidView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
            avgFinancialAidView.cellSeparatorHeightConstraint.constant = 0.5f;
            [self.contentView addSubview:avgFinancialAidView];
        } else {
            avgFinancialAidView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
        }
        
        avgFinancialAidView.fieldLabel.text = @"Average Financial Aid";
        avgFinancialAidView.fieldValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageFinancialAid]];
        
        indexPosition++;
    }
    
    // Receiving Financial Aid fields
    if([self.feeAndFinancialDetails.receivingFinancialAid intValue] > 0) {
        
        STFinancialAidView *avgFinancialAidView = (STFinancialAidView *)[self viewWithTag:(FEE_AID_TAG + 02)];
//        avgFinancialAidView.backgroundColor = [UIColor redColor];
        
        int xPosition = 0;
        if ((indexPosition % 2) != 0) {
            xPosition = self.frame.size.width/2;
        }
        
        int yPosition = (indexPosition / 2) * 80;

        if(!avgFinancialAidView) {
            avgFinancialAidView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidView" owner:self options:nil][0];
            avgFinancialAidView.tag = (FEE_AID_TAG + 02);
            avgFinancialAidView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
            avgFinancialAidView.cellSeparatorHeightConstraint.constant = 0.5f;
            [self.contentView addSubview:avgFinancialAidView];
        } else {
            avgFinancialAidView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
        }
        
        avgFinancialAidView.fieldLabel.text = @"Receiving Financial Aid";
        avgFinancialAidView.fieldValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.receivingFinancialAid]];
        
        indexPosition++;
    }
    
    // Average Merit Award field
    if([self.feeAndFinancialDetails.averageMeritAward intValue] > 0) {
        
        STFinancialAidNetPriceView *averageMeritAwardView = (STFinancialAidNetPriceView *)[self viewWithTag:(FEE_AID_TAG + 06)];
        //        averageMeritAwardView.backgroundColor = [UIColor greenColor];
        
        int xPosition = 0;
        if ((indexPosition % 2) != 0) {
            xPosition = self.frame.size.width/2;
        }
        
        int yPosition = (indexPosition / 2) * 80;
        
        if(!averageMeritAwardView) {
            averageMeritAwardView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidNetPriceView" owner:self options:nil][0];
            averageMeritAwardView.tag = (FEE_AID_TAG + 06);
            averageMeritAwardView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
            averageMeritAwardView.cellSeparatorHeightConstraint.constant = 0.5f;
            [self.contentView addSubview:averageMeritAwardView];
        } else {
            averageMeritAwardView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
        }
        
        averageMeritAwardView.fieldLabel.text = @"Average Merit Award";
        averageMeritAwardView.fieldValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageMeritAward]];
        
        __weak STFinancialAidNetPriceView *weakAvgNetPriceView = averageMeritAwardView;
        
        averageMeritAwardView.imageClickActionBlock = ^(UIImageView *questionMarkview){
            if(self.imageClickActionBlock) {
                self.imageClickActionBlock(questionMarkview, weakAvgNetPriceView.frame, (xPosition == 0 ? 1 : 2), FinancialAidItemAverageMeritAward);
            }
        };
        
        indexPosition++;
    }
    
    // Receiving Merit Awards field
    if([self.feeAndFinancialDetails.receivingMeritAwards intValue] > 0) {
        
        STFinancialAidNetPriceView *receivingMeritAwardsView = (STFinancialAidNetPriceView *)[self viewWithTag:(FEE_AID_TAG + 07)];
        //        receivingMeritAwardsView.backgroundColor = [UIColor redColor];
        
        int xPosition = 0;
        if ((indexPosition % 2) != 0) {
            xPosition = self.frame.size.width/2;
        }
        
        int yPosition = (indexPosition / 2) * 80;
        
        if(!receivingMeritAwardsView) {
            receivingMeritAwardsView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidNetPriceView" owner:self options:nil][0];
            receivingMeritAwardsView.tag = (FEE_AID_TAG + 07);
            receivingMeritAwardsView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
            receivingMeritAwardsView.cellSeparatorHeightConstraint.constant = 0.5f;
            [self.contentView addSubview:receivingMeritAwardsView];
        } else {
            receivingMeritAwardsView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
        }
        
        receivingMeritAwardsView.fieldLabel.text = @"Receiving Merit Awards";
        receivingMeritAwardsView.fieldValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.receivingMeritAwards]];
        
        __weak STFinancialAidNetPriceView *weakAvgNetPriceView = receivingMeritAwardsView;
        
        receivingMeritAwardsView.imageClickActionBlock = ^(UIImageView *questionMarkview){
            if(self.imageClickActionBlock) {
                self.imageClickActionBlock(questionMarkview, weakAvgNetPriceView.frame, (xPosition == 0 ? 1 : 2), FinancialAidItemReceivingMeritAwards);
            }
        };
        
        indexPosition++;
    }
    
    // Avg Debt Upon Graduation field
    if([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) {

        STFinancialAidView *avgDebtUponGradView = (STFinancialAidView *)[self viewWithTag:(FEE_AID_TAG + 03)];
//        avgDebtUponGradView.backgroundColor = [UIColor redColor];

        int xPosition = 0;
        if ((indexPosition % 2) != 0) {
            xPosition = self.frame.size.width/2;
        }

        int yPosition = (indexPosition / 2) * 80;

        if(!avgDebtUponGradView) {
            avgDebtUponGradView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidView" owner:self options:nil][0];
            avgDebtUponGradView.tag = (FEE_AID_TAG + 03);
            avgDebtUponGradView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
            avgDebtUponGradView.cellSeparatorHeightConstraint.constant = 0.5f;
            [self.contentView addSubview:avgDebtUponGradView];
        } else {
            avgDebtUponGradView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
        }

        avgDebtUponGradView.fieldLabel.text = @"Avg Debt Upon Graduation";
        avgDebtUponGradView.fieldValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageDebtUponGraduation]];

        indexPosition++;
    }
    
    if([self.feeAndFinancialDetails.averageNeedMet intValue] > 0) {
        
        STFinancialAidView *avgDebtUponGradView = (STFinancialAidView *)[self viewWithTag:(FEE_AID_TAG + 04)];
//        avgDebtUponGradView.backgroundColor = [UIColor redColor];
        
        int xPosition = 0;
        if ((indexPosition % 2) != 0) {
            xPosition = self.frame.size.width/2;
        }
        
        int yPosition = (indexPosition / 2) * 80;

        if(!avgDebtUponGradView) {
            avgDebtUponGradView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidView" owner:self options:nil][0];
            avgDebtUponGradView.tag = (FEE_AID_TAG + 04);
            avgDebtUponGradView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
            avgDebtUponGradView.cellSeparatorHeightConstraint.constant = 0.5f;
            [self.contentView addSubview:avgDebtUponGradView];
        } else {
            avgDebtUponGradView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
        }

        avgDebtUponGradView.fieldLabel.text = @"Average Need Met";
        avgDebtUponGradView.fieldValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNeedMet]];

        indexPosition++;
    }
    
    if([self.feeAndFinancialDetails.averageNetPrice intValue] > 0) {
        
        STFinancialAidNetPriceView *avgNetPriceView = (STFinancialAidNetPriceView *)[self viewWithTag:(FEE_AID_TAG + 05)];
//        avgNetPriceView.backgroundColor = [UIColor greenColor];

        int xPosition = 0;
        if ((indexPosition % 2) != 0) {
            xPosition = self.frame.size.width/2;
        }
        
        int yPosition = (indexPosition / 2) * 80;

        if(!avgNetPriceView) {
            avgNetPriceView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidNetPriceView" owner:self options:nil][0];
            avgNetPriceView.tag = (FEE_AID_TAG + 05);
            avgNetPriceView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
            avgNetPriceView.cellSeparatorHeightConstraint.constant = 0.5f;
            [self.contentView addSubview:avgNetPriceView];
        } else {
            avgNetPriceView.frame = CGRectMake(xPosition, (totalViewYPosition + yPosition), self.frame.size.width/2, 80.0);
        }
        
        avgNetPriceView.fieldLabel.text = @"Average Net Price";
        avgNetPriceView.fieldValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNetPrice]];
        
        __weak STFinancialAidNetPriceView *weakAvgNetPriceView = avgNetPriceView;
        
        avgNetPriceView.imageClickActionBlock = ^(UIImageView *questionMarkview){
            if(self.imageClickActionBlock) {
                self.imageClickActionBlock(questionMarkview, weakAvgNetPriceView.frame, (xPosition == 0 ? 1 : 2), FinancialAidItemNetPrice);
            }
        };
        
        indexPosition++;
    }
    
    /*
    // ******************************** Average Financial Aid and Receiving Financial Aid fields  ********************************
    STFinancialAidView *financialAidView = (STFinancialAidView *)[self viewWithTag:FEE_AID_TAG];
    
    if(!financialAidView) {
        financialAidView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidView" owner:self options:nil][0];
        financialAidView.tag = FEE_AID_TAG;
        financialAidView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT))+50, self.frame.size.width, 80.0);
        financialAidView.cellSeparatorHeightConstraint.constant = 0.5f;
//        [self.contentView addSubview:financialAidView];
    }
    else {
       financialAidView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT))+50, self.frame.size.width, 80.0);
    }
    
    financialAidView.averageFinancilaAidLabel.text = @"Average Financial Aid";
    financialAidView.averageFinancilaAidValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageFinancialAid]];
    
    financialAidView.receivingFinancilaAidLabel.text = @"Receiving Financial Aid";
    financialAidView.receivingFinancilaAidValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.receivingFinancialAid]];

    // Average Merit Award and Receiving Merit Awards fields
//    if([self.feeAndFinancialDetails.averageMeritAward])

    // Avg Debt Upon Graduation, Average Need Met, Average Net Price fields
    if(([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) && ([self.feeAndFinancialDetails.averageNeedMet intValue] > 0) && ([self.feeAndFinancialDetails.averageNetPrice intValue] > 0)) {

        STFinancialAidView *avgDebtUponGradView = (STFinancialAidView *)[self viewWithTag:FEE_AVG_DEBT_TAG];
        
        if(!avgDebtUponGradView) {
            avgDebtUponGradView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidView" owner:self options:nil][0];
            avgDebtUponGradView.tag = FEE_AVG_DEBT_TAG;
            avgDebtUponGradView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
            avgDebtUponGradView.cellSeparatorHeightConstraint.constant = 0.5f;
//            [self.contentView addSubview:avgDebtUponGradView];
        }
        else {
            avgDebtUponGradView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
        }
        
        if([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) {
            avgDebtUponGradView.averageFinancilaAidLabel.text = @"Avg Debt Upon Graduation";
            avgDebtUponGradView.averageFinancilaAidValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageDebtUponGraduation]];
        }
        
        if(([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) && ([self.feeAndFinancialDetails.averageNeedMet intValue] > 0)) {
            avgDebtUponGradView.receivingFinancilaAidLabel.text = @"Average Need Met";
            avgDebtUponGradView.receivingFinancilaAidValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNeedMet]];
        } else if([self.feeAndFinancialDetails.averageNeedMet intValue] > 0) {
            avgDebtUponGradView.averageFinancilaAidLabel.text = @"Average Need Met";
            avgDebtUponGradView.averageFinancilaAidValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNeedMet]];
            
            avgDebtUponGradView.receivingFinancilaAidLabel.text = @"";
            avgDebtUponGradView.receivingFinancilaAidValue.text = @"";
        } else {
            avgDebtUponGradView.receivingFinancilaAidLabel.text = @"";
            avgDebtUponGradView.receivingFinancilaAidValue.text = @"";
        }

        STFinancialAidNetPriceView *avgNetPriceView = (STFinancialAidNetPriceView *)[self viewWithTag:FEE_AVG_NET_PRICE_TAG];
        
        if(!avgNetPriceView) {
            avgNetPriceView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidNetPriceView" owner:self options:nil][0];
            avgNetPriceView.tag = FEE_AVG_NET_PRICE_TAG;
            avgNetPriceView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 160, self.frame.size.width, 80.0);
            avgNetPriceView.cellSeparatorHeightConstraint.constant = 0.5f;
//            [self.contentView addSubview:avgNetPriceView];
        }
        else {
            avgNetPriceView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 160, self.frame.size.width, 80.0);
        }
        
        avgNetPriceView.averageNetPriceValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNetPrice]];
        
        __weak STFinancialAidNetPriceView *weakAvgNetPriceView = avgNetPriceView;
        
        avgNetPriceView.imageClickActionBlock = ^(UIImageView *questionMarkview){
            if(self.imageClickActionBlock) {
                self.imageClickActionBlock(questionMarkview, weakAvgNetPriceView.frame, 3);
            }
        };
        
    } else if(([self.feeAndFinancialDetails.averageNeedMet intValue] > 0) && ([self.feeAndFinancialDetails.averageNetPrice intValue] > 0)) {

        STFinancialAidView *avgDebtUponGradView = (STFinancialAidView *)[self viewWithTag:FEE_AVG_DEBT_TAG];

        if(!avgDebtUponGradView) {
            avgDebtUponGradView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidView" owner:self options:nil][0];
            avgDebtUponGradView.tag = FEE_AVG_DEBT_TAG;
            avgDebtUponGradView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
            avgDebtUponGradView.cellSeparatorHeightConstraint.constant = 0.5f;
//            [self.contentView addSubview:avgDebtUponGradView];
        } else {
            avgDebtUponGradView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
        }

        avgDebtUponGradView.averageFinancilaAidLabel.text = @"Average Need Met";
        avgDebtUponGradView.averageFinancilaAidValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNeedMet]];
        avgDebtUponGradView.receivingFinancilaAidLabel.text = @"";
        avgDebtUponGradView.receivingFinancilaAidValue.text = @"";
        
        STFinancialAidNetPriceView *avgNetPriceView = (STFinancialAidNetPriceView *)[self viewWithTag:FEE_AVG_NET_PRICE_TAG];
        
        if(!avgNetPriceView) {
            avgNetPriceView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidNetPriceView" owner:self options:nil][0];
            avgNetPriceView.tag = FEE_AVG_NET_PRICE_TAG;
            avgNetPriceView.frame = CGRectMake(((self.frame.size.width / 2) - 5), (60 + (5 * ROW_HEIGHT)) + 50 + 80, (self.frame.size.width / 2), 80.0);
            avgNetPriceView.cellSeparatorHeightConstraint.constant = 0.5f;
//            [self.contentView addSubview:avgNetPriceView];
        } else {
            avgNetPriceView.frame = CGRectMake(((self.frame.size.width / 2) - 5), (60 + (5 * ROW_HEIGHT)) + 50 + 80, (self.frame.size.width / 2), 80.0);
        }
        
        avgNetPriceView.averageNetPriceValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNetPrice]];
        
        __weak STFinancialAidNetPriceView *weakAvgNetPriceView = avgNetPriceView;
        
        avgNetPriceView.imageClickActionBlock = ^(UIImageView *questionMarkview){
            if(self.imageClickActionBlock) {
                self.imageClickActionBlock(questionMarkview, weakAvgNetPriceView.frame, 2);
            }
        };
        
    } else if(([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) && ([self.feeAndFinancialDetails.averageNeedMet intValue] > 0)) {

        STFinancialAidView *avgDebtUponGradView = (STFinancialAidView *)[self viewWithTag:FEE_AVG_DEBT_TAG];
        
        if(!avgDebtUponGradView) {
            avgDebtUponGradView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidView" owner:self options:nil][0];
            avgDebtUponGradView.tag = FEE_AVG_DEBT_TAG;
            avgDebtUponGradView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
            avgDebtUponGradView.cellSeparatorHeightConstraint.constant = 0.5f;
//            [self.contentView addSubview:avgDebtUponGradView];
        }
        else {
            avgDebtUponGradView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
        }
        
        if([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) {
            avgDebtUponGradView.averageFinancilaAidLabel.text = @"Avg Debt Upon Graduation";
            avgDebtUponGradView.averageFinancilaAidValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageDebtUponGraduation]];
        }

        if(([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) && ([self.feeAndFinancialDetails.averageNeedMet intValue] > 0)) {
            avgDebtUponGradView.receivingFinancilaAidLabel.text = @"Average Need Met";
            avgDebtUponGradView.receivingFinancilaAidValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNeedMet]];
        } else if([self.feeAndFinancialDetails.averageNeedMet intValue] > 0) {
            avgDebtUponGradView.averageFinancilaAidLabel.text = @"Average Need Met";
            avgDebtUponGradView.averageFinancilaAidValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNeedMet]];
            
            avgDebtUponGradView.receivingFinancilaAidLabel.text = @"";
            avgDebtUponGradView.receivingFinancilaAidValue.text = @"";
        } else {
            avgDebtUponGradView.receivingFinancilaAidLabel.text = @"";
            avgDebtUponGradView.receivingFinancilaAidValue.text = @"";
        }
    } else if(([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) && ([self.feeAndFinancialDetails.averageNetPrice intValue] > 0)) {
        
        STFinancialAidView *avgDebtUponGradView = (STFinancialAidView *)[self viewWithTag:FEE_AVG_DEBT_TAG];
        
        if(!avgDebtUponGradView) {
            avgDebtUponGradView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidView" owner:self options:nil][0];
            avgDebtUponGradView.tag = FEE_AVG_DEBT_TAG;
            avgDebtUponGradView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
            avgDebtUponGradView.cellSeparatorHeightConstraint.constant = 0.5f;
//            [self.contentView addSubview:avgDebtUponGradView];
        }
        else {
            avgDebtUponGradView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
        }
        
        avgDebtUponGradView.averageFinancilaAidLabel.text = @"Avg Debt Upon Graduation";
        avgDebtUponGradView.averageFinancilaAidValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageDebtUponGraduation]];
        avgDebtUponGradView.receivingFinancilaAidLabel.text = @"";
        avgDebtUponGradView.receivingFinancilaAidValue.text = @"";
        
        STFinancialAidNetPriceView *avgNetPriceView = (STFinancialAidNetPriceView *)[self viewWithTag:FEE_AVG_NET_PRICE_TAG];
        
        if(!avgNetPriceView) {
            avgNetPriceView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidNetPriceView" owner:self options:nil][0];
            avgNetPriceView.tag = FEE_AVG_NET_PRICE_TAG;
            avgNetPriceView.frame = CGRectMake(((self.frame.size.width / 2) - 5), (60 + (5 * ROW_HEIGHT)) + 50 + 80, (self.frame.size.width / 2), 80.0);
            avgNetPriceView.cellSeparatorHeightConstraint.constant = 0.5f;
//            [self.contentView addSubview:avgNetPriceView];
        } else {
            avgNetPriceView.frame = CGRectMake(((self.frame.size.width / 2) - 5), (60 + (5 * ROW_HEIGHT)) + 50 + 80, (self.frame.size.width / 2), 80.0);
        }
        
        avgNetPriceView.averageNetPriceValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNetPrice]];
        
        __weak STFinancialAidNetPriceView *weakAvgNetPriceView = avgNetPriceView;
        
        avgNetPriceView.imageClickActionBlock = ^(UIImageView *questionMarkview){
            if(self.imageClickActionBlock) {
                self.imageClickActionBlock(questionMarkview, weakAvgNetPriceView.frame, 2);
            }
        };
        
    } else {
        
        if(([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) || ([self.feeAndFinancialDetails.averageNeedMet intValue] > 0)) {
            
            STFinancialAidView *avgDebtUponGradView = (STFinancialAidView *)[self viewWithTag:FEE_AVG_DEBT_TAG];
            
            if(!avgDebtUponGradView) {
                avgDebtUponGradView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidView" owner:self options:nil][0];
                avgDebtUponGradView.tag = FEE_AVG_DEBT_TAG;
                avgDebtUponGradView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
                avgDebtUponGradView.cellSeparatorHeightConstraint.constant = 0.5f;
//                [self.contentView addSubview:avgDebtUponGradView];
            }
            else {
                avgDebtUponGradView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
            }
            
            if([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) {
                avgDebtUponGradView.averageFinancilaAidLabel.text = @"Avg Debt Upon Graduation";
                avgDebtUponGradView.averageFinancilaAidValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageDebtUponGraduation]];
            }
            
            if(([self.feeAndFinancialDetails.averageDebtUponGraduation intValue] > 0) && ([self.feeAndFinancialDetails.averageNeedMet intValue] > 0)) {
                avgDebtUponGradView.receivingFinancilaAidLabel.text = @"Average Need Met";
                avgDebtUponGradView.receivingFinancilaAidValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNeedMet]];
            } else if([self.feeAndFinancialDetails.averageNeedMet intValue] > 0) {
                avgDebtUponGradView.averageFinancilaAidLabel.text = @"Average Need Met";
                avgDebtUponGradView.averageFinancilaAidValue.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNeedMet]];
                
                avgDebtUponGradView.receivingFinancilaAidLabel.text = @"";
                avgDebtUponGradView.receivingFinancilaAidValue.text = @"";
            } else {
                avgDebtUponGradView.receivingFinancilaAidLabel.text = @"";
                avgDebtUponGradView.receivingFinancilaAidValue.text = @"";
            }
        }
        
        if([self.feeAndFinancialDetails.averageNetPrice intValue] > 0) {
            
            STFinancialAidNetPriceView *avgNetPriceView = (STFinancialAidNetPriceView *)[self viewWithTag:FEE_AVG_NET_PRICE_TAG];
            
            if(!avgNetPriceView) {
                avgNetPriceView = [[NSBundle mainBundle] loadNibNamed:@"STFinancialAidNetPriceView" owner:self options:nil][0];
                avgNetPriceView.tag = FEE_AVG_NET_PRICE_TAG;
                avgNetPriceView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
                avgNetPriceView.cellSeparatorHeightConstraint.constant = 0.5f;
//                [self.contentView addSubview:avgNetPriceView];
            }
            else {
                avgNetPriceView.frame = CGRectMake(0, (60 + (5 * ROW_HEIGHT)) + 50 + 80, self.frame.size.width, 80.0);
            }
            
            avgNetPriceView.averageNetPriceValue.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:self.feeAndFinancialDetails.averageNetPrice]];
            
            __weak STFinancialAidNetPriceView *weakAvgNetPriceView = avgNetPriceView;
            
            avgNetPriceView.imageClickActionBlock = ^(UIImageView *questionMarkview){
                if(self.imageClickActionBlock) {
                    self.imageClickActionBlock(questionMarkview, weakAvgNetPriceView.frame, 1);
                }
            };
        }
    }
     */
}

- (void) didClickSegmentAtIndex:(NSUInteger) index {
    
    if(index != self.selectedIndex) {
        self.feeAndFinancialDetails.feesSelectedIndex = [NSNumber numberWithInteger:index];
        self.selectedIndex = index;
        
        if(self.toggleAction) {
            self.toggleAction();
        }
    }
}

- (NSMutableArray *) getItemsFromFeesAndFinancialAidList {
    
    NSMutableArray *valueArray = [NSMutableArray array];
    
    if(self.feeAndFinancialDetails.outStateFees.count > 0) {
        [valueArray addObject:@"IN STATE"];
    }
    
    if(self.feeAndFinancialDetails.inStateFees.count > 0) {
        [valueArray addObject:@"OUT OF STATE"];
    }

    return valueArray;
}

- (void)dealloc {

    self.feeAndFinancialDetails = nil;
}

@end
