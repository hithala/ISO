//
//  STAboutStipendViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 05/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAboutStipendViewController.h"
#import "STWebViewController.h"
#import <CoreText/CTStringAttributes.h>
#import <CoreText/CoreText.h>


@interface STAboutStipendViewController ()

@end

@implementation STAboutStipendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"About CollegeHunch";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    self.ibVersioLabel.text = [NSString stringWithFormat:@"v%@", appVersionString];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (IBAction)onCollegeHunchTap:(id)sender {
    
//    NSString *urlString = [@"http://www.collegehunch.com" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [@"http://www.collegehunch.com" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
    webView.urlString = urlString;
    webView.titleText = @"collegehunch.com";
    
    [self.navigationController pushViewController:webView animated:YES];
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
