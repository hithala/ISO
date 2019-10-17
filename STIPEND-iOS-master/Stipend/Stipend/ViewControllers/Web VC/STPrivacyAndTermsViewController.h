//
//  STPrivacyAndTermsViewController.h
//  Stipend
//
//  Created by Ganesh Kumar on 11/04/19.
//  Copyright © 2019 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface STPrivacyAndTermsViewController : UIViewController<WKNavigationDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) WKWebView *webView;

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *titleText;
@property (nonatomic, assign) BOOL isTermsOfUse;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView    *activityIndicatorView;

@end

NS_ASSUME_NONNULL_END
