//
//  WebViewController.h
//  糯米团
//
//  Created by Sunny on 12/10/15.
//  Copyright © 2015 IOSDevelopeGuid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) NSString *stringURL;
@property (strong, nonatomic) NSString *shopName;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)back:(UIBarButtonItem *)sender;

@end
