//
//  STPrivayPolicyViewController.m
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STPrivayPolicyViewController.h"

@interface STPrivayPolicyViewController ()

@end

@implementation STPrivayPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Privacy Policy";
    // Do any additional setup after loading the view.
    
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"PrivacyPolicy" withExtension:@"rtf"];
    NSError *error;

    NSMutableAttributedString *privacyPolicyText = [[NSMutableAttributedString alloc] initWithURL:fileUrl options:[NSDictionary dictionaryWithObjectsAndKeys:@"DefaultAttributes",@"NSDefaultAttributesDocumentOption", nil] documentAttributes:nil error:&error];

    
    self.ibTextView.attributedText  = privacyPolicyText;
    
    [self.ibTextView scrollRangeToVisible:NSMakeRange(0, 0)];

    if(self.isFromIntroductionViewController) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController)];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.ibTextView scrollRangeToVisible:NSMakeRange(0, 0)];

}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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
