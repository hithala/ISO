//
//  STFilterCollegeTypeCell.m
//  Stipend
//
//  Created by Arun S on 18/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFilterCollegeTypeCell.h"

@implementation STFilterCollegeTypeCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.textColor = [UIColor cellTextFieldTextColor];
    self.titleLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:13.0];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onCollegeTypeAction:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    self.buttonTag = button.tag;
    if([button tag] == 100) {
        if([button isSelected]){
            [button setSelected:NO];
            self.isSelected = NO;
        }
        else{
            [button setSelected:YES];
            self.isSelected = YES;
        }
    } else if([button tag] == 101) {
        if([button isSelected]){
            [button setSelected:NO];
            self.isSelected = NO;
        }
        else{
            [button setSelected:YES];
            self.isSelected = YES;
        }
    } else if([button tag] == 102) {
        if([button isSelected]){
            [button setSelected:NO];
            self.isSelected = NO;
        }
        else{
            [button setSelected:YES];
            self.isSelected = YES;
        }
    } else if([button tag] == 103) {
        if([button isSelected]){
            [button setSelected:NO];
            self.isSelected = NO;
        }
        else{
            [button setSelected:YES];
            self.isSelected = YES;
        }
    } else if([button tag] == 104) {
        if([button isSelected]){
            [button setSelected:NO];
            self.isSelected = NO;
        }
        else{
            [button setSelected:YES];
            self.isSelected = YES;
        }
    } else if([button tag] == 105) {
        if([button isSelected]){
            [button setSelected:NO];
            self.isSelected = NO;
        }
        else{
            [button setSelected:YES];
            self.isSelected = YES;
        }
    } else if([button tag] == 106) {
        if([button isSelected]){
            [button setSelected:NO];
            self.isSelected = NO;
        }
        else{
            [button setSelected:YES];
            self.isSelected = YES;
        }
    }
    
    if(self.didUpdateCellActionBlock) {
        self.didUpdateCellActionBlock(self);
    }
}

@end
