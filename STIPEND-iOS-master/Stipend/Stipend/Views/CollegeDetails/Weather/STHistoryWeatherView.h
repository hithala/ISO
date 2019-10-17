//
//  STHistoryWeatherView.h
//  Stipend
//
//  Created by Ganesh Kumar on 22/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STWeatherSegmentControl.h"


@interface STHistoryWeatherView : UIView<STWeatherSegmentControlDelegate>

@property (nonatomic, retain)  STCAverageWeather     *averageWeather;
@property (nonatomic, assign)  NSUInteger              selectedIndex;

@property (weak, nonatomic) IBOutlet UILabel *averageLowTempValue;
@property (weak, nonatomic) IBOutlet UILabel *averageHighTempValue;
@property (weak, nonatomic) IBOutlet UILabel *precipitationValue;


- (void)updateHistoryViewWithAverageDetails:(STCAverageWeather *)averageDetails;

@end
