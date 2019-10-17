//
//  STLoginTextCell.m
//  Stipend
//
//  Created by Arun S on 07/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STLoginTextCell.h"
#import "STSignUpViewController.h"

@implementation STLoginTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.valueField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) textFieldDidChange:(NSNotification *) notification {
    
    UITextField *textfield = [notification object];
    
    if([[textfield text] isEqualToString:@""]) {
        self.valueLabel.hidden = YES;
    }
    else {
        self.valueLabel.hidden = NO;
    }
    
    if(self.didUpdateCellActionBlock) {
        self.didUpdateCellActionBlock(self);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if(self.didStartEditingActionBlock) {
        self.didStartEditingActionBlock(self);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(self.didEndEditingActionBlock) {
        self.didEndEditingActionBlock(self);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(self.didClickReturnActionBlock) {
        self.didClickReturnActionBlock(self);
    }

    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(([self.valueLabel.text isEqualToString:@"PASSWORD"]) || ([self.valueLabel.text isEqualToString:@"CONFIRM PASSWORD"])) {
        NSRange spaceRange = [string rangeOfString:@" "];
        if (spaceRange.location != NSNotFound) {
            return NO;
        } else {
            return YES;
        }
    }

    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
