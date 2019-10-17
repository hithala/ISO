//
//  STInAppPurchaseManager.h
//  Stipend
//
//  Created by sourcebits on 19/11/15.
//  Copyright © 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, SKPaymentTransaction *transaction ,NSString *message);

@interface STInAppPurchaseManager : NSObject

+ (STInAppPurchaseManager *)sharedInstance;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;

- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;

- (void)buyProductForIdentifier:(NSString *)identifier withCompletionHandler:(RequestProductsCompletionHandler)completionHandler;


@end
