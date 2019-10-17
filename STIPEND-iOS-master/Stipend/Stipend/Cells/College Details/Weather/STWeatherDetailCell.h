//
//  STWeatherDetailCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 22/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface STWeatherDetailCell : UITableViewCell

@property (nonatomic, retain) STCAverageWeather    *averageWeatherDetails;

- (void)updateCellWithDetails:(STCWeather *)details;

@property (nonatomic, copy) void (^logoClickActionBlock)(void);

@end
