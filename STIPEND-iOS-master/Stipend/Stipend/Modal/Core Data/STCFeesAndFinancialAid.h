//
//  STCFeesAndFinancialAid.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCInStateFees, STCOutStateFees;

@interface STCFeesAndFinancialAid : STCollegeSections

@property (nonatomic, retain) NSNumber * averageFinancialAid;
@property (nonatomic, retain) NSNumber * feesSelectedIndex;
@property (nonatomic, retain) NSNumber * receivingFinancialAid;
@property (nonatomic, retain) NSNumber * averageDebtUponGraduation;
@property (nonatomic, retain) NSNumber * averageNeedMet;
@property (nonatomic, retain) NSNumber * averageNetPrice;
@property (nonatomic, retain) NSNumber * averageMeritAward;
@property (nonatomic, retain) NSNumber * receivingMeritAwards;
@property (nonatomic, retain) NSOrderedSet *inStateFees;
@property (nonatomic, retain) NSOrderedSet *outStateFees;
@property (nonatomic, retain) NSOrderedSet *householdIncome;
@property (nonatomic, retain) NSNumber * hasSeeMore;
@property (nonatomic, retain) NSString * netPriceCalculatorURL;

@end

@interface STCFeesAndFinancialAid (CoreDataGeneratedAccessors)

- (void)insertObject:(STCInStateFees *)value inInStateFeesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromInStateFeesAtIndex:(NSUInteger)idx;
- (void)insertInStateFees:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeInStateFeesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInInStateFeesAtIndex:(NSUInteger)idx withObject:(STCInStateFees *)value;
- (void)replaceInStateFeesAtIndexes:(NSIndexSet *)indexes withInStateFees:(NSArray *)values;
- (void)addInStateFeesObject:(STCInStateFees *)value;
- (void)removeInStateFeesObject:(STCInStateFees *)value;
- (void)addInStateFees:(NSOrderedSet *)values;
- (void)removeInStateFees:(NSOrderedSet *)values;
- (void)insertObject:(STCOutStateFees *)value inOutStateFeesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOutStateFeesAtIndex:(NSUInteger)idx;
- (void)insertOutStateFees:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOutStateFeesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOutStateFeesAtIndex:(NSUInteger)idx withObject:(STCOutStateFees *)value;
- (void)replaceOutStateFeesAtIndexes:(NSIndexSet *)indexes withOutStateFees:(NSArray *)values;
- (void)addOutStateFeesObject:(STCOutStateFees *)value;
- (void)removeOutStateFeesObject:(STCOutStateFees *)value;
- (void)addOutStateFees:(NSOrderedSet *)values;
- (void)removeOutStateFees:(NSOrderedSet *)values;
@end
