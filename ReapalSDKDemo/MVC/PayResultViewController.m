//
//  PayResultViewController.m
//  ReapalSDKDemo
//
//  Created by 一米阳光 on 16/3/28.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "PayResultViewController.h"
#import "GoodsOrder.h"

@interface PayResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation PayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)initData
{
    self.orderLabel.text = [[NSString alloc] initWithFormat:@"订单号: %@",self.order.order_no];
    self.moneyLabel.text = [[NSString alloc] initWithFormat:@"您已成功支付%@元",self.order.total_fee];
}

- (IBAction)backStore:(id)sender {
    //确定并返回商户张庭勇
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
