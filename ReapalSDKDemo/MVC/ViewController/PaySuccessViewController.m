//
//  PaySuccessViewController.m
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/31.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "PaySuccessViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainView = [[UIView alloc] initWithFrame:GTRectMake(0, 64 , self.view.frame.size.width, zheight - 64)];
    
    self.mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.mainView.userInteractionEnabled = YES;
    [self.view addSubview:self.mainView];
    
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)createUI{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zwidth, 80)];
    view.backgroundColor = [UIColor whiteColor];
    [self.mainView addSubview:view];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(zwidth * 0.1, 30,20 , 20)];
    imageView.image = [UIImage imageNamed:@"buttons_08.png"];
    [view addSubview:imageView];
    
    UILabel * orderNo = [[UILabel alloc] initWithFrame:CGRectMake(zwidth * 0.1 + 20, 30, zwidth * 0.8, 20)];
    orderNo.text = [NSString stringWithFormat:@"订单号：%@",self.order.order_no];
    orderNo.font = [UIFont systemFontOfSize:14];
    [view addSubview:orderNo];
    UILabel * fee = [[UILabel alloc] initWithFrame:CGRectMake(zwidth * 0.1 + 20, 50, zwidth * 0.8, 20)];
    fee.text = [NSString stringWithFormat:@"您已成功支付%@元",self.order.total_fee];
    fee.font = [UIFont systemFontOfSize:14];
    [view addSubview:fee];
    
    UIButton * payBtn = [[UIButton alloc] initWithFrame:GTRectMake(20, 110, zwidth - 40, 40)];
    
    [payBtn setTitle:@"确认并跳转至商户" forState:UIControlStateNormal];
    payBtn.backgroundColor = [UIColor whiteColor];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    payBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_03.png"]];
    [payBtn addTarget:self action:@selector(paySucc) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainView addSubview:payBtn];
}

- (void)paySucc{
    
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
