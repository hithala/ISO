//
//  STNetworkAPIManager+FavoritesAPI.m
//  Stipend
//
//  Created by Ganesh Kumar on 24/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager+FavoritesAPI.h"
#import "STFavorites.h"

@implementation STNetworkAPIManager (FavoritesAPI)

- (void) getFavoriteCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    if(![[STUserManager sharedManager] isGuestUser]) {

        __weak STNetworkAPIManager *weakSelf = self;

        [self GET:[NSString stringWithFormat:@"getFavorites/%@", userID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf updateUserFavoritesToCoreDataWithDetails:responseObject forResponseType:eResponseTypeAllFavorites success:successBlock failure:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
            failureBlock(error);
        }];
    }
    else {
        [self updateUserFavoritesToCoreDataWithDetails:nil forResponseType:eResponseTypeAllFavorites success:successBlock failure:failureBlock];
    }
}

- (void) addCollegeToFavoriteWithDetails:(NSMutableDictionary *)details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {

    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
    [parameters setObject:[NSNumber numberWithBool:NO] forKey:kIsSync];

    NSMutableOrderedSet *favoriteItems = [[currentUser favorites] mutableCopy];
    int index = (int)favoriteItems.count + 1;

    NSMutableArray *favoritesList = [[NSMutableArray alloc] init];
    NSDictionary *dict = @{kCollegeID: [details objectForKey:kCollegeID], kPosition: [NSNumber numberWithInt:index]};
    [favoritesList addObject:dict];

    [parameters setObject:favoritesList forKey:kFavoriteList];

    __weak STNetworkAPIManager *weakSelf = self;

    [self POST:@"addFavorites" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf updateUserFavoritesToCoreDataWithDetails:details forResponseType:eResponseTypeAddToFavorites success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) removeCollegeFromFavouriteWithDetails:(NSMutableDictionary *)details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];

    if(![[STUserManager sharedManager] isGuestUser]) {

        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
        [parameters setObject:[details objectForKey:kCollegeID] forKey:kCollegeID];

        __weak STNetworkAPIManager *weakSelf = self;

        [self POST:@"deleteFavorites" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [weakSelf updateUserFavoritesToCoreDataWithDetails:details forResponseType:eResponseTypeRemoveFromFavorites success:successBlock failure:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
            failureBlock(error);
        }];
    } else {
        [self updateUserFavoritesToCoreDataWithDetails:details forResponseType:eResponseTypeRemoveFromFavorites success:successBlock failure:failureBlock];
    }
}

