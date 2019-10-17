//
//  STBroadMajor.h
//  Stipend
//
//  Created by Ganesh Kumar on 10/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <CoreData/CoreData.h>

@class STFilter;

@interface STBroadMajor : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSOrderedSet *specificMajors;
@property (nonatomic, retain) STFilter *filter;
@property (nonatomic, retain) STCollege *college;

@end
