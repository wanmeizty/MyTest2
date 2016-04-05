//
//  ViewController.m
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/21.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "ViewController.h"

#import "GetTime.h"

#import "GoodsOrder.h"

#import "ReapalUtil.h"

#import "ReapalApp.h"

#import "PaySuccessViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试demo";

    [self test];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)test{
    

    
    UIButton * refundBtn = [[UIButton alloc] initWithFrame:GTRectMake(self.view.bounds.size.width * 0.5 -80, self.view.frame.size.height * 0.5, 160, 30)];
    refundBtn.backgroundColor = [UIColor grayColor];
    [refundBtn setTitle:@"融宝快捷支付" forState:UIControlStateNormal];
    
    [refundBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [refundBtn addTarget:self action:@selector(demo) forControlEvents:UIControlEventTouchUpInside];
    refundBtn.layer.masksToBounds = YES;
    refundBtn.layer.cornerRadius = 10;
    [self.view addSubview:refundBtn];
    


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (void)demo{
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
//    goodOrder.bank_card_type = @"0"; // 卡类型
    goodOrder.member_id = @"12300";  // 用户ID
    //123为已绑卡
    
    goodOrder.merchant_id = @"100000000008767"; // 商户ID
    
    
    
    goodOrder.bind_id = @"6024"; //绑卡ID
    goodOrder.order_no = [ReapalUtil generateTradeNO]; // 商户订单号 // @"102015061216072101"; //@"102016022910422701";//
    goodOrder.transtime = @"2015-06-12 16:52:57";
    goodOrder.currency = @"156";
    
    goodOrder.total_fee = @"1"; // 元  // 交易金额
    
    goodOrder.title =  @"t33257"; // 商品名称
    
    goodOrder.body = @"yyyy"; // 商品描述
    goodOrder.terminal_type = @"mobile";
    goodOrder.terminal_info = @"dddss-daddd";
    goodOrder.member_ip = @"192.168.1.83"; // 用户IP
    goodOrder.seller_email = @"492215340@qq.com"; // @"492215340@qq.com"; // 商户邮箱
    goodOrder.notify_url = @"http://testcashier.reapal.com/test/mobile/notify";//@"http://192.168.2.33:20009/notify.jsp"; // @"192.168.1.1"; // @"http://192.168.0.173:8080/notify"; // 商户后台系统回调地址
    goodOrder.token_id = @"11534545fdsfsda";
    //    goodOrder.version = @"3.0";
    
    goodOrder.calibrateKey = @"58c4696ag73aa51bc55cg9c91g30104g7dd27b65da2089257173d79egd212453";
    
    ReapalUtil * reapalUtil = [ReapalUtil defaultUtil];
    
    [reapalUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    NSDictionary * params = [reapalUtil privateEncodeOrder:goodOrder andCalibratekey:goodOrder.calibrateKey];
    
    NSLog(@"params==>%@",params);
    
    GoodsOrder * order = [reapalUtil decryptWithParams:params];
    
    ReapalApp * app = [[ReapalApp alloc] init];
    
    [app startPay:goodOrder fromScheme:@"myapp" mode:ReapalTestStatus viewController:self];
    
}

- (NSString *)selectCalibrate:(NSString *)mercharId{
    
    
    NSString * calibrateKey1 = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809"; // 安全校验码
    
    NSString * calibrateKey2 = @"58c4696ag73aa51bc55cg9c91g30104g7dd27b65da2089257173d79egd212453"; // 安全校验码
    NSString * calibrateKey3 = @"g0be2385657fa355af68b74e9913a1320af82gb7ae5f580g79bffd04a402ba8f"; // 安全校验码
    
    NSString * calibrateKey4 = @"4ca781f941bfccb591285b70a3g000c99bd0586dce0d4375ba279f8a7gd85571"; // 安全校验码
    NSString * calibrateKey5 = @"gbg5f8b4c9cfd749f66990bdb5a918391d292g3396c73f7c2baf342247d20age"; // 安全校验码
    
    NSString * calibrateKey6 = @"e977ade964836408243b5g2444848f7b39d09fb41c77ae2e327ffb16f905e117"; // 安全校验码
    
    
    NSString * calibrateKey ;
    
    if ([mercharId isEqualToString:@"100000000009085"]) {
        
        calibrateKey = calibrateKey1;
    }else if([mercharId isEqualToString:@"100000000008767"]){
        
        calibrateKey = calibrateKey2;
    }else if([mercharId isEqualToString:@"100000000000147"]){
        
        calibrateKey = calibrateKey3;
        
    }else if([mercharId isEqualToString:@"100000000001486"]){
        
        calibrateKey = calibrateKey4;
        
    }else if([mercharId isEqualToString:@"100000000071531"]){
        
        calibrateKey = calibrateKey5;
        
    }else if ([mercharId isEqualToString:@"100000000011015"]){
        
        calibrateKey = calibrateKey6;
        
    }
    
    return calibrateKey;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
