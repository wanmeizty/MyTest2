//
//  ProtocolViewController.m
//  TestZ
//
//  Created by wanmeizty on 16/2/29.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController ()

@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:GTRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    
    [self.view addSubview:webView];
    
    NSURL * url = [NSURL URLWithString:@"http://testmobile.reapal.com/mobile/agreement"];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    [webView loadRequest:request];
    
    webView.scrollView.bounces = NO;
    
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
