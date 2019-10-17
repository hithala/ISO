//
//  STWeatherDetailCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 22/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STWeatherDetailCell.h"
#import "STCurrentWeatherView.h"
#import "STHistoryWeatherView.h"

#define CURRENT_WEATHER_TAG             100
#define HISTORY_WEATHER_TAG             200

@implementation STWeatherDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithDetails:(STCWeather *)details {
    
    self.averageWeatherDetails = details.averageWeather;
    [self updateWeatherDetails];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateWeatherDetails];
}

- (void)updateWeatherDetails {
    
    STCurrentWeatherView *currentWeatherView = (STCurrentWeatherView *)[self viewWithTag:CURRENT_WEATHER_TAG];
    
    if(!currentWeatherView) {
        
        currentWeatherView = [[NSBundle mainBundle] loadNibNamed:@"STCurrentWeatherView" owner:self options:nil][0];
        currentWeatherView.tag = CURRENT_WEATHER_TAG;
        currentWeatherView.backgroundColor = [UIColor clearColor];
        currentWeatherView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 310.0);
        [self.contentView addSubview:currentWeatherView];
    } else {
        currentWeatherView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 310.0);
    }
    
    [currentWeatherView fetchWeatherDetails:self.averageWeatherDetails];
    
    currentWeatherView.logoClickActionBlock = ^{
        if(self.logoClickActionBlock != nil) {
            self.logoClickActionBlock();
        }
    };

    STHistoryWeatherView *historyWeatherView = (STHistoryWeatherView *)[self viewWithTag:HISTORY_WEATHER_TAG];
    
    if(!historyWeatherView) {
        
        historyWeatherView = [[NSBundle mainBundle] loadNibNamed:@"STHistoryWeatherView" owner:self options:nil][0];
        historyWeatherView.tag = HISTORY_WEATHER_TAG;
        currentWeatherView.backgroundColor = [UIColor clearColor];
        historyWeatherView.frame = CGRectMake(0.0, 310.0, self.frame.size.width, 180.0);
        [self.contentView addSubview:historyWeatherView];
    } else {
        historyWeatherView.frame = CGRectMake(0.0, 310.0, self.frame.size.width, 180.0);
    }
    
    [historyWeatherView updateHistoryViewWithAverageDetails:self.averageWeatherDetails];
}

@end
