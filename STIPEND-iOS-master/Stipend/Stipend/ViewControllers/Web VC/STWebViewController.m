//
//  STWebViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 22/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STWebViewController.h"

@interface STWebViewController ()

@end

@implementation STWebViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.webView = [self createWebView];
    self = [super initWithCoder:aDecoder];
    return self;
}

- (WKWebView *)createWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    return [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
}

- (void)addWebView:(UIView *)view {
    [view addSubview:self.webView];
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:false];
    self.webView.frame = view.frame;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
}

- (void)webViewLoadUrl:(NSString *)stringUrl {
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleText;
    
    [self setupNavigationBarButtons];
    
    [self addWebView:self.view];
    [self webViewLoadUrl:self.urlString];
    [self.view bringSubviewToFront:self.activityIndicatorView];
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleText;
    
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
    
    [self setupLeftNavigationButtons];

} */

- (void)setupNavigationBarButtons {

    UIButton *backwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backwardButton.frame = CGRectMake(0, 0, 25, 25);
    [backwardButton setImage:[UIImage imageNamed:@"browser_back"] forState:UIControlStateNormal];
    [backwardButton addTarget:self action:@selector(goBackward) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backwardBarButton = [[UIBarButtonItem alloc] initWithCustomView:backwardButton];

    if(self.webView.canGoBack) {
        backwardBarButton.enabled = YES;
    } else {
        backwardBarButton.enabled = NO;
    }
    
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame = CGRectMake(0, 0, 25, 25);
    [forwardButton setImage:[UIImage imageNamed:@"browser_forward"] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *forwardBarButton = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    
    if(self.webView.canGoForward) {
        forwardBarButton.enabled = YES;
    } else {
        forwardBarButton.enabled = NO;
    }
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backwardBarButton, forwardBarButton, nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_close"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
}

- (void)goBackward {
    [self.webView goBack];
}

- (void)goForward {
    [self.webView goForward];
}

- (void)popViewController {
    
    if ([self.webView isLoading])
        [self.webView stopLoading];
    
//    self.webView.delegate = nil;
    
    if(self.presentingViewController.presentedViewController == self.navigationController) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {

        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    STLog(@"Webview started loading...");
    [self.activityIndicatorView startAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    STLog(@"Error while loading...");
    [self.activityIndicatorView stopAnimating];
    [self setupNavigationBarButtons];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    STLog(@"didFinishNavigation: %@", navigation);
    [self.activityIndicatorView stopAnimating];
    [self setupNavigationBarButtons];
}

/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

    [self.activityIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [self.activityIndicatorView stopAnimating];
    [self setupLeftNavigationButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    STLog(@"%@", error);
    [self.activityIndicatorView stopAnimating];
} */

- (void)dealloc {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
