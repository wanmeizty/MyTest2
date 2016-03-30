//
//  PayViewController.m
//  TestZ
//
//  Created by wanmeizty on 16/2/23.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "PayViewController.h"


#import "GoodsOrder.h"

//#import "ReapalSdk.h"

#import "ReapalUtil.h"

#import "PartColorLabel.h"

#import "ReapalSdk.h"

#import "CardView.h"

#import "MoneyView.h"

@interface PayViewController ()
{
    UITextField * _text;
    UITextField * _desc;
    UITextField * _orderId;
    UILabel * _showText;
    
    UILabel * _smsBtn; // 获取短信验证码按钮
    
    NSTimer * _timer; // 发送验证码计时器
    
//    UIView * _mainView;
    
    BOOL _isUnfold;
    
    MoneyView * _moneyView;
    
    UITextField * _calibrate; // 验证码输入框
    

}
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"支付界面";

    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.isBind) {
        
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closeSDKVC2)];
        
        [self createBindPayView];
        
        
        
    }else{
        
        [self createPayView];
        
    }
    
    
    

}

//- (void)goToBack{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}

- (void)createBindPayView{
    
    
    [self createViewWithTitle:self.order.title orderNO:self.order.order_no totalFee:self.order.total_fee];

    
    UIView * backView = [[UIView alloc] initWithFrame:GTRectMake(0, 55, zwidth, 120)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.mainView addSubview:backView];
    
    CardView * cardView = [[CardView alloc] initWithFrame:GTRectMake(0, 0, zwidth, 40)];
    
    NSString * imageName = [NSString stringWithFormat:@"bank_%@.png",self.cardInfo[@"bank_code"]];
    // bank_BOCM.png
    
    cardView.cardIcon.image = [UIImage imageNamed:imageName];

    cardView.textLabel.text = self.cardInfo[@"bank_name"];
    
    cardView.changeView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * changTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCard)];
    
    [cardView.changeView addGestureRecognizer:changTap];
    
//    NSString * lastStr = [self.order.card_no substringFromIndex:self.order.card_no.length - 4];
    
    if ([self.cardInfo[@"bank_card_type"] isEqualToString:@"0"]) {
        
        cardView.numberLabel.text = [NSString stringWithFormat:@"尾号(%@)储蓄卡",self.cardInfo[@"card_last"]];
        
    }else{
        
        cardView.numberLabel.text = [NSString stringWithFormat:@"尾号(%@)信用卡",self.cardInfo[@"card_last"]];
        
    }
    
    
    [backView addSubview:cardView];
    
    //    UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 91, zwidth - 10, 1)];
    //    line1.backgroundColor = [UIColor lightGrayColor];
    //    [_mainView addSubview:line1];
    
    UILabel * phoneLabel = [[UILabel alloc] initWithFrame:GTRectMake(10, 40, zwidth - 20, 40)];
    
//    NSMutableString * mutStr = [[NSMutableString alloc] initWithString:self.order.phone];
//    
//    [mutStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    phoneLabel.text = self.cardInfo[@"phone"];//[NSString stringWithFormat:@"手机号      %@",mutStr];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:phoneLabel];
    
    //    UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 131, zwidth - 10, 1)];
    //    line2.backgroundColor = [UIColor lightGrayColor];
    //    [_mainView addSubview:line2];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:GTRectMake(10, 80, 60,30)];
    
    label.text = @"验证码";
    
    [backView addSubview:label];
    
    _calibrate = [[UITextField alloc] initWithFrame:GTRectMake(70, 80, zwidth - 190, 30)];
    
    //    _calibrate.borderStyle = UITextBorderStyleRoundedRect;
    _calibrate.placeholder = @"输入验证码";
    [backView addSubview:_calibrate];
    
    
    _smsBtn = [[UILabel alloc] initWithFrame:GTRectMake(zwidth - 110, 80, 100, 30)];
    _smsBtn.text = @"获取验证码";
    _smsBtn.font = [UIFont systemFontOfSize:16];
    _smsBtn.textAlignment = NSTextAlignmentCenter;
    _smsBtn.textColor = [UIColor blueColor];
    //    _smsBtn.backgroundColor = [UIColor redColor];
    [backView addSubview:_smsBtn];
    
    _smsBtn.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getSMS2)];
    
    [_smsBtn addGestureRecognizer:singleTap];
    
    
    UIButton * payBtn = [[UIButton alloc] initWithFrame:GTRectMake(20, 200, zwidth - 40, 40)];
    
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    payBtn.backgroundColor = [UIColor grayColor];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [payBtn addTarget:self action:@selector(paySure) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainView addSubview:payBtn];
}


- (void)changeCard{
    
    
    NSLog(@"点击了");
    
}

