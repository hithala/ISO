//
//  STFilterRangeItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STFilter;

@interface STFilterRangeItem : NSManagedObject

@property (nonatomic, retain) NSString * curLowerValue;
@property (nonatomic, retain) NSString * curUpperValue;
@property (nonatomic, retain) NSString * lowerValue;
@property (nonatomic, retain) NSString * rangeName;
@property (nonatomic, retain) NSString * upperValue;
@property (nonatomic, retain) STFilter *filter;

@end
