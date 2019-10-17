//
//  STUserManager.m
//  Stipend
//
//  Created by Ganesh Kumar on 08/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STUserManager.h"
#import "STFilter.h"


@implementation STUserManager

+ (STUserManager *) sharedManager {
    
    static STUserManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[STUserManager alloc] init];
    });
    
    return sharedManager;
}

- (id)init {
    
    if(self == [super init]) {
        self.isFilterApplied = NO;
    }
    
    return self;
}

- (STUser *) getCurrentUserInDefaultContext {
    
    NSString *userID = [self userID];
    
    if(userID) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@",userID];
        STUser *localUser = [STUser MR_findFirstWithPredicate:predicate];
        
        if(localUser) {
            return localUser;
        }
    }
    
    return nil;
}

- (STUser *)getCurrentUserInContext:(NSManagedObjectContext *)localContext {
    
    NSString *userID = [self userID];
    
    if(userID) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@",userID];
        STUser *localUser = [STUser MR_findFirstWithPredicate:predicate inContext:localContext];
        
        if(localUser) {
            return localUser;
        }
    }
    
    return nil;
}

- (NSString *) userID {
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    if(userID) {
        return userID;
    }
    
    return nil;
}

- (NSNumber *) loginType {
    
    NSNumber *loginType = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE];
    if(loginType) {
        return loginType;
    }
    
    return nil;
}


- (BOOL) isGuestUser {

    NSInteger loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] integerValue];

    if(loginType == eLoginTypeGuest) {
        return YES;
    }
    
    return NO;
}

- (void)setDefaultCollegeSectionsForCurrentUserIfNeeded {
    
    STUser *currentUser = [self getCurrentUserInDefaultContext];
    
    NSOrderedSet *collegeSections = currentUser.sections;
    
    if(collegeSections.count == 0) {
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
            
            NSDictionary *sectionDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CollegeSections" ofType:@"plist"]];
            NSArray *sectionArray = [sectionDict objectForKey:@"Sections"];

            @autoreleasepool {
                
                NSMutableOrderedSet *sectionItemsSet = [NSMutableOrderedSet orderedSet];
                
                for (NSDictionary *details in sectionArray) {
                    
                    NSString *sectionName = [details objectForKey:@"sectionName"];
                    NSNumber *sectionID = [details objectForKey:@"sectionID"];
                    NSString *imageName = [details objectForKey:@"imageName"];
                    
                    STSections *localSection = nil;
                    
                    if(!localSection) {
                        localSection = [STSections MR_createEntityInContext:localContext];
                        localSection.index = [details objectForKey:@"index"];
                        
                        STSectionItem *sectionItem = [STSectionItem MR_createEntityInContext:localContext];
                        
                        sectionItem.sectionID = sectionID;
                        sectionItem.sectionTitle = sectionName;
                        sectionItem.imageName = imageName;
                        
                        localSection.sectionItem = sectionItem;
                        localSection.user = localUser;
                        
                        [sectionItemsSet addObject:localSection];
                    }
                }
                
                if(sectionItemsSet && ([sectionItemsSet count] > 0)) {
                    localUser.sections = sectionItemsSet;
                }
            }
        }];
    }
}

- (void)resetFilterWithCompletion:(void (^)(BOOL))completion {
    
    self.isFilterApplied = NO;
    self.shouldReloadData = YES;
    
    STFilter *filterModel = [STFilter MR_findFirst];
    
    if (filterModel != nil) {
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            STFilter *localFilter = [filterModel MR_inContext:localContext];
            [localFilter MR_deleteEntityInContext:localContext];

        } completion:^(BOOL contextDidSave, NSError *error) {
            if(completion) {
                completion(YES);
            }
        }];
        
    }
    else {
        if(completion) {
            completion(YES);
        }
    }
}

@end
