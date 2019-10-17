//
//  STProfileScoreCell.m
//  Stipend
//
//  Created by Arun S on 11/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STProfileScoreCell.h"

@implementation STProfileScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.gpaTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.satTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.actTextField];

    self.gpaLabel.textColor = [UIColor lightGrayColor];
    self.gpaLabel.font = [UIFont boldSystemFontOfSize:11.0];
    self.gpaLabel.hidden = YES;
    
    self.satLabel.textColor = [UIColor lightGrayColor];
    self.satLabel.font = [UIFont boldSystemFontOfSize:11.0];
    self.satLabel.hidden = YES;
    
    self.actLabel.textColor = [UIColor lightGrayColor];
    self.actLabel.font = [UIFont boldSystemFontOfSize:11.0];
    self.actLabel.hidden = YES;

    self.gpaTextField.textColor = [UIColor blackColor];
    self.gpaTextField.font = [UIFont systemFontOfSize:17.0];
    
    self.satTextField.textColor = [UIColor blackColor];
    self.satTextField.font = [UIFont systemFontOfSize:17.0];
    
    self.actTextField.textColor = [UIColor blackColor];
    self.actTextField.font = [UIFont systemFontOfSize:17.0];

    self.gpaSeperatorView.backgroundColor = [UIColor lightGrayColor];
    self.satSperatorView.backgroundColor = [UIColor lightGrayColor];
    self.actSeperatorView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) textFieldDidChange:(NSNotification *) notification {
    
    UITextField *textfield = [notification object];
    
    if([textfield isEqual:self.gpaTextField]) {
        if([[textfield text] isEqualToString:@""]) {
            self.gpaLabel.hidden = YES;
            self.gpaSeperatorView.backgroundColor = [UIColor lightGrayColor];
        }
        else {
            self.gpaLabel.hidden = NO;
            self.gpaSeperatorView.backgroundColor = [UIColor blackColor];
        }
    }
    else if([textfield isEqual:self.satTextField]) {
        if([[textfield text] isEqualToString:@""]) {
            self.satLabel.hidden = YES;
            self.satSperatorView.backgroundColor = [UIColor lightGrayColor];
        }
        else {
            self.satLabel.hidden = NO;
            self.satSperatorView.backgroundColor = [UIColor blackColor];
        }
    }
    else {
        if([[textfield text] isEqualToString:@""]) {
            self.actLabel.hidden = YES;
            self.actSeperatorView.backgroundColor = [UIColor lightGrayColor];
        }
        else {
            self.actLabel.hidden = NO;
            self.actSeperatorView.backgroundColor = [UIColor blackColor];
        }
    }
    
    if(self.didUpdateCellActionBlock) {
        self.didUpdateCellActionBlock(self);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

@end
