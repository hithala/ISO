//
//  STPrivacyAndTermsViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 11/04/19.
//  Copyright © 2019 Sourcebits. All rights reserved.
//

#import "STPrivacyAndTermsViewController.h"
#import "STWebViewController.h"

@interface STPrivacyAndTermsViewController ()

@end

@implementation STPrivacyAndTermsViewController

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

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return nil;
//}
//
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
//    scrollView.pinchGestureRecognizer.isEnabled = NO;
//}

- (void)setupNavigationBarButtons {

    if(self.presentingViewController.presentedViewController == self.navigationController) {

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_close"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 25, 25);
        [backButton setImage:[UIImage imageNamed:@"browser_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backbarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backbarButton;
        self.navigationItem.rightBarButtonItem = nil;
    }
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
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    STLog(@"didFinishNavigation: %@", navigation);
    [self.activityIndicatorView stopAnimating];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    STLog(@"decidePolicyForNavigationAction: %@", navigationAction);
    
    if(self.isTermsOfUse && [navigationAction.request.URL.absoluteString isEqualToString:PRIVACY_POLICY_URL]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self showPrivacyPolicy];
    } else if(self.isTermsOfUse && [navigationAction.request.URL.absoluteString isEqualToString:@"https://www.jamsadr.com/"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self showJamsadrURL];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)showPrivacyPolicy {
    
    STPrivacyAndTermsViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STPrivacyAndTermsViewController"];
    webView.urlString = PRIVACY_POLICY_URL;
    webView.titleText = @"Privacy Policy";
    webView.isTermsOfUse = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)showJamsadrURL {
    
    STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
    webView.urlString = @"https://www.jamsadr.com/";
    webView.titleText = @"";
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:navController animated:YES completion:nil];
}

/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self setupLeftNavigationButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    STLog(@"%@", error);
}
*/

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
