//
//  STCBarChartItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCTestScoresBarChart;

@interface STCBarChartItem : NSManagedObject

@property (nonatomic, retain) NSNumber * lowerValue;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * upperValue;
@property (nonatomic, retain) NSNumber * newUpperValue;
@property (nonatomic, retain) NSNumber * newLowerValue;
@property (nonatomic, retain) STCTestScoresBarChart *testScoreBarChart;

@end