- (void)createPayView{
    
    [self createViewWithTitle:self.order.title orderNO:self.order.order_no totalFee:self.order.total_fee];
    
    UIView * backView = [[UIView alloc] initWithFrame:GTRectMake(0, 55, zwidth, 120)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.mainView addSubview:backView];
    
    CardView * cardView = [[CardView alloc] initWithFrame:GTRectMake(0, 0, zwidth, 40)];
    
    NSString * imageName = [NSString stringWithFormat:@"bank_%@.png",self.cardInfo[@"bank_code"]];

    
    cardView.cardIcon.image = [UIImage imageNamed:imageName];
    cardView.textLabel.text = self.cardInfo[@"bank_name"];
    NSString * lastStr = [self.order.card_no substringFromIndex:self.order.card_no.length - 4];
    cardView.numberLabel.text = [NSString stringWithFormat:@"尾号(%@)储蓄卡",lastStr];
    
    [backView addSubview:cardView];
    

    
    UILabel * phoneLabel = [[UILabel alloc] initWithFrame:GTRectMake(10, 40, zwidth - 20, 40)];
    
    NSMutableString * mutStr = [[NSMutableString alloc] initWithString:self.order.phone];
    
    [mutStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    phoneLabel.text = [NSString stringWithFormat:@"手机号      %@",mutStr];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:phoneLabel];
    

    
    UILabel * label = [[UILabel alloc]initWithFrame:GTRectMake(10, 80, 60,30)];
    
    label.text = @"验证码";
    
    [backView addSubview:label];
    
    _calibrate = [[UITextField alloc] initWithFrame:GTRectMake(70, 80, zwidth - 190, 30)];
    
//    _calibrate.borderStyle = UITextBorderStyleRoundedRect;
    _calibrate.placeholder = @"输入验证码";
    [backView addSubview:_calibrate];
    
    
    _smsBtn = [[UILabel alloc] initWithFrame:GTRectMake(zwidth - 110, 80, 100, 30)];
    _smsBtn.text = @"获取验证码";
    _smsBtn.font = [UIFont systemFontOfSize:16];
    _smsBtn.textAlignment = NSTextAlignmentCenter;
    _smsBtn.textColor = [UIColor blueColor];
//    _smsBtn.backgroundColor = [UIColor redColor];
    [backView addSubview:_smsBtn];
    
    _smsBtn.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getSMS2)];
    
    [_smsBtn addGestureRecognizer:singleTap];
    
    
    UIButton * payBtn = [[UIButton alloc] initWithFrame:GTRectMake(20, 200, zwidth - 40, 40)];
    
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    payBtn.backgroundColor = [UIColor grayColor];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [payBtn addTarget:self action:@selector(paySure) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainView addSubview:payBtn];
    
    
    
}

