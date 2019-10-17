//
//  STUserManager.h
//  Stipend
//
//  Created by Ganesh Kumar on 08/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STUser.h"
#import "STSections.h"
#import "STSectionItem.h"

@interface STUserManager : NSObject

@property (nonatomic,assign) BOOL   hasLoadedCollegeList;
@property (nonatomic,assign) BOOL        isFilterApplied;
@property (nonatomic,assign) BOOL       shouldReloadData;
@property (nonatomic,retain) NSDate     *lastUpdatedDate;

@property (nonatomic,assign) BOOL favoritesUpdates;
@property (nonatomic,assign) BOOL compareUpdates;
@property (nonatomic,assign) BOOL clippingsUpdate;
@property (nonatomic,assign) BOOL filterUpdate;

+ (STUserManager *)sharedManager;

- (NSString *) userID;
- (STUser *) getCurrentUserInDefaultContext;
- (STUser *) getCurrentUserInContext:(NSManagedObjectContext *)localContext;

- (void)setDefaultCollegeSectionsForCurrentUserIfNeeded;

- (BOOL) isGuestUser;
- (NSNumber *) loginType;

- (void)resetFilterWithCompletion:(void(^)(BOOL contextDidSave))completion;


@end
