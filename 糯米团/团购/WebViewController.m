//
//  WebViewController.m
//  糯米团
//
//  Created by Sunny on 12/10/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", _shopName];
    NSURL *url = [NSURL URLWithString:_stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
