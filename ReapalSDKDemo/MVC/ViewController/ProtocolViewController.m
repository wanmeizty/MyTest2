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
    
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:GTRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    view.backgroundColor = [UIColor colorWithRed:53/255.0 green:52/255.0 blue:57/255.0 alpha:1];
    
    [webView addSubview:view];
    
    UIImageView * webImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 40, 40)];
    webImgView.image = [UIImage imageNamed:@"buttons_05.png"];
    
    [view addSubview:webImgView];
    webImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popBankCard)];
    
    [webImgView addGestureRecognizer:singleTap];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, [UIScreen mainScreen].bounds.size.width - 120, 40)];
    
    label.text = @"融宝快捷支付协议";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    
    [self.view addSubview:webView];
    
    NSURL * url = [NSURL URLWithString:@"http://testmobile.reapal.com/mobile/agreement"];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    [webView loadRequest:request];
    
    webView.scrollView.bounces = NO;
    
}

- (void)popBankCard
{
    [self.navigationController popViewControllerAnimated:YES];
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
