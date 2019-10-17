//
//  STHistoryWeatherView.m
//  Stipend
//
//  Created by Ganesh Kumar on 22/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STHistoryWeatherView.h"

#define WEATHER_TOGGLE_STATE_TAG           700


@implementation STHistoryWeatherView

- (void) awakeFromNib {

    [super awakeFromNib];
}

- (void)updateHistoryViewWithAverageDetails:(STCAverageWeather *)averageDetails {
    
    self.selectedIndex = 0;
    self.averageWeather = averageDetails;
    [self updateHistoryView];
}

- (void)updateHistoryView {
    
    STWeatherSegmentControl *segmentControl = (STWeatherSegmentControl *)[self viewWithTag:(WEATHER_TOGGLE_STATE_TAG)];
    
    if(!segmentControl) {
        segmentControl = [[STWeatherSegmentControl alloc] initWithFrame:CGRectZero];
        segmentControl.delegate = self;
        segmentControl.tag = WEATHER_TOGGLE_STATE_TAG;
        [self addSubview:segmentControl];
    }
    
    NSMutableArray *itemArray = [self getItemsFromWeatherList:self.averageWeather];
    
    segmentControl.frame = CGRectMake(10.0, 15.0, self.frame.size.width - 30.0, 70.0);
    [segmentControl setSelectedIndex:self.selectedIndex];
    [segmentControl updateSegmentControlWithItems:itemArray];
    
    if(self.averageWeather.averageWeatherItems.count > 0) {
        STCAverageWeatherItem *item = [self.averageWeather.averageWeatherItems objectAtIndex:self.selectedIndex];
        
        self.averageLowTempValue.text = [NSString stringWithFormat:@"%@%@", item.lowValue, @"\u00B0"];
        self.averageHighTempValue.text = [NSString stringWithFormat:@"%@%@", item.highValue, @"\u00B0"];
        
        if([item.precipitationValue integerValue] == 1) {
            self.precipitationValue.text = [NSString stringWithFormat:@"%@ inch", item.precipitationValue];
        }
        else {
            self.precipitationValue.text = [NSString stringWithFormat:@"%@ inches", item.precipitationValue];
        }

    }
    else {
        self.averageLowTempValue.text = @"-";
        self.averageHighTempValue.text = @"-";
        self.precipitationValue.text = @"-";
    }
}

- (NSMutableArray *) getItemsFromWeatherList:(STCAverageWeather *) averageDetails {
    
    NSOrderedSet *averageWeatherSet = averageDetails.averageWeatherItems;
    
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [averageWeatherSet count]; i++) {
        NSMutableDictionary *details = [NSMutableDictionary dictionary];
        STCAverageWeatherItem *item = [averageWeatherSet objectAtIndex:i];
        [details setObject:item.title forKey:@"kName"];
        [details setObject:item.imageName forKey:@"kImageName"];
        [valueArray addObject:details];
    }
    
    return valueArray;
}

- (void) didClickSegmentAtIndex:(NSUInteger) index {
    self.selectedIndex = index;
    [self updateHistoryView];
}

- (void)dealloc {
    
    self.averageWeather = nil;
}

@end
