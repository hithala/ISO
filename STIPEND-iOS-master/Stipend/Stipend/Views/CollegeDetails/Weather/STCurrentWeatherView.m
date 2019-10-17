//
//  STCurrentWeatherView.m
//  Stipend
//
//  Created by Ganesh Kumar on 22/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCurrentWeatherView.h"
#import "STWeatherImages.h"

@implementation STCurrentWeatherView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) resetValues {
    
    self.day1ShortName.text = @"";
    self.day1WeatherIcon.image = [UIImage new];
    self.day1TempValue.text = @"";
    
    self.day2ShortName.text = @"";
    self.day2WeatherIcon.image = [UIImage new];
    self.day2TempValue.text = @"";
    
    self.day3ShortName.text = @"";
    self.day3WeatherIcon.image = [UIImage new];
    self.day3TempValue.text = @"";
    
    self.day4ShortName.text = @"";
    self.day4WeatherIcon.image = [UIImage new];
    self.day4TempValue.text = @"";
    
    self.day5ShortName.text = @"";
    self.day5WeatherIcon.image = [UIImage new];
    self.day5TempValue.text = @"";
    
}

- (void)fetchWeatherDetails:(STCAverageWeather *)averageWeather {
    
    STCollege *college = averageWeather.weather.college;
    
    double lattitude = [college.appleLattitude doubleValue];
    double longitude = [college.appleLongitude doubleValue];
    
    [[STNetworkAPIManager sharedManager] fetchWeatherDetailsForLattitude:lattitude andLongitude:longitude success:^(id response) {
        
        // Current weather details
        if([[response allKeys] containsObject:@"currently"]) {
            
            NSDictionary *currentWeatherDetails = [response objectForKey:@"currently"];
            
            if(![self isNullValueForObject:[currentWeatherDetails objectForKey:@"temperature"]]) {
                
                self.currentWeatherLabel.text = [NSString stringWithFormat:@"%.1f%@", [[currentWeatherDetails objectForKey:@"temperature"] floatValue], @"\u00B0"];
                self.currentWeatherDescription.text = [currentWeatherDetails objectForKey:@"summary"];
                self.currentWeatherIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"weather-l-%@", [currentWeatherDetails objectForKey:@"icon"]]];
            } else {
                
                self.currentWeatherLabel.text = @"";
                self.currentWeatherDescription.text = @"";
                self.currentWeatherIcon.image = [UIImage new];
            }
        }
        
        // Forecast details
        if([[response allKeys] containsObject:@"daily"]) {
            
            NSDictionary *forecastDict = [response objectForKey:@"daily"];
            
            NSArray *forecastdayArray = [forecastDict objectForKey:@"data"];

            NSInteger availableForecastCount = forecastdayArray.count > 5 ? 5 : forecastdayArray.count;
            
            // Reseting the existing values
            [self resetValues];

            for(int i = 0; i < availableForecastCount; i++) {
                
                NSDictionary *forecastdayDict = [forecastdayArray objectAtIndex:i];
                
                double timeStamp = [[forecastdayDict objectForKey:@"time"] doubleValue];
                
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
                NSDateFormatter* day = [[NSDateFormatter alloc] init];
                [day setDateFormat: @"E"];

                NSString *weekdayShortForm = [day stringFromDate:date];
                
                NSString *highTemp = [NSString stringWithFormat:@"%d", [[forecastdayDict objectForKey:@"temperatureHigh"] intValue]];
                NSString *weatherIconName = [forecastdayDict objectForKey:@"icon"];

                UIImage *weatherImage = [UIImage imageNamed:[NSString stringWithFormat:@"weather-%@", weatherIconName]];
                
                int index = i + 1;
                
                switch (index) {
                    case 1: {
                        self.day1ShortName.text = [weekdayShortForm uppercaseString];
                        self.day1WeatherIcon.image = weatherImage;
                        self.day1TempValue.text = [NSString stringWithFormat:@"%@%@", highTemp, @"\u00B0"];
                    }
                        break;
                    case 2: {
                        self.day2ShortName.text = [weekdayShortForm uppercaseString];
                        self.day2WeatherIcon.image = weatherImage;
                        self.day2TempValue.text = [NSString stringWithFormat:@"%@%@", highTemp, @"\u00B0"];
                    }
                        break;
                    case 3: {
                        self.day3ShortName.text = [weekdayShortForm uppercaseString];
                        self.day3WeatherIcon.image = weatherImage;
                        self.day3TempValue.text = [NSString stringWithFormat:@"%@%@", highTemp, @"\u00B0"];
                    }
                        break;
                    case 4: {
                        self.day4ShortName.text = [weekdayShortForm uppercaseString];
                        self.day4WeatherIcon.image = weatherImage;
                        self.day4TempValue.text = [NSString stringWithFormat:@"%@%@", highTemp, @"\u00B0"];
                    }
                        break;
                    case 5: {
                        self.day5ShortName.text = [weekdayShortForm uppercaseString];
                        self.day5WeatherIcon.image = weatherImage;
                        self.day5TempValue.text = [NSString stringWithFormat:@"%@%@", highTemp, @"\u00B0"];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    } failure:^(NSError *error) {
        STLog(@"error %@", error);
    }];
}

- (IBAction) onLogoClick:(id)sender {
    
    if(self.logoClickActionBlock != nil) {
        self.logoClickActionBlock();
    }
}

- (BOOL) isNullValueForObject:(id) object {
    
    if(object && (![object isEqual:[NSNull null]])) {
        return NO;
    }
    
    return YES;
}

@end
