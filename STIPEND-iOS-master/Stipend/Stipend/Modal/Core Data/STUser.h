//
//  STUser.h
//  
//
//  Created by Ganesh Kumar on 13/04/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STClippingsItem, STCompareItem, STDefaultCollege, STFavorites, STLocationSearchItem, STRecentSearchItem, STSections;

@interface STUser : NSManagedObject

@property (nonatomic, retain) NSNumber * defaultMapAppType;
@property (nonatomic, retain) NSString * emailID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * genderType;
@property (nonatomic, retain) NSString * imageurl;
@property (nonatomic, retain) NSNumber * isAdmin;
@property (nonatomic, retain) NSNumber * isCompareItemPurchased;
@property (nonatomic, retain) NSNumber * isCompareTutorialSwiped;
@property (nonatomic, retain) NSNumber * isDisclaimerAccepted;
@property (nonatomic, retain) NSNumber * isFilterItemPurchased;
@property (nonatomic, retain) NSNumber * isTutorialViewSwiped;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * lastSeenCollege;
@property (nonatomic, retain) NSNumber * pushNotificationState;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * userType;
@property (nonatomic, retain) NSOrderedSet *clippings;
@property (nonatomic, retain) NSOrderedSet *compareItems;
@property (nonatomic, retain) STDefaultCollege *defaultCollege;
@property (nonatomic, retain) NSOrderedSet *favorites;
@property (nonatomic, retain) NSOrderedSet *locationSearch;
@property (nonatomic, retain) NSOrderedSet *recentSearch;
@property (nonatomic, retain) NSOrderedSet *sections;
@end

@interface STUser (CoreDataGeneratedAccessors)

- (void)insertObject:(STClippingsItem *)value inClippingsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromClippingsAtIndex:(NSUInteger)idx;
- (void)insertClippings:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeClippingsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInClippingsAtIndex:(NSUInteger)idx withObject:(STClippingsItem *)value;
- (void)replaceClippingsAtIndexes:(NSIndexSet *)indexes withClippings:(NSArray *)values;
- (void)addClippingsObject:(STClippingsItem *)value;
- (void)removeClippingsObject:(STClippingsItem *)value;
- (void)addClippings:(NSOrderedSet *)values;
- (void)removeClippings:(NSOrderedSet *)values;
- (void)insertObject:(STCompareItem *)value inCompareItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCompareItemsAtIndex:(NSUInteger)idx;
- (void)insertCompareItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCompareItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCompareItemsAtIndex:(NSUInteger)idx withObject:(STCompareItem *)value;
- (void)replaceCompareItemsAtIndexes:(NSIndexSet *)indexes withCompareItems:(NSArray *)values;
- (void)addCompareItemsObject:(STCompareItem *)value;
- (void)removeCompareItemsObject:(STCompareItem *)value;
- (void)addCompareItems:(NSOrderedSet *)values;
- (void)removeCompareItems:(NSOrderedSet *)values;
- (void)insertObject:(STFavorites *)value inFavoritesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFavoritesAtIndex:(NSUInteger)idx;
- (void)insertFavorites:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFavoritesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFavoritesAtIndex:(NSUInteger)idx withObject:(STFavorites *)value;
- (void)replaceFavoritesAtIndexes:(NSIndexSet *)indexes withFavorites:(NSArray *)values;
- (void)addFavoritesObject:(STFavorites *)value;
- (void)removeFavoritesObject:(STFavorites *)value;
- (void)addFavorites:(NSOrderedSet *)values;
- (void)removeFavorites:(NSOrderedSet *)values;
- (void)insertObject:(STLocationSearchItem *)value inLocationSearchAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLocationSearchAtIndex:(NSUInteger)idx;
- (void)insertLocationSearch:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLocationSearchAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLocationSearchAtIndex:(NSUInteger)idx withObject:(STLocationSearchItem *)value;
- (void)replaceLocationSearchAtIndexes:(NSIndexSet *)indexes withLocationSearch:(NSArray *)values;
- (void)addLocationSearchObject:(STLocationSearchItem *)value;
- (void)removeLocationSearchObject:(STLocationSearchItem *)value;
- (void)addLocationSearch:(NSOrderedSet *)values;
- (void)removeLocationSearch:(NSOrderedSet *)values;
- (void)insertObject:(STRecentSearchItem *)value inRecentSearchAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecentSearchAtIndex:(NSUInteger)idx;
- (void)insertRecentSearch:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecentSearchAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecentSearchAtIndex:(NSUInteger)idx withObject:(STRecentSearchItem *)value;
- (void)replaceRecentSearchAtIndexes:(NSIndexSet *)indexes withRecentSearch:(NSArray *)values;
- (void)addRecentSearchObject:(STRecentSearchItem *)value;
- (void)removeRecentSearchObject:(STRecentSearchItem *)value;
- (void)addRecentSearch:(NSOrderedSet *)values;
- (void)removeRecentSearch:(NSOrderedSet *)values;
- (void)insertObject:(STSections *)value inSectionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSectionsAtIndex:(NSUInteger)idx;
- (void)insertSections:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSectionsAtIndex:(NSUInteger)idx withObject:(STSections *)value;
- (void)replaceSectionsAtIndexes:(NSIndexSet *)indexes withSections:(NSArray *)values;
- (void)addSectionsObject:(STSections *)value;
- (void)removeSectionsObject:(STSections *)value;
- (void)addSections:(NSOrderedSet *)values;
- (void)removeSections:(NSOrderedSet *)values;
@end
