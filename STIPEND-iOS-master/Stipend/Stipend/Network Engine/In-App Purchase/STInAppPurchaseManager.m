//
//  STInAppPurchaseManager.m
//  Stipend
//
//  Created by sourcebits on 19/11/15.
//  Copyright © 2015 Sourcebits. All rights reserved.
//

#import "STInAppPurchaseManager.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface STInAppPurchaseManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    
    SKProductsRequest *_productsRequest;
    
    RequestProductsCompletionHandler _completionHandler;
    NSSet *_productIdentifiers;
    NSMutableSet *_purchasedProductIdentifiers;
    NSMutableSet *_productsInformation;
}

@end

@implementation STInAppPurchaseManager 

+ (STInAppPurchaseManager *)sharedInstance {
    
    static dispatch_once_t once;
    static STInAppPurchaseManager *sharedInstance;
    
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
                                     EXPORT_NC_PRODUCT_IDENTIFIER, nil];
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    
    return sharedInstance;
}


- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if(self = [super init]) {
        _productIdentifiers = productIdentifiers;
        
        _purchasedProductIdentifiers = [NSMutableSet set];
        
        for(NSString *productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            
            //productPurchased = YES;
            
            if(productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                STLog(@"Previously purchased : %@", productIdentifier);
            } else {
                STLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        // Requesting for products information
        [self requestProductsInformation];
    }
    return self;
}

// Requesting for products information
- (void)requestProductsInformation {
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    
    [_productsRequest start];
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    STLog(@"Loaded list of products....");
    _productsRequest = nil;
    
    _productsInformation = [NSMutableSet setWithArray:response.products];
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    STLog(@"Failed to load list of products.");
    
    _productsRequest = nil;
    
}


// Checking whether product is purchased or not
- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

// Returns product for particular identifier
- (SKProduct *)getProductForIdentifier:(NSString *)identifier {
    
    for (SKProduct *skProduct in _productsInformation) {
        
        STLog(@"Product info: %@ %@ %0.2f", skProduct.productIdentifier, skProduct.localizedTitle, skProduct.price.floatValue);
        
        if([skProduct.productIdentifier isEqualToString:identifier]) {
            return skProduct;
        }
    }
    return nil;
}

// Buying the product for particular identifier
- (void)buyProductForIdentifier:(NSString *)identifier withCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    _completionHandler = [completionHandler copy];
    
    SKProduct *product = [self getProductForIdentifier:identifier];
    
    if(product) {
        STLog(@"Buying %@....", product.productIdentifier);
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
    } else {
    
        // Buying the product via SKMutablePayment with product identifier if previously loaded products are not available.
        SKMutablePayment *payment = [[SKMutablePayment alloc] init];
        payment.productIdentifier = identifier;
        payment.quantity = 1;
        [[SKPaymentQueue defaultQueue] addPayment:payment];

//        if(_completionHandler) {
//            _completionHandler(NO, nil, @"Product is unavailable!, Please try later");
//            _completionHandler = nil;
//        }
    }
}



// SKPaymentTransactionObserver protocol implementation
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for(SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

// SKPaymentTransaction state methods implementation
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    STLog(@"Transaction completed");
    
    STLog(@"Transaction completed = %@", transaction.payment.applicationUsername);
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:EXPORT_PAYMENT_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self provideContentForProductIdentifier:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    STLog(@"Transaction restored");
    
    [self provideContentForProductIdentifier:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    STLog(@"Transaction failed");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        STLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    if(_completionHandler) {
        _completionHandler(NO, transaction ,transaction.error.localizedDescription);
        _completionHandler = nil;
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)provideContentForProductIdentifier:(SKPaymentTransaction *)transaction {
    
//    [_purchasedProductIdentifiers addObject:productIdentifier];
//    
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:transaction userInfo:nil];
    
    if(_completionHandler) {
        _completionHandler(YES, transaction, @"Successfully purchased");
        _completionHandler = nil;
    }
}

// Restoring In-App purchases
- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}



@end
