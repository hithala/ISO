//
//  STNetworkAPIManager+CompareAPI.m
//  Stipend
//
//  Created by Arun S on 08/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager+CompareAPI.h"
#import "STCompareItem.h"

@implementation STNetworkAPIManager (CompareAPI)

- (void) getCompareCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    if(![[STUserManager sharedManager] isGuestUser]) {
        
        __weak STNetworkAPIManager *weakSelf = self;
        
        [self GET:[NSString stringWithFormat:@"getComparisons/%@", userID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf updateUserCompareToCoreDataWithDetails:responseObject forResponseType:eResponseTypeAllCompares success:successBlock failure:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
            failureBlock(error);
        }];
    }
    else {
        [self updateUserCompareToCoreDataWithDetails:nil forResponseType:eResponseTypeAllCompares success:successBlock failure:failureBlock];
    }
}

- (void) addCollegeToCompareWithDetails:(NSMutableDictionary *)details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    NSNumber *collegeID = [details objectForKey:kCollegeID];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
    [parameters setObject:[NSNumber numberWithBool:NO] forKey:kIsSync];
    
    NSMutableOrderedSet *compareItems = [[currentUser compareItems] mutableCopy];
    int index = (int)compareItems.count + 1;
    
    NSMutableArray *compareList = [[NSMutableArray alloc] init];
    NSDictionary *dict = @{kCollegeID: collegeID, kPosition: [NSNumber numberWithInt:index]};
    [compareList addObject:dict];
    
    [parameters setObject:compareList forKey:kCompareList];
    
    __weak STNetworkAPIManager *weakSelf = self;
    
    [self POST:@"addCollegesToCompare" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@",collegeID];
        STCollege *localCollege = [STCollege MR_findFirstWithPredicate:predicate];

        if([[localCollege shouldUpdate] boolValue]) {
            [self fetchCollegeWithDetails:details success:^(id response) {
                [weakSelf updateUserCompareToCoreDataWithDetails:details forResponseType:eResponseTypeAddToCompare success:successBlock failure:failureBlock];
            } failure:^(NSError *error) {
                error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
                failureBlock(error);
            }];
        } else {
            [weakSelf updateUserCompareToCoreDataWithDetails:details forResponseType:eResponseTypeAddToCompare success:successBlock failure:failureBlock];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) removeCollegeFromCompareWithDetails:(NSMutableDictionary *)details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    if(![[STUserManager sharedManager] isGuestUser]) {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
        [parameters setObject:[details objectForKey:kCollegeID] forKey:kCollegeID];
        
        __weak STNetworkAPIManager *weakSelf = self;

        [self POST:@"deleteComparisons" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf updateUserCompareToCoreDataWithDetails:details forResponseType:eResponseTypeRemoveFromCompare success:successBlock failure:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
            failureBlock(error);
        }];
    } else {
        [self updateUserCompareToCoreDataWithDetails:details forResponseType:eResponseTypeRemoveFromCompare success:successBlock failure:failureBlock];
    }
}

