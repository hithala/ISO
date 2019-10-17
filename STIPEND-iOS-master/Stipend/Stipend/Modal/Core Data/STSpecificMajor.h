//
//  STSpecificMajor.h
//  Stipend
//
//  Created by Ganesh Kumar on 10/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <CoreData/CoreData.h>

@class STBroadMajor;

@interface STSpecificMajor : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * studentCount;
@property (nonatomic, retain) STBroadMajor *broadMajor;

@end
