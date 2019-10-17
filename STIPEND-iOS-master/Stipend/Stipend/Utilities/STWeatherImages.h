//
//  STWeatherImages.h
//  Stipend
//
//  Created by Ganesh Kumar on 23/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STWeatherImages : NSObject

+ (UIImage *)getWeatherImageForIconName:(NSString *)iconName withType:(BOOL)isSmall;


@end
