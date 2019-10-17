//
//  STNetworkAPIManager+CollegeListAPI.m
//  Stipend
//
//  Created by Ganesh Kumar on 17/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager+CollegeListAPI.h"

@implementation STNetworkAPIManager (CollegeListAPI)

- (void)fetchDefaultCollege:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    [self GET:@"getDefaultCollege" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSInteger errorCode = [[responseObject objectForKey:kErrorCode] integerValue];
        
        if (errorCode == 0) {
            
            NSMutableDictionary *responseDict = [responseObject mutableCopy];
            [responseDict setObject:dateString forKey:@"date"];
            
            if(successBlock) {
                successBlock(responseDict);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) fetchCollegeListsWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    __weak STNetworkAPIManager *weakSelf = self;

    [self POST:@"getCollegesInPagesForApp" parameters:details progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf updateCollegeListsToCoreDataWithDetails:responseObject forResponseType:eResponseTypeCollegeLists success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) fetchCollegeMajorsListWithDetails:(NSMutableDictionary *)details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    __weak STNetworkAPIManager *weakSelf = self;
    
    [self POST:@"getMajorsDataWithColleges" parameters:details progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf updateCollegeListsToCoreDataWithDetails:responseObject forResponseType:eResponseTypeMajorsList success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) updateCollegeListsToCoreDataWithDetails:(id) details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    NSInteger errorCode = [[details objectForKey:kErrorCode] integerValue];
    
    if(errorCode == -1) {
        
        NSError *error;
        
        if([details objectForKey:kStatus]) {
            error = [NSError errorWithDomain:[details objectForKey:kStatus] code:2000 userInfo:nil];
        }
        else {
            error = [NSError errorWithDomain:@"Fetching Failed" code:2000 userInfo:nil];
        }
        
        failureBlock(error);
    }
    else if (errorCode == 0) {
        
        __weak STNetworkAPIManager *weakSelf = self;

        if(type == eResponseTypeCollegeLists) {
            
            NSArray *collegeList = [details objectForKey:kColleges];
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                @autoreleasepool {
                    
                    for (NSMutableDictionary *summaryDict in collegeList) {
                        
                        NSNumber *collegeID = [summaryDict objectForKey:kCollegeID];
                        
                        if(![weakSelf isNullValueForObject:collegeID]) {
                            
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@",collegeID];
                            STCollege *localCollege = [STCollege MR_findFirstWithPredicate:predicate inContext:localContext];
                            
                            if(!localCollege) {
                                localCollege = [STCollege MR_createEntityInContext:localContext];
                            }
                            
                            localCollege.shouldUpdate = [NSNumber numberWithBool:YES];
                            localCollege.collegeID = collegeID;
                            
                            [weakSelf updateCollegeWithSummaryDetails:summaryDict forCollege:localCollege inContext:localContext];
                        }
                    }
                }
                
            } completion:^(BOOL success, NSError *error) {
                
                NSInteger nextIndex = [[details objectForKey:@"NextIndex"] integerValue];
                
                STLog(@"***************** INDEX --- %ld **************** ",(long)nextIndex);
                
                if(nextIndex != -1) {
                    NSMutableDictionary *details = [NSMutableDictionary dictionary];
                    [details setObject:[NSNumber numberWithInteger:nextIndex] forKey:kFetchOffset];
                    [details setObject:[NSNumber numberWithInteger:40] forKey:kFetchSize];
                    
                    if([[NSUserDefaults standardUserDefaults] objectForKey:LAST_UPDATED_DATE]) {
                        NSString *lastUpdatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_UPDATED_DATE];
                        
                        [details setObject:lastUpdatedDate forKey:kLastUpdatedDate];
                    }
                    
                    [weakSelf fetchCollegeListsWithDetails:details success:successBlock failure:failureBlock];
                }
                else {
                    
                    NSString *timeStamp = [details objectForKey:@"TimeStamp"];
                    
                    //2015-07-31T17:54:00.000
                    
                    if(timeStamp && (![timeStamp isEqualToString:@""])) {
                        NSString *formattedDateString = [timeStamp stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
                        NSString *finalFormattedDateString = [formattedDateString stringByReplacingOccurrencesOfString:@" " withString:@"T"];
                        
                        NSString *finalDateString = [NSString stringWithFormat:@"%@.000",finalFormattedDateString];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:finalDateString forKey:LAST_UPDATED_DATE];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    successBlock([NSNull null]);
                }
            }];
        } else if(type == eResponseTypeMajorsList) {
            
            NSArray *majorsList = [details objectForKey:kMajors];
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                @autoreleasepool {
                    
                    for (NSMutableDictionary *majorsDict in majorsList) {
                        
                        NSNumber *collegeID = [majorsDict objectForKey:kCollegeID];
                        
                        if(![weakSelf isNullValueForObject:collegeID]) {
                            
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@",collegeID];
                            STCollege *localCollege = [STCollege MR_findFirstWithPredicate:predicate inContext:localContext];
                            
                            if(!localCollege) {
                                localCollege = [STCollege MR_createEntityInContext:localContext];
                            }
                            
                            localCollege.collegeID = collegeID;
                            
                            [weakSelf updateCollegeWithSummaryDetails:majorsDict forCollege:localCollege inContext:localContext];
                        }
                    }
                }
                
            } completion:^(BOOL success, NSError *error) {
                
                NSInteger nextIndex = [[details objectForKey:@"NextIndex"] integerValue];
                
                STLog(@"***************** MAJORS INDEX --- %ld **************** ",(long)nextIndex);
                
                if(nextIndex != -1) {
                    NSMutableDictionary *details = [NSMutableDictionary dictionary];
                    [details setObject:[NSNumber numberWithInteger:nextIndex] forKey:kFetchOffset];
                    [details setObject:[NSNumber numberWithInteger:40] forKey:kFetchSize];
                    
                    if([[NSUserDefaults standardUserDefaults] objectForKey:LAST_MAJORS_UPDATED_DATE]) {
                        NSString *lastUpdatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_MAJORS_UPDATED_DATE];
                        
                        [details setObject:lastUpdatedDate forKey:kLastUpdatedDate];
                    }
                    
                    [weakSelf fetchCollegeMajorsListWithDetails:details success:successBlock failure:failureBlock];
                }
                else {
                    
                    NSString *timeStamp = [details objectForKey:@"TimeStamp"];
                    
                    //2015-07-31T17:54:00.000
                    
                    if(timeStamp && (![timeStamp isEqualToString:@""])) {
                        NSString *formattedDateString = [timeStamp stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
                        NSString *finalFormattedDateString = [formattedDateString stringByReplacingOccurrencesOfString:@" " withString:@"T"];
                        
                        NSString *finalDateString = [NSString stringWithFormat:@"%@.000",finalFormattedDateString];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:MAJORS_FETCH_STATUS];
                        [[NSUserDefaults standardUserDefaults] setObject:finalDateString forKey:LAST_MAJORS_UPDATED_DATE];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    successBlock([NSNull null]);
                }
            }];
        }
    }
}

- (NSDictionary *) getCollegesForMajorsCodes:(NSArray *)majorCodes {
    
//    [self POST:@"getCollegesForMajors" parameters:majorCodes progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        successBlock(responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
//        failureBlock(error);
//    }];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:majorCodes options:0 error:nil];

    NSString *urlString = [NSString stringWithFormat:@"%@getCollegesForMajors", BASE_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:50];
    request.HTTPMethod = @"POST";
    request.HTTPBody = requestData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *data = [self requestSynchronousData:request];
    NSError *error = nil;
    
    if(data) {
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        return responseData;
    } else {
        return nil;
    }
}

- (NSData *)requestSynchronousData:(NSURLRequest *)request
{
    __block NSData *data = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        if (!data) {
            STLog(@"%@", error);
        }
        dispatch_semaphore_signal(semaphore);
        
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return data;
}

@end
