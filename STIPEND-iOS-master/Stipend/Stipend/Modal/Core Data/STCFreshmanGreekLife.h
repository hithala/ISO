//
//  STCFreshmanGreekLife.h
//  
//
//  Created by Ganesh Kumar on 10/02/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCFreshman;

@interface STCFreshmanGreekLife : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) STCFreshman *freshman;

@end
