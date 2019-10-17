//
//  STWeatherImages.m
//  Stipend
//
//  Created by Ganesh Kumar on 23/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STWeatherImages.h"


@implementation STWeatherImages

+ (NSDictionary *)getWeatherSmallImagesDataSourceWithType:(BOOL)issmall {
    
    
    NSMutableDictionary *weatherImagesDict = [NSMutableDictionary dictionary];
    NSString *baseName;
    
    if(issmall) {
        baseName = @"weather";
    } else {
        baseName = @"weather-l";
    }
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-rain", baseName] forKey:@"Rain"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-rain", baseName] forKey:@"Freezing Rain"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-rain", baseName] forKey:@"Unknown Precipitation"];

    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-drizzle", baseName] forKey:@"Drizzle"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-drizzle", baseName] forKey:@"Freezing Drizzle"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-haze", baseName] forKey:@"Haze"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-mist", baseName] forKey:@"Mist"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-rain-mist", baseName] forKey:@"Rain Mist"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-partly-cloudy", baseName] forKey:@"Scattered Clouds"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-partly-cloudy", baseName] forKey:@"Mostly Cloudy"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-partly-cloudy", baseName] forKey:@"Partly Cloudy"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-hail", baseName] forKey:@"Hail"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-hail", baseName] forKey:@"Ice Pellet Showers"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-hail", baseName] forKey:@"Small Hail"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-hail-showers", baseName] forKey:@"Small Hail Showers"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-hail-showers", baseName] forKey:@"Hail Showers"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-snow", baseName] forKey:@"Ice Pellets"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-snow", baseName] forKey:@"Ice Crystals"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-snow", baseName] forKey:@"Snow Grains"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-snow", baseName] forKey:@"Snow"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-snow", baseName] forKey:@"Low Drifting Sand"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-snow", baseName] forKey:@"Low Drifting Snow"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Sand"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Widespread Dust"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Volcanic Ash"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Smoke"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Sandstorm"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Dust Whirls"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Spray"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Fog"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Freezing Fog"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Snow Blowing Snow Mist"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Blowing Sand"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Blowing Widespread Dust"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Blowing Snow"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog", baseName] forKey:@"Low Drifting Widespread Dust"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog-patch", baseName] forKey:@"Partial Fog"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog-patch", baseName] forKey:@"Shallow Fog"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog-patch", baseName] forKey:@"Patches of Fog"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-fog-patch", baseName] forKey:@"Fog Patches"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-storm", baseName] forKey:@"Thunderstorms with Small Hail"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-storm", baseName] forKey:@"Thunderstorms with Hail"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-storm", baseName] forKey:@"Thunderstorms and Ice Pellets"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-storm", baseName] forKey:@"Thunderstorms and Snow"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-storm", baseName] forKey:@"Thunderstorms and Rain"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-storm", baseName] forKey:@"Thunderstorms"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-storm", baseName] forKey:@"Chance of a Thunderstorm"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-funnel-cloud", baseName] forKey:@"Funnel Cloud"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-squalls", baseName] forKey:@"Squalls"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-sun", baseName] forKey:@"Clear"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-cloud", baseName] forKey:@"Overcast"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-snow-showers", baseName] forKey:@"Snow Showers"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-rain-showers", baseName] forKey:@"Rain Showers"];
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-rain-showers", baseName] forKey:@"Chance of Rain"];
    
    [weatherImagesDict setObject:[NSString stringWithFormat:@"%@-unknown", baseName] forKey:@"Unknown"];
   
    return weatherImagesDict;
}


+ (UIImage *)getWeatherImageForIconName:(NSString *)iconName withType:(BOOL)isSmall {
    
    UIImage *weatherImage;
    
   // NSDictionary *imagesDict = [self getWeatherSmallImagesDataSourceWithType:isSmall];
    
    NSDictionary *weatherDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WeatherImages" ofType:@"plist"]];
    
    NSDictionary *imagesDict;
    
    if(isSmall) {
        imagesDict = [NSDictionary dictionaryWithDictionary:[weatherDict objectForKey:@"SmallImages"]];
    } else {
        imagesDict = [NSDictionary dictionaryWithDictionary:[weatherDict objectForKey:@"LargeImages"]];
    }
    
    if([[imagesDict allKeys] containsObject:iconName]) {
        weatherImage = [UIImage imageNamed:[imagesDict objectForKey:iconName]];
    } else {
        weatherImage = [UIImage imageNamed:[imagesDict objectForKey:@"Unknown"]];
    }
    
    return weatherImage;
}

@end
