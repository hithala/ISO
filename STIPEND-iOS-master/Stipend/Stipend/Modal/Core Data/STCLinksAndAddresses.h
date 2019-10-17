//
//  STCLinksAndAddresses.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCLinksAndAddressesItem;

@interface STCLinksAndAddresses : STCollegeSections

@property (nonatomic, retain) NSOrderedSet *linksAndAddressesItems;
@end

@interface STCLinksAndAddresses (CoreDataGeneratedAccessors)

- (void)insertObject:(STCLinksAndAddressesItem *)value inLinksAndAddressesItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLinksAndAddressesItemsAtIndex:(NSUInteger)idx;
- (void)insertLinksAndAddressesItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLinksAndAddressesItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLinksAndAddressesItemsAtIndex:(NSUInteger)idx withObject:(STCLinksAndAddressesItem *)value;
- (void)replaceLinksAndAddressesItemsAtIndexes:(NSIndexSet *)indexes withLinksAndAddressesItems:(NSArray *)values;
- (void)addLinksAndAddressesItemsObject:(STCLinksAndAddressesItem *)value;
- (void)removeLinksAndAddressesItemsObject:(STCLinksAndAddressesItem *)value;
- (void)addLinksAndAddressesItems:(NSOrderedSet *)values;
- (void)removeLinksAndAddressesItems:(NSOrderedSet *)values;
@end
