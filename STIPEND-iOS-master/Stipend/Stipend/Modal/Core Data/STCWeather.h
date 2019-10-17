//
//  STCWeather.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCAverageWeather;

@interface STCWeather : STCollegeSections

@property (nonatomic, retain) STCAverageWeather *averageWeather;

@end
