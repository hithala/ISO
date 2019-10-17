//
//  STDefaultCollege.h
//  
//
//  Created by Ganesh Kumar on 18/03/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STUser;

@interface STDefaultCollege : NSManagedObject

@property (nonatomic, retain) NSNumber * collegeID;
@property (nonatomic, retain) NSString * seenDate;
@property (nonatomic, retain) STUser *user;

@end