- (void) syncFavoriteCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
    [parameters setObject:[NSNumber numberWithBool:YES] forKey:kIsSync];
    [parameters setObject:[NSNumber numberWithBool:NO] forKey:kIsUpdate];
    
    NSMutableOrderedSet *favoriteItems = [[currentUser favorites] mutableCopy];
    
    NSMutableArray *favoritesList = [[NSMutableArray alloc] init];
    int index = 1;
    
    for(STFavorites *favorite in favoriteItems) {
        NSDictionary *dict = @{kCollegeID: favorite.collegeID, kPosition: [NSNumber numberWithInt:index]};
        [favoritesList addObject:dict];
        index++;
    }
    
    [parameters setObject:favoritesList forKey:kFavoriteList];
    
    __weak STNetworkAPIManager *weakSelf = self;
    
    [self POST:@"updateFavorites" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf updateUserFavoritesToCoreDataWithDetails:responseObject forResponseType:eResponseTypeUpdateFavorites success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) updateFavoriteCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
    [parameters setObject:[NSNumber numberWithBool:NO] forKey:kIsSync];
    [parameters setObject:[NSNumber numberWithBool:YES] forKey:kIsUpdate];

    NSMutableOrderedSet *favoriteItems = [[currentUser favorites] mutableCopy];

    NSMutableArray *favoritesList = [[NSMutableArray alloc] init];
    int index = 1;
    
    for(STFavorites *favorite in favoriteItems) {
        NSDictionary *dict = @{kCollegeID: favorite.collegeID, kPosition: [NSNumber numberWithInt:index]};
        [favoritesList addObject:dict];
        index++;
    }

    [parameters setObject:favoritesList forKey:kFavoriteList];
    
    __weak STNetworkAPIManager *weakSelf = self;
    
    [self POST:@"updateFavorites" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf updateUserFavoritesToCoreDataWithDetails:responseObject forResponseType:eResponseTypeUpdateFavorites success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) updateUserFavoritesToCoreDataWithDetails:(NSMutableDictionary *)details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    NSInteger errorCode = [[details objectForKey:kErrorCode] integerValue];
    
    if(errorCode == -1) {
        STLog(@"%@", [details objectForKey:kStatus]);
        
        NSError *error = [NSError errorWithDomain:[details objectForKey:kStatus] code:2000 userInfo:nil];
        failureBlock(error);
    }
    else if (errorCode == 0) {
        
        if(type == eResponseTypeAllFavorites) {
            
            if(details) {
                NSArray *favoritesList = [details objectForKey:kFavoriteList];

                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    
                    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                    
                    if(!localUser) {
                        localUser = [STUser MR_createEntityInContext:localContext];
                    }
                    
                    NSMutableOrderedSet *favoriteItems = [[NSMutableOrderedSet alloc] init];//[[localUser favorites] mutableCopy];

                    for(NSNumber *collegeId in favoritesList) {
                        
//                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND user == %@", collegeId, localUser];
                        
                        STFavorites *favorites = [STFavorites MR_createEntityInContext:localContext];
                        //[STFavorites MR_findFirstWithPredicate:predicate inContext:localContext];
                        
//                        if(!favorites) {
//                            favorites = [STFavorites MR_createEntityInContext:localContext];
//                            [favoriteItems addObject:favorites];
//                        }
                        
                        favorites.user = localUser;
                        favorites.collegeID = collegeId; //[NSNumber numberWithInteger:[[favoriteDict objectForKey:kCollegeID] integerValue]];
                        [favoriteItems addObject:favorites];
                    }
                    
                    localUser.favorites = favoriteItems;
                    
                } completion:^(BOOL success, NSError *error) {
                    successBlock([NSNull null]);
                }];
            }
            else {
                successBlock([NSNull null]);
            }
        }
        else if (type == eResponseTypeAddToFavorites) {
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                
                if(!localUser) {
                    localUser = [STUser MR_createEntityInContext:localContext];
                }
                
                STFavorites *favorites = [STFavorites MR_createEntityInContext:localContext];                
                favorites.user = localUser;
                favorites.collegeID = [NSNumber numberWithInteger:[[details objectForKey:kCollegeID] integerValue]];
                
                NSMutableOrderedSet *favoriteItems = [[localUser favorites] mutableCopy];
                [favoriteItems addObject:favorites];
                
                localUser.favorites = favoriteItems;
            }
            completion:^(BOOL success, NSError *error) {
                successBlock([NSNull null]);
            }];
            
        }
        else if (type == eResponseTypeRemoveFromFavorites) {
            
            BOOL shouldUpdate = [[details  objectForKey:kShouldUpdateDatabase] boolValue];
            
            if(shouldUpdate) {
                
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    
                    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];

                    if(!localUser) {
                        localUser = [STUser MR_createEntityInContext:localContext];
                    }

                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND user == %@", [details objectForKey:kCollegeID], localUser];
                    
                    STFavorites *favorites = [STFavorites MR_findFirstWithPredicate:predicate inContext:localContext];
                    
                    NSMutableOrderedSet *favoriteItems = [[localUser favorites] mutableCopy];
                    
                    if(favorites) {
                        [favorites MR_deleteEntityInContext:localContext];
                    }
                    
                    [favoriteItems removeObject:favorites];
                    localUser.favorites = favoriteItems;
                    
                } completion:^(BOOL success, NSError *error) {
                    successBlock([NSNull null]);
                }];
            }
            else {
                successBlock([NSNull null]);
            }
        } else if (type == eResponseTypeUpdateFavorites) {
            successBlock([NSNull null]);
        } else {
            
        }
    }    
}

@end
