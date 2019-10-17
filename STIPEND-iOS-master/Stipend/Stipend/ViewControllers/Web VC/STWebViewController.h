//
//  STWebViewController.h
//  Stipend
//
//  Created by Ganesh Kumar on 22/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface STWebViewController : UIViewController<WKNavigationDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) WKWebView *webView;

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *titleText;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView    *activityIndicatorView;


@end