- (void) syncCompareCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
    [parameters setObject:[NSNumber numberWithBool:YES] forKey:kIsSync];
    [parameters setObject:[NSNumber numberWithBool:NO] forKey:kIsUpdate];

    NSMutableOrderedSet *compareItems = [[currentUser compareItems] mutableCopy];
    
    NSMutableArray *compareList = [[NSMutableArray alloc] init];
    int index = 1;
    
    for(STCompareItem *compareItem in compareItems) {
        NSDictionary *dict = @{kCollegeID: compareItem.collegeID, kPosition: [NSNumber numberWithInt:index]};
        [compareList addObject:dict];
        index++;
    }
    
    [parameters setObject:compareList forKey:kCompareList];
    
    __weak STNetworkAPIManager *weakSelf = self;
    
    [self POST:@"updateComparisons" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf updateUserCompareToCoreDataWithDetails:responseObject forResponseType:eResponseTypeUpdateCompare success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) updateCompareCollegesForCurrentUserWithSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
    [parameters setObject:[NSNumber numberWithBool:NO] forKey:kIsSync];
    [parameters setObject:[NSNumber numberWithBool:YES] forKey:kIsUpdate];
    
    NSMutableOrderedSet *compareItems = [[currentUser compareItems] mutableCopy];
    
    NSMutableArray *compareList = [[NSMutableArray alloc] init];
    int index = 1;
    
    for(STCompareItem *compareItem in compareItems) {
        NSDictionary *dict = @{kCollegeID: compareItem.collegeID, kPosition: [NSNumber numberWithInt:index]};
        [compareList addObject:dict];
        index++;
    }
    
    [parameters setObject:compareList forKey:kCompareList];
    
    __weak STNetworkAPIManager *weakSelf = self;
    
    [self POST:@"updateComparisons" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf updateUserCompareToCoreDataWithDetails:responseObject forResponseType:eResponseTypeUpdateCompare success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) updateUserCompareToCoreDataWithDetails:(NSMutableDictionary *)details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {

    NSInteger errorCode = [[details objectForKey:kErrorCode] integerValue];
    
    if(errorCode == -1) {
        STLog(@"%@", [details objectForKey:kStatus]);
        
        NSError *error = [NSError errorWithDomain:[details objectForKey:kStatus] code:2000 userInfo:nil];
        failureBlock(error);
    }
    else if (errorCode == 0) {
        
        if(type == eResponseTypeAllCompares) {

            if(details) {
                NSArray *compareList = [details objectForKey:kCompareList];

                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    
                    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                    
                    if(!localUser) {
                        localUser = [STUser MR_createEntityInContext:localContext];
                    }
                    
                    NSMutableOrderedSet *compareItems = [[NSMutableOrderedSet alloc] init];
                    
                    for(NSNumber *collegeId in compareList) {
                        
                        STCompareItem *compareItem = [STCompareItem MR_createEntityInContext:localContext];
                        compareItem.user = localUser;
                        compareItem.collegeID = collegeId;
                        [compareItems addObject:compareItem];
                    }

                    localUser.compareItems = compareItems;

                } completion:^(BOOL success, NSError *error) {
                    successBlock([NSNull null]);
                }];
            }
            else {
                successBlock([NSNull null]);
            }
        } else if (type == eResponseTypeAddToCompare) {
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                
                if(!localUser) {
                    localUser = [STUser MR_createEntityInContext:localContext];
                }
                
                STCompareItem *compareItem = [STCompareItem MR_createEntityInContext:localContext];
                NSInteger totalComapreCount = localUser.compareItems.count;
                compareItem.index = [NSNumber numberWithInteger:totalComapreCount+1];
                
                compareItem.user = localUser;
                compareItem.collegeID = [NSNumber numberWithInteger:[[details objectForKey:kCollegeID] integerValue]];
                
                NSMutableOrderedSet *compareItems = [[localUser compareItems] mutableCopy];
                [compareItems addObject:compareItem];
                localUser.compareItems = compareItems;
            }
                              completion:^(BOOL success, NSError *error) {
                                  successBlock([NSNull null]);
                              }];
        }
        else if (type == eResponseTypeRemoveFromCompare) {
            
            BOOL shouldUpdate = [[details  objectForKey:kShouldUpdateDatabase] boolValue];
            
            if(shouldUpdate) {
                
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    
                    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                    
                    if(!localUser) {
                        localUser = [STUser MR_createEntityInContext:localContext];
                    }

                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND user == %@", [details objectForKey:kCollegeID], localUser];
                    
                    STCompareItem *compareItem = [STCompareItem MR_findFirstWithPredicate:predicate inContext:localContext];
                    
                    NSMutableOrderedSet *compareItems = [[localUser compareItems] mutableCopy];
                    
                    if(compareItem) {
                        [compareItem MR_deleteEntityInContext:localContext];
                    }
                    
                    [compareItems removeObject:compareItem];
                    localUser.compareItems = compareItems;
                    
                } completion:^(BOOL success, NSError *error) {
                    successBlock([NSNull null]);
                }];
            }
            else {
                successBlock([NSNull null]);
            }
        } else if(type == eResponseTypeUpdateCompare) {
            successBlock([NSNull null]);
        } else {
            
        }
    }
}

- (void)exportColleges:(NSArray *)colleges toEmailId:(NSString *)emailId success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    NSDictionary * parameters = @{@"emailId":emailId, @"collegeId":colleges};
    
    [self POST:@"exportColleges" parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void)updateExportTransactionDetails:(SKPaymentTransaction *)transaction forMailId:(NSString *)emailId success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    
    NSString *userId = localUser.userID;
    NSString *fullName = @"";
    
    if(localUser.firstName.length > 0) {
        fullName = [fullName stringByAppendingFormat:@"%@", localUser.firstName];
    }
    
    if(localUser.lastName.length > 0) {
        fullName = [fullName stringByAppendingFormat:@" %@", localUser.lastName];
    }
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:0];
    
    receiptString = @" ";
    
    NSString *transactionIdentifier = transaction.transactionIdentifier;
    
    NSString *transactionDate = [NSDateFormatter localizedStringFromDate:transaction.transactionDate
                                                               dateStyle:NSDateFormatterShortStyle
                                                               timeStyle:NSDateFormatterFullStyle];
    
    if(![self isNullValueForObject:transactionDate] && ![self isNullValueForObject:transactionIdentifier] && ![self isNullValueForObject:receiptString]) {
        
        NSDictionary * parameters = @{
                                      @"userId":userId,
                                      @"fullname":fullName,
                                      @"email":emailId,
                                      @"transactionDate":transactionDate,
                                      @"transactionIdentier":transactionIdentifier,
                                      @"transactionReceipt":receiptString
                                      };
        
        [self POST:@"userExportTransaction" parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            successBlock(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
            failureBlock(error);
        }];
    }
}

@end
