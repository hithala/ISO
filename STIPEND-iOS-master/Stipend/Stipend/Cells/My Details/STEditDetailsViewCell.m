//
//  STEditDetailsViewCell.m
//  SwitchDemo
//
//  Created by mahesh on 14/05/15.
//  Copyright (c) 2015 Tarun Tyagi. All rights reserved.
//

#import "STEditDetailsViewCell.h"

#define SEPARATOR_VIEW_VSPACE_CONSTRAINT_CONSTANT        7.0
@implementation STEditDetailsViewCell

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.ibContentTextField];
}

- (void)loadTextFieldType:(EFieldType)fieldType {
    
    self.type = fieldType;
    self.ibContentTextField.enabled = YES;
    self.ibContentTextField.userInteractionEnabled = YES;
    self.ibProfileImageView.hidden = YES;
    self.ibContentTextField.returnKeyType = UIReturnKeyNext;
    self.ibContentTextField.secureTextEntry = YES;
    self.ibContentTextField.textColor = [UIColor colorWithRed:64.0/255.0f green:64.0/255.0f blue:64.0/255.0f alpha:1.0f];
    self.ibContentTextField.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0f];

    UIColor *placeHolderColor = [UIColor colorWithRed:64.0/255.0f green:64.0/255.0f blue:64.0/255.0f alpha:0.5f];

    if (self.type == eEmailField) {
        self.ibSeparatorView.hidden = NO;
        self.ibProfileImageView.hidden = NO;
        self.ibContentTextField.enabled = YES;
        self.ibContentTextField.userInteractionEnabled = NO;
        self.ibContentTextField.secureTextEntry = NO;

        self.ibContentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: placeHolderColor,
                                                                                                                   NSFontAttributeName : [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0f]}];

        //[self.ibContentTextField becomeFirstResponder ];
    } else if (self.type == eOldPasswordField){
        self.ibContentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Old Password" attributes:@{NSForegroundColorAttributeName: placeHolderColor,
                                                                                                                         NSFontAttributeName : [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0f]}];
    } else if (self.type == ePasswordField){
        self.ibContentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: placeHolderColor,
                                                                                                                                NSFontAttributeName : [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0f]}];
    } else if (self.type == eConfirmPasswordField){
        self.ibContentTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: placeHolderColor,
                                                                                                                                NSFontAttributeName : [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0f]}];
        self.ibSeparatorView.hidden = YES;
        self.ibContentTextField.returnKeyType = UIReturnKeyDone;
    }
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    if (self.type == eEmailField) {
        self.ibSepratorViewVerticalSpaceConstraint.constant = 0;//SEPARATOR_VIEW_VSPACE_CONSTRAINT_CONSTANT;
    } else {
        self.ibSepratorViewVerticalSpaceConstraint.constant = 0;
    }
}

- (void) textFieldDidChange:(NSNotification *) notification {
    
    //UITextField *textfield = [notification object];
    
    if(self.didUpdateCellActionBlock) {
        self.didUpdateCellActionBlock(self);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(self.didClickReturnActionBlock) {
        self.didClickReturnActionBlock(self);
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSIndexPath *indexPath = self.cellIndexPath;
    
    if((indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 3)) {
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
    STLog(@"Dealloc");
    self.didClickReturnActionBlock = nil;
    self.didUpdateCellActionBlock = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
