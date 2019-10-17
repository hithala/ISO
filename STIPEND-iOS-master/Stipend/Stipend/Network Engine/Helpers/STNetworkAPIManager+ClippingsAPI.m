//
//  STNetworkAPIManager+ClippingsAPI.m
//  Stipend
//
//  Created by Arun S on 28/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager+ClippingsAPI.h"
#import "STClippingsItem.h"
#import "STClippingSectionItem.h"

@implementation STNetworkAPIManager (ClippingsAPI)

- (void) getClippingsForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {

    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    if(![[STUserManager sharedManager] isGuestUser]) {
        
        __weak STNetworkAPIManager *weakSelf = self;

        [self GET:[NSString stringWithFormat:@"getClipping/%@", userID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf updateClippingsDetailsToCoreDataWithDetails:responseObject forResponseType:eResponseTypeAllClippings success:successBlock failure:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
            failureBlock(error);
        }];
    }
    else {
        [self updateClippingsDetailsToCoreDataWithDetails:nil forResponseType:eResponseTypeAllClippings success:successBlock failure:failureBlock];
    }
}

- (void) addCollegeSectionToClippingsWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND sectionID == %@", [details objectForKey:kCollegeID],[details objectForKey:KEY_SECTION_ID]];

    STClippingSectionItem *sectionItem = [STClippingSectionItem MR_findFirstWithPredicate:predicate];
    
    if(!sectionItem) {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
        [parameters setObject:[NSNumber numberWithBool:NO] forKey:kIsSync];
        
        NSMutableArray *clippings = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[details objectForKey:kCollegeID] forKey:kCollegeID];
        [dict setObject:[details objectForKey:KEY_SECTION_NAME] forKey:kSections];
        [clippings addObject:dict];
        
        [parameters setObject:clippings forKey:kClippings];
        
        __weak STNetworkAPIManager *weakSelf = self;
        
        [self POST:@"addClipping" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf updateClippingsDetailsToCoreDataWithDetails:details forResponseType:eResponseTypeAddToClippings success:successBlock failure:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
            failureBlock(error);
        }];
    } else {
        successBlock([NSNull null]);
    }
}

- (void) removeCollegeSectionFromClippingsWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
 
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
    [parameters setObject:[details objectForKey:kCollegeID] forKey:kCollegeID];
    [parameters setObject:[details objectForKey:KEY_SECTION_NAME] forKey:kSection];

    __weak STNetworkAPIManager *weakSelf = self;

    [self POST:@"deleteClipping" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf updateClippingsDetailsToCoreDataWithDetails:details forResponseType:eResponseTypeRemoveFromClippings success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) updateClippingsForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
    [parameters setObject:[NSNumber numberWithBool:YES] forKey:kIsSync];

    NSMutableOrderedSet *clippingItems = [[currentUser clippings] mutableCopy];

    NSMutableArray *clippings = [[NSMutableArray alloc] init];

    for(STClippingsItem *clippingItem in clippingItems) {
        
        NSMutableArray *sections = [[NSMutableArray alloc] init];
        for(STClippingSectionItem *sectionItem in clippingItem.clippingSections) {
            [sections addObject:sectionItem.sectionTitle];
        }

        NSString *sectionsString = [sections componentsJoinedByString:@","];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:clippingItem.collegeID forKey:kCollegeID];
        [dict setObject:sectionsString forKey:kSections];
        [clippings addObject:dict];
    }

    [parameters setObject:clippings forKey:kClippings];
    
    __weak STNetworkAPIManager *weakSelf = self;
    
    [self POST:@"addClipping" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf updateClippingsDetailsToCoreDataWithDetails:responseObject forResponseType:eResponseTypeUpdateClippings success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) updateClippingsDetailsToCoreDataWithDetails:(NSMutableDictionary *)details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {

    NSInteger errorCode = [[details objectForKey:kErrorCode] integerValue];

    if(errorCode == -1) {
        STLog(@"%@", [details objectForKey:kStatus]);

        NSError *error = [NSError errorWithDomain:[details objectForKey:kStatus] code:2000 userInfo:nil];
        failureBlock(error);
    } else if (errorCode == 0) {

        if (type == eResponseTypeAllClippings) {
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                
                if(!localUser) {
                    localUser = [STUser MR_createEntityInContext:localContext];
                }
                
                NSArray *clippings = [details objectForKey:kClippings];
                
//                NSMutableOrderedSet *clippingsSet = [NSMutableOrderedSet orderedSetWithOrderedSet:localUser.clippings];
                NSMutableOrderedSet *clippingsSet = [NSMutableOrderedSet orderedSet];

                for(NSDictionary *dict in clippings) {
                    
                    NSNumber *collegeID = [dict objectForKey:kCollegeID];
                    NSPredicate *collegePredicate = [NSPredicate predicateWithFormat:@"collegeID == %@",collegeID];
                    STCollege *college = [STCollege MR_findFirstWithPredicate:collegePredicate];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND user == %@", collegeID, localUser];
                    
//                    STClippingsItem *clippingItem = [STClippingsItem MR_findFirstWithPredicate:predicate inContext:localContext];
                    STClippingsItem *clippingItem =  [STClippingsItem MR_createEntityInContext:localContext];

//                    if(!clippingItem) {
//                        clippingItem = [STClippingsItem MR_createEntityInContext:localContext];
//                        [clippingsSet addObject:clippingItem];
//                    }
                    
                    clippingItem.user = localUser;
                    clippingItem.collegeID = collegeID;
                    clippingItem.collegeName = college.collegeName;
                    [clippingsSet addObject:clippingItem];
                    
                    NSArray *sections = [[dict objectForKey:kSections] componentsSeparatedByString:@","];

                    NSMutableOrderedSet *sectionItemsSet = [NSMutableOrderedSet orderedSetWithOrderedSet:clippingItem.clippingSections];

                    for(NSString *section in sections) {
                        
                        NSString *sectionName = section;
                        
                        if ([sectionName isEqualToString:@"Intended Study"] || [sectionName isEqualToString:@"Popular Majors"]) {
                            sectionName = @"Intended Study";
                        }
                        
                        NSDictionary *sectionDetails = [self getSectionDetailsForSectionWithName:sectionName];
                        
                        predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND sectionID == %@", collegeID, [sectionDetails objectForKey:kSectionId]];
                        
//                        STClippingSectionItem *sectionItem = [STClippingSectionItem MR_findFirstWithPredicate:predicate inContext:localContext];
                        STClippingSectionItem *sectionItem = [STClippingSectionItem MR_createEntityInContext:localContext];

//                        if(!sectionItem) {
//                            sectionItem = [STClippingSectionItem MR_createEntityInContext:localContext];
//                            sectionItem.isExpanded = [NSNumber numberWithBool:NO];
//                            [sectionItemsSet addObject:sectionItem];
//                        }
                        
                        sectionItem.isExpanded = [NSNumber numberWithBool:NO];
                        sectionItem.clipping = clippingItem;
                        sectionItem.collegeID = collegeID;
                        sectionItem.sectionID = [NSNumber numberWithInteger:[[sectionDetails objectForKey:kSectionId] integerValue]];
                        sectionItem.sectionTitle = [sectionDetails objectForKey:kSectionName];
                        sectionItem.imageName = [sectionDetails objectForKey:kImageName];
                        [sectionItemsSet addObject:sectionItem];
                    }
                    
                    clippingItem.clippingSections = sectionItemsSet;
                }

                localUser.clippings = clippingsSet;
                
            } completion:^(BOOL success, NSError *error) {
                successBlock([NSNull null]);
            }];
        } else if(type == eResponseTypeAddToClippings) {
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                
                if(!localUser) {
                    localUser = [STUser MR_createEntityInContext:localContext];
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND user == %@", [details objectForKey:kCollegeID], localUser];
                
                NSMutableOrderedSet *clippingsSet = [NSMutableOrderedSet orderedSetWithOrderedSet:localUser.clippings];
                
                STClippingsItem *clippingItem = [STClippingsItem MR_findFirstWithPredicate:predicate inContext:localContext];
                
                if(!clippingItem) {
                    clippingItem = [STClippingsItem MR_createEntityInContext:localContext];
                    [clippingsSet addObject:clippingItem];
                }
                
                clippingItem.user = localUser;
                clippingItem.collegeID = [NSNumber numberWithInteger:[[details objectForKey:kCollegeID] integerValue]];
                clippingItem.collegeName = [details objectForKey:kCollegeName];
                
                
                predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND sectionID == %@", [details objectForKey:kCollegeID],[details objectForKey:KEY_SECTION_ID]];
                
                
                NSMutableOrderedSet *sectionItemsSet = [NSMutableOrderedSet orderedSetWithOrderedSet:clippingItem.clippingSections];
                
                STClippingSectionItem *sectionItem = [STClippingSectionItem MR_findFirstWithPredicate:predicate inContext:localContext];
                
                if(!sectionItem) {
                    sectionItem = [STClippingSectionItem MR_createEntityInContext:localContext];
                    sectionItem.isExpanded = [NSNumber numberWithBool:NO];
                    [sectionItemsSet addObject:sectionItem];
                }
                
                sectionItem.clipping = clippingItem;
                sectionItem.collegeID = [details objectForKey:kCollegeID];
                sectionItem.sectionID = [NSNumber numberWithInteger:[[details objectForKey:KEY_SECTION_ID] integerValue]];
                sectionItem.sectionTitle = [details objectForKey:KEY_SECTION_NAME];
                sectionItem.imageName = [details objectForKey:KEY_SECTION_ICON];
                
                clippingItem.clippingSections = sectionItemsSet;
                
                localUser.clippings = clippingsSet;
                
                
            } completion:^(BOOL success, NSError *error) {
                successBlock([NSNull null]);
            }];
        } else if (type == eResponseTypeRemoveFromClippings) {
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                
                if(!localUser) {
                    localUser = [STUser MR_createEntityInContext:localContext];
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND user == %@", [details objectForKey:kCollegeID], localUser];
                
                NSMutableOrderedSet *clippingsSet = [NSMutableOrderedSet orderedSetWithOrderedSet:localUser.clippings];
                
                STClippingsItem *clippingItem = [STClippingsItem MR_findFirstWithPredicate:predicate inContext:localContext];
                
                predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND sectionID == %@", [details objectForKey:kCollegeID],[details objectForKey:KEY_SECTION_ID]];
                
                NSMutableOrderedSet *sectionItemsSet = [NSMutableOrderedSet orderedSetWithOrderedSet:clippingItem.clippingSections];
                
                STClippingSectionItem *sectionItem = [STClippingSectionItem MR_findFirstWithPredicate:predicate inContext:localContext];
                
                if(sectionItem) {
                    [sectionItemsSet removeObject:sectionItem];
                    [sectionItem MR_deleteEntityInContext:localContext];
                }
                
                if(sectionItemsSet && ([sectionItemsSet count] == 0)) {
                    clippingItem.clippingSections = nil;
                    [clippingsSet removeObject:clippingItem];
                    [clippingItem MR_deleteEntityInContext:localContext];
                }
                else {
                    clippingItem.clippingSections = sectionItemsSet;
                }
                
                localUser.clippings = clippingsSet;
                
                
            } completion:^(BOOL success, NSError *error) {
                successBlock([NSNull null]);
            }];
        } else if(type == eResponseTypeUpdateClippings) {
            successBlock([NSNull null]);
        }
    }
}

@end
