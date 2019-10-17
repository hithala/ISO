//
//  STCollege.h
//  
//
//  Created by Ganesh Kumar on 13/04/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCollegeSections;

@interface STCollege : NSManagedObject

@property (nonatomic, retain) NSNumber * acceptanceRate;
@property (nonatomic, retain) NSNumber * fourYrGraduationRate;
@property (nonatomic, retain) NSNumber * sixYrGraduationRate;
@property (nonatomic, retain) NSNumber * oneYrRetentionRate;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * appleLattitude;
@property (nonatomic, retain) NSString * appleLongitude;
@property (nonatomic, retain) NSNumber * averageACT;
@property (nonatomic, retain) NSNumber * averageGPA;
@property (nonatomic, retain) NSNumber * averageSAT;
@property (nonatomic, retain) NSNumber * averageSATNew;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * classSize;
@property (nonatomic, retain) NSNumber * collegeAccessType;
@property (nonatomic, retain) NSNumber * collegeAreaType;
@property (nonatomic, retain) NSNumber * collegeID;
@property (nonatomic, retain) NSString * collegeName;
@property (nonatomic, retain) NSNumber * collegeType;
@property (nonatomic, retain) NSNumber * commonApplicationAccepted;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * earlyAction;
@property (nonatomic, retain) NSNumber * earlyDecision;
@property (nonatomic, retain) NSString * emailID;
@property (nonatomic, retain) NSString * googleLattitude;
@property (nonatomic, retain) NSString * googleLongitude;
@property (nonatomic, retain) NSNumber * isAddedToCompare;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSDate * lastUpdatedDate;
@property (nonatomic, retain) NSString * logoPath;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSNumber * receivingFinancialAid;
@property (nonatomic, retain) NSNumber * rollingAdmissions;
@property (nonatomic, retain) NSNumber * shouldUpdate;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * streetName;
@property (nonatomic, retain) NSString * telephoneNumber;
@property (nonatomic, retain) NSNumber * totalFees;
@property (nonatomic, retain) NSNumber * totalFreshmens;
@property (nonatomic, retain) NSNumber * totalUndergrads;
@property (nonatomic, retain) NSString * websiteUrl;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * religiousAffiliation;
@property (nonatomic, retain) NSNumber * testOptional;
@property (nonatomic, retain) NSOrderedSet *collegeSections;
@property (nonatomic, retain) NSOrderedSet *broadMajors;

@end

@interface STCollege (CoreDataGeneratedAccessors)

- (void)insertObject:(STCollegeSections *)value inCollegeSectionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCollegeSectionsAtIndex:(NSUInteger)idx;
- (void)insertCollegeSections:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCollegeSectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCollegeSectionsAtIndex:(NSUInteger)idx withObject:(STCollegeSections *)value;
- (void)replaceCollegeSectionsAtIndexes:(NSIndexSet *)indexes withCollegeSections:(NSArray *)values;
- (void)addCollegeSectionsObject:(STCollegeSections *)value;
- (void)removeCollegeSectionsObject:(STCollegeSections *)value;
- (void)addCollegeSections:(NSOrderedSet *)values;
- (void)removeCollegeSections:(NSOrderedSet *)values;
@end
