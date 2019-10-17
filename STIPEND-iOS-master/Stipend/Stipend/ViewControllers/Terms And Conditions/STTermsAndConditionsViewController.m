//
//  STTermsAndConditionsViewController.m
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STTermsAndConditionsViewController.h"
#import "STPrivayPolicyViewController.h"

@interface STTermsAndConditionsViewController ()<UITextViewDelegate>

@end

@implementation STTermsAndConditionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Terms & Conditions";
        
    NSError *error;
    
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"TermsAndConditions" withExtension:@"rtf"];
    NSMutableAttributedString *termsAndConditionText = [[NSMutableAttributedString alloc] initWithURL:fileUrl options:[NSDictionary dictionaryWithObjectsAndKeys:@"DefaultAttributes",@"NSDefaultAttributesDocumentOption", nil] documentAttributes:nil error:&error];
    
    NSRange range = [[termsAndConditionText string] rangeOfString:@"You agree to our privacy policy, which you can read "];
    [termsAndConditionText addAttribute:NSLinkAttributeName value:@"text://privacypolicy" range:NSMakeRange(range.location + range.length, 4)];//4 will be length of string - "here"
    self.ibTextView.attributedText  =  termsAndConditionText;
    self.ibTextView.delegate = self;
    
    [self.ibTextView scrollRangeToVisible:NSMakeRange(0, 0)];

    // Do any additional setup after loading the view.
    
    if(self.isFromIntroductionViewController) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController)];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"text"]) {
        //NSString *username = [URL host];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
        
        STPrivayPolicyViewController *privacyPolicyViewController = [storyboard instantiateViewControllerWithIdentifier:@"PrivayPolicyStoryboardID"];
        privacyPolicyViewController.isFromIntroductionViewController = YES;
        
        UINavigationController *termsAndConditionsNavigationController = [[UINavigationController alloc] initWithRootViewController:privacyPolicyViewController];
        [self presentViewController:termsAndConditionsNavigationController animated:YES completion:nil];
        return NO;
    }
    return YES; // let the system open this URL
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
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

- (void)dealloc {
    
    STLog(@"Dealloc Called");
}

@end
