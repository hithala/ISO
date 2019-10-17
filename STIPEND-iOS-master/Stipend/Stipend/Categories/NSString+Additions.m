//
//  NSString+Additions.m
//  Stipend
//
//  Created by Arun S on 11/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#define ACCEPTABLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."


#import "NSString+Additions.h"

@implementation NSString(Additions)

- (BOOL)validateEmailAddress {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPassword {
    
    if([self length] < 6) {
        return NO;
    }

    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![filtered isEqualToString:self]){
        return NO;
    }
    
    NSCharacterSet *chars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    NSRange range = [self rangeOfCharacterFromSet:chars];
    
    if (!range.length) {
        return NO;
    }

    if ([[self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]] count] < 2){
        return NO;
    }
    return YES;
}
@end
