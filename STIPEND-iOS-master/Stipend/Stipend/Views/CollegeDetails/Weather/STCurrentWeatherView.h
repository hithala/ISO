//
//  STCurrentWeatherView.h
//  Stipend
//
//  Created by Ganesh Kumar on 22/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCurrentWeatherView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *currentWeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *currentWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentWeatherDescription;


@property (weak, nonatomic) IBOutlet UILabel *day1ShortName;
@property (weak, nonatomic) IBOutlet UIImageView *day1WeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *day1TempValue;

@property (weak, nonatomic) IBOutlet UILabel *day2ShortName;
@property (weak, nonatomic) IBOutlet UIImageView *day2WeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *day2TempValue;

@property (weak, nonatomic) IBOutlet UILabel *day3ShortName;
@property (weak, nonatomic) IBOutlet UIImageView *day3WeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *day3TempValue;

@property (weak, nonatomic) IBOutlet UILabel *day4ShortName;
@property (weak, nonatomic) IBOutlet UIImageView *day4WeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *day4TempValue;

@property (weak, nonatomic) IBOutlet UILabel *day5ShortName;
@property (weak, nonatomic) IBOutlet UIImageView *day5WeatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *day5TempValue;


- (void)fetchWeatherDetails:(STCAverageWeather *)averageWeather;
- (IBAction)onLogoClick:(id)sender;

@property (nonatomic, copy) void (^logoClickActionBlock)(void);

@end
