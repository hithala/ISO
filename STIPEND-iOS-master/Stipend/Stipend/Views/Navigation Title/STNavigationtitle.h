//
//  STNavigationtitle.h
//  Stipend
//
//  Created by Ganesh Kumar on 24/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STNavigationtitle : UIView

@property (weak, nonatomic) IBOutlet UILabel *collegeName;
@property (nonatomic,assign) BOOL            isPresenting;

- (void) updateNavigationTitleWithCollegeName:(NSString *)collegeName andPlace:(NSString *) place;

@end
