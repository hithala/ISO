//
//  STClickEffectButton.m
//  Stipend
//
//  Created by Arun S on 21/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STClickEffectButton.h"

@implementation STClickEffectButton


- (id) initWithCoder:(NSCoder *)aCoder {
    
    if(self = [super initWithCoder:aCoder]){
        [self addTarget:self action:@selector(applyClickEffect) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(clearClickEffect) forControlEvents:UIControlEventTouchDragExit];
        [self addTarget:self action:@selector(clearClickEffect) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)applyClickEffect {
    [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
}

- (void)clearClickEffect {
    [self setBackgroundColor:[UIColor clearColor]];
}

@end