- (void)paySure{
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
    goodOrder.merchant_id = self.order.merchant_id; // 商户ID
    goodOrder.order_no = self.order.order_no; // @"MP1Q7QO420H0RPND6YD2"; //[UnionPayUtil generateTradeNO];
    goodOrder.check_code = _calibrate.text; //@"434526";
    goodOrder.card_no = self.order.card_no;  //@"6217000010066764658";
    goodOrder.owner = self.order.owner; //@"zty"; //self.order.owner;
    goodOrder.cert_no = self.order.cert_no; //@"426754534534534545"; //self.order.card_no;
    goodOrder.phone = self.order.phone; // @"18314533172"; //self.order.phone;
    
//    goodOrder.cvv2 = [self.order.card_no substringFromIndex:self.order.card_no.length - 3];//@"417";
//
//    goodOrder.validthru = self.order.validthru; //@"0221";
    goodOrder.version = @"3.1.2";
    
    //    NSString * calibrateKey = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809"; // 安全校验码
    
    NSString * calibrateKey = [self selectCalibrate:goodOrder.merchant_id];
    
    ReapalUtil * unionUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [unionUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [unionUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    [self.view endEditing:YES];
    
    [[ReapalSdk defaultSdk] payWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
       
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [unionUtil rsaDecryptContent:encryptkey];
        
        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
//        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
//        
//        NSString * deDataStr = [unionUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSString * deDataStr = [unionUtil decryptAESWithString:dataStr app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);
        
    }];
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

- (void)getSMS2{
    
    
     GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
     goodOrder.merchant_id = self.order.merchant_id;//@"100000000009085"; // 商户ID

     goodOrder.member_id = self.order.member_id; //@"12345678900";  // 用户ID

     goodOrder.bind_id = self.cardInfo[@"bind_id"]; //@"6024";
     
     goodOrder.order_no = self.order.order_no;
     goodOrder.transtime = @"2015-06-12 16:52:57";
     goodOrder.currency = @"156";

     goodOrder.total_fee = self.order.total_fee; //@"1";

     goodOrder.title = self.order.title;  //@"t33257"; // 商品名称
     goodOrder.body = self.order.body; //@"yyyy"; // 商品描述
     goodOrder.terminal_info = @"dddss-daddd";
     goodOrder.terminal_type = @"mobile";
     goodOrder.member_ip = @"192.168.1.83"; // 用户IP
     goodOrder.seller_email = @"492215340@qq.com"; // @"492215340@qq.com"; // 商户邮箱
     goodOrder.notify_url = @"http://testcashier.reapal.com/test/mobile/notify";
     goodOrder.token_id = @"11534545fdsfsda";
     goodOrder.version = @"3.1.2";
    
    
//    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
//    goodOrder.merchant_id = self.order.merchant_id;
//    //    goodOrder.card_no = self.order.card_no;
//    //    goodOrder.bind_id = self.order.bind_id;
//    //    goodOrder.member_id = self.order.member_id;
//    goodOrder.order_no = self.order.order_no;
//    //    goodOrder.terminal_type = self.order.terminal_type;
//    //    goodOrder.version = self.order.version;
    
    NSString * calibrateKey = [self selectCalibrate:self.order.merchant_id]; // 安全校验码
    
    ReapalUtil * unionUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [unionUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [unionUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    [self.view endEditing:YES];
    
    [[ReapalSdk defaultSdk] bindCardWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
       
        if (resultDic == nil) {
            //             [self performSelectorOnMainThread:@selector(goPay) withObject:nil waitUntilDone:YES];
            return ;
        }
        
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [unionUtil rsaDecryptContent:encryptkey];
        
        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
        //        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
        //
        //        NSString * deDataStr = [unionUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSString * deDataStr = [unionUtil decryptAESWithString:dataStr app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);
        
        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
        
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime2) userInfo:nil repeats:YES];
    
}

- (void)updateTime2{
    
    static NSInteger k = 61;
    
    k --;
    _smsBtn.userInteractionEnabled = NO;
    _smsBtn.enabled = NO;
    _smsBtn.text = [NSString stringWithFormat:@"(%ld)秒后重发",k];
    if (k == 0) {
        
        _smsBtn.text = @"获取验证码";
        _smsBtn.enabled = YES;
        _smsBtn.userInteractionEnabled = YES;
        [_timer setFireDate:[NSDate distantFuture]];
        
        k = 61;
        
    }
    
}



- (void)getCalibrate:(UITapGestureRecognizer *)sender{
    
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCalibateTime) userInfo:nil repeats:YES];
}

- (void)updateCalibateTime{
    
    static NSInteger k = 61;
    
    k --;
    
    _smsBtn.text = [NSString stringWithFormat:@"重新发送%ld",k];
    if (k == 0) {
        
        _smsBtn.text = @"重新发送";
        [_timer setFireDate:[NSDate distantFuture]];
        
    }
    
}

- (void)goPay{
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}


// 支付接口测试
- (void)pay{
    

    

    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];

    UITextField * ttt = [self.view viewWithTag:100];
    goodOrder.body = ttt.text; //@"yyyy"; // 商品描述
    
    
    goodOrder.currency = @"156";
    goodOrder.terminal_info = @"sldfsldf";
    goodOrder.terminal_type = @"mobile";
    goodOrder.transtime = @"2016-02-24 18:10:12";

    goodOrder.default_bank = @"LITEPAY"; // 默认支付
    goodOrder.member_id =  @"2342342343"; // 用户ID
    goodOrder.member_ip =  @"122.111.111.11"; // 用户IP

    UITextField * merchartText =[self.view viewWithTag:102];
    goodOrder.merchant_id = merchartText.text; // @"100000000009085"; // 商户ID
    goodOrder.notify_url =  @"http://192.168.0.173:8080/notify"; // 商户后台系统回调地址

    goodOrder.order_no =  [ReapalUtil generateTradeNO];// [self generateTradeNO]; // 商户订单号

    goodOrder.pay_method =  @"bankPay"; // 支付方式

    goodOrder.payment_type = @"2"; //支付类型

    goodOrder.return_url = @"http://192.168.0.173:8080/return"; // 商户前台系统的回调地址

    goodOrder.seller_email = @"492215340@qq.com"; // 商户邮箱
    UITextField * ttt2 = [self.view viewWithTag:101];
    goodOrder.title = ttt2.text; // @"yyyyy"; // 商品名称


    UITextField * moneyTest = [self.view viewWithTag:99];
    
    NSInteger money = [moneyTest.text doubleValue] * 100;
    goodOrder.total_fee = [NSString stringWithFormat:@"%ld",money] ; // 元  // 交易金额
    
    
    NSString * calibrateKey1 = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809"; // 安全校验码
    
    NSString * calibrateKey2 = @"58c4696ag73aa51bc55cg9c91g30104g7dd27b65da2089257173d79egd212453"; // 安全校验码
    NSString * calibrateKey3 = @"g0be2385657fa355af68b74e9913a1320af82gb7ae5f580g79bffd04a402ba8f"; // 安全校验码
    
    NSString * calibrateKey ;
    
    if ([goodOrder.merchant_id isEqualToString:@"100000000009085"]) {
        
        calibrateKey = calibrateKey1;
    }else if([goodOrder.merchant_id isEqualToString:@"100000000008767"]){
        
        calibrateKey = calibrateKey2;
    }else if([goodOrder.merchant_id isEqualToString:@"100000000000147"]){
        
        calibrateKey = calibrateKey3;
        
    }
    
    
    ReapalUtil * reapalUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [reapalUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [reapalUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    [self.view endEditing:YES];
    
    // 支付
//     [[UnionSdk defaultSdk]];
    
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
