//
//  STCLinksAndAddressesItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCLinksAndAddresses;

@interface STCLinksAndAddressesItem : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) STCLinksAndAddresses *linksAdnAddresses;

@end
