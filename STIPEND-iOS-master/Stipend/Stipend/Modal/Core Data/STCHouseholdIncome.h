//
//  STCHouseholdIncome.h
//  Stipend
//
//  Created by Ganesh kumar on 04/07/18.
//  Copyright (c) 2018 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCFeesAndFinancialAid;

@interface STCHouseholdIncome : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) STCFeesAndFinancialAid *feesAndFinancialAid;

@end
