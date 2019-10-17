//
//  STCRankingItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCRankings;

@interface STCRankingItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * rankingURL;
@property (nonatomic, retain) STCRankings *collegeRanking;

@end
