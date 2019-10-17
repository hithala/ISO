//
//  STLocationSearchItem.h
//  
//
//  Created by Ganesh Kumar on 07/03/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STUser;

@interface STLocationSearchItem : NSManagedObject

@property (nonatomic, retain) NSNumber * collegeID;
@property (nonatomic, retain) NSString * collegeLocation;
@property (nonatomic, retain) NSNumber * searchType;
@property (nonatomic, retain) STUser *user;

@end
