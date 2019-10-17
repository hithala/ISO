//
//  STNameTextCell.m
//  Stipend
//
//  Created by Arun S on 07/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNameTextCell.h"
#import "STSignUpViewController.h"

@implementation STNameTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.firstNameField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.lastNameField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) textFieldDidChange:(NSNotification *) notification {
    
    UITextField *textfield = [notification object];
    
    if([textfield isEqual:self.firstNameField]) {
        if([[textfield text] isEqualToString:@""]) {
            self.firstNameLabel.hidden = YES;
        }
        else {
            self.firstNameLabel.hidden = NO;
        }
    }
    else {
        if([[textfield text] isEqualToString:@""]) {
            self.lastNameLabel.hidden = YES;
        }
        else {
            self.lastNameLabel.hidden = NO;
        }
    }
    
    if(self.didUpdateCellActionBlock) {
        self.didUpdateCellActionBlock(self);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if([textField isEqual:self.firstNameField]) {
        
        if(self.didStartEditingActionBlock) {
            self.didStartEditingActionBlock(self,YES);
        }
    }
    else {
        self.didStartEditingActionBlock(self,NO);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if([textField isEqual:self.firstNameField]) {
        
        if(self.didEndEditingActionBlock) {
            self.didEndEditingActionBlock(self,YES);
        }
    }
    else {
        self.didEndEditingActionBlock(self,NO);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(self.didClickReturnActionBlock) {
        self.didClickReturnActionBlock(self);
    }
    
    return NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
