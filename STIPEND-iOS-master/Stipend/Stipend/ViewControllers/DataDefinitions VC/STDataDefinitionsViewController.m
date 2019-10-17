//
//  STDataDefinitionsViewController.m
//  Stipend
//
//  Created by Mahesh A on 08/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STDataDefinitionsViewController.h"

@interface STDataDefinitionsViewController ()

@end

@implementation STDataDefinitionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Attribution";
    
    [self.ibTextView scrollRangeToVisible:NSMakeRange(0, 0)];//TermsAndCondition.rtf
    
    NSURL *fileUrl = [NSBundle.mainBundle URLForResource:@"Attributes" withExtension:@"rtf"];
    NSAttributedString *attributesText = [[NSAttributedString alloc] initWithURL:fileUrl options:[NSDictionary dictionaryWithObjectsAndKeys:@"DefaultAttributes",@"NSDefaultAttributesDocumentOption", nil] documentAttributes:nil error:nil];
    self.ibTextView.attributedText  = attributesText;

    // Do any additional setup after loading the view.
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
