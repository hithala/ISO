//
//  STCFreshman.h
//  
//
//  Created by Ganesh Kumar on 10/02/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCFreshmanDetailItem, STCFreshmanGenderDetails, STCFreshmanGreekLife, STCFreshmanRepresentedStates, STCPieChart, STCFreshmanGraduationDetails;

@interface STCFreshman : STCollegeSections

@property (nonatomic, retain) NSString * religiousAffiliation;
@property (nonatomic, retain) NSOrderedSet *freshmanDetailItems;
@property (nonatomic, retain) NSOrderedSet *freshmanMostRepresentedStates;
@property (nonatomic, retain) STCFreshmanGenderDetails *genderDetails;
@property (nonatomic, retain) NSOrderedSet *pieCharts;
@property (nonatomic, retain) NSOrderedSet *freshmanGreekLife;
@property (nonatomic, retain) STCFreshmanGraduationDetails *graduationDetails;
@end

@interface STCFreshman (CoreDataGeneratedAccessors)

- (void)insertObject:(STCFreshmanDetailItem *)value inFreshmanDetailItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFreshmanDetailItemsAtIndex:(NSUInteger)idx;
- (void)insertFreshmanDetailItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFreshmanDetailItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFreshmanDetailItemsAtIndex:(NSUInteger)idx withObject:(STCFreshmanDetailItem *)value;
- (void)replaceFreshmanDetailItemsAtIndexes:(NSIndexSet *)indexes withFreshmanDetailItems:(NSArray *)values;
- (void)addFreshmanDetailItemsObject:(STCFreshmanDetailItem *)value;
- (void)removeFreshmanDetailItemsObject:(STCFreshmanDetailItem *)value;
- (void)addFreshmanDetailItems:(NSOrderedSet *)values;
- (void)removeFreshmanDetailItems:(NSOrderedSet *)values;
- (void)insertObject:(STCFreshmanRepresentedStates *)value inFreshmanMostRepresentedStatesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFreshmanMostRepresentedStatesAtIndex:(NSUInteger)idx;
- (void)insertFreshmanMostRepresentedStates:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFreshmanMostRepresentedStatesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFreshmanMostRepresentedStatesAtIndex:(NSUInteger)idx withObject:(STCFreshmanRepresentedStates *)value;
- (void)replaceFreshmanMostRepresentedStatesAtIndexes:(NSIndexSet *)indexes withFreshmanMostRepresentedStates:(NSArray *)values;
- (void)addFreshmanMostRepresentedStatesObject:(STCFreshmanRepresentedStates *)value;
- (void)removeFreshmanMostRepresentedStatesObject:(STCFreshmanRepresentedStates *)value;
- (void)addFreshmanMostRepresentedStates:(NSOrderedSet *)values;
- (void)removeFreshmanMostRepresentedStates:(NSOrderedSet *)values;
- (void)insertObject:(STCPieChart *)value inPieChartsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPieChartsAtIndex:(NSUInteger)idx;
- (void)insertPieCharts:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePieChartsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPieChartsAtIndex:(NSUInteger)idx withObject:(STCPieChart *)value;
- (void)replacePieChartsAtIndexes:(NSIndexSet *)indexes withPieCharts:(NSArray *)values;
- (void)addPieChartsObject:(STCPieChart *)value;
- (void)removePieChartsObject:(STCPieChart *)value;
- (void)addPieCharts:(NSOrderedSet *)values;
- (void)removePieCharts:(NSOrderedSet *)values;
- (void)insertObject:(STCFreshmanGreekLife *)value inFreshmanGreekLifeAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFreshmanGreekLifeAtIndex:(NSUInteger)idx;
- (void)insertFreshmanGreekLife:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFreshmanGreekLifeAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFreshmanGreekLifeAtIndex:(NSUInteger)idx withObject:(STCFreshmanGreekLife *)value;
- (void)replaceFreshmanGreekLifeAtIndexes:(NSIndexSet *)indexes withFreshmanGreekLife:(NSArray *)values;
- (void)addFreshmanGreekLifeObject:(STCFreshmanGreekLife *)value;
- (void)removeFreshmanGreekLifeObject:(STCFreshmanGreekLife *)value;
- (void)addFreshmanGreekLife:(NSOrderedSet *)values;
- (void)removeFreshmanGreekLife:(NSOrderedSet *)values;
@end
