//
//  STCAverageWeatherItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCAverageWeather;

@interface STCAverageWeatherItem : NSManagedObject

@property (nonatomic, retain) NSNumber * highValue;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * lowValue;
@property (nonatomic, retain) NSNumber * precipitationValue;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) STCAverageWeather *averageWeather;

@end
