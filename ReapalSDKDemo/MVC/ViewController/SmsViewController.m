//
//  SmsViewController.m
//  TestZ
//
//  Created by wanmeizty on 16/2/29.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "SmsViewController.h"

#import "ReapalUtil.h"

#import "PayViewController.h"

#import "GTMBase64.h"


#import "ReapalSdk.h"

@interface SmsViewController ()
{
    UITextField * _securyTextField;
    UILabel * _smsBtn;
    NSTimer * _timer;
    UITextField * _calibrate;
}
@end

@implementation SmsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self createUI];

    
    // Do any additional setup after loading the view.
}

- (void)createUI{
    
    UILabel * cardTypeLabel = [[UILabel alloc] initWithFrame:GTRectMake(10, 70, self.view.frame.size.width - 20, 40)];
    cardTypeLabel.text = @"  农业银行";
    cardTypeLabel.textColor = [UIColor blackColor];
    cardTypeLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cardTypeLabel];
    
    UIView * view = [[UIView alloc] initWithFrame:GTRectMake(10, 120, self.view.frame.size.width - 20, 190)];
    
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    
    
    NSArray * titles = @[@"卡号:",@"姓名:",@"证件类型:",@"证件号码:",@"手机号码:"];
    
    NSMutableString * cardStr = [[NSMutableString alloc] initWithString:self.order.card_no];
    
    [cardStr replaceCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
    
    NSMutableString * certStr = [[NSMutableString alloc] initWithString:self.order.cert_no];
    
    [certStr replaceCharactersInRange:NSMakeRange(10, 8) withString:@"********"];
    
    NSArray * texts = @[cardStr,self.order.owner,@"身份证",certStr,self.order.phone];
    



    
    
    int i = 0;
    for (NSString * title in titles) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:GTRectMake(10, 30 * i, 80, 30)];
        
        label.text = title;
        
        label.textColor = [UIColor blackColor];
        
        [view addSubview:label];
        
        UILabel * secondLabel = [[UILabel alloc] initWithFrame:GTRectMake(self.view.frame.size.width - 30 - 200, 30 * i, 200, 30)];
        secondLabel.textAlignment = NSTextAlignmentRight;
        secondLabel.font = [UIFont systemFontOfSize:14];
        secondLabel.text = texts[i];
        [view addSubview:secondLabel];
        
        i ++;
        
    }
    
    // UITextField *
    _calibrate = [[UITextField alloc] initWithFrame:GTRectMake(10, 30 * i, self.view.frame.size.width - 160, 30)];
    
    _calibrate.borderStyle = UITextBorderStyleRoundedRect;
    _calibrate.placeholder = @"请输入您的验证码";
    [view addSubview:_calibrate];
    
    
    _smsBtn = [[UILabel alloc] initWithFrame:GTRectMake(self.view.frame.size.width - 130, 30 * i, 100, 30)];
    _smsBtn.text = @"获取验证码";
    _smsBtn.font = [UIFont systemFontOfSize:16];
    _smsBtn.textAlignment = NSTextAlignmentCenter;
    _smsBtn.textColor = [UIColor whiteColor];
    _smsBtn.backgroundColor = [UIColor redColor];
    [view addSubview:_smsBtn];
    
    _smsBtn.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getSMS2)];
    
    [_smsBtn addGestureRecognizer:singleTap];
    
    

    
    
    UIButton * sureBtn = [[UIButton alloc] initWithFrame:GTRectMake(20, view.frame.origin.y + view.frame.size.height + 10, self.view.frame.size.width - 40, 40)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:sureBtn];
    
}


// 确认支付
- (void)sure{
    
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
    goodOrder.merchant_id = self.order.merchant_id;
    goodOrder.order_no = self.order.order_no;
    goodOrder.check_code = _calibrate.text;
    goodOrder.card_no = self.order.card_no;
    goodOrder.owner = self.order.owner;
    goodOrder.cert_no = self.order.cert_no;
    goodOrder.phone = self.order.phone;

    goodOrder.version = self.order.version;
    

    
    
    
    NSString * calibrateKey = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809"; // 安全校验码
    
    ReapalUtil * reapalUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [reapalUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [reapalUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    [self.view endEditing:YES];
    
    // 确认支付
    [[ReapalSdk defaultSdk] payWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
        
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [reapalUtil rsaDecryptContent:encryptkey];
        
        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
        
        NSString * deDataStr = [reapalUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);
        
    }];
}


- (void)zdigital:(UIButton *)btn{
    
    if (_securyTextField.text.length >= 6) {
        
        return ;
        
    }
    
    _securyTextField.text = [NSString stringWithFormat:@"%@%@",_securyTextField.text,btn.titleLabel.text];
    
    
}

- (void)delete{
    
    NSLog(@"delete");
   
    if (_securyTextField.text.length <1) {
        return ;
    }
    
    _securyTextField.text = [_securyTextField.text substringToIndex:_securyTextField.text.length - 1];
    
}

- (void)deleteAll{
    
    NSLog(@"deleteAll");
    _securyTextField.text = @"";
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (void)getSMS2{
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    goodOrder.merchant_id = self.order.merchant_id;
    //    goodOrder.card_no = self.order.card_no;
    //    goodOrder.bind_id = self.order.bind_id;
    //    goodOrder.member_id = self.order.member_id;
    goodOrder.order_no = self.order.order_no;
    //    goodOrder.terminal_type = self.order.terminal_type;
    //    goodOrder.version = self.order.version;
    
    NSString * calibrateKey = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809"; // 安全校验码
    
    ReapalUtil * realpalUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [realpalUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [realpalUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    [self.view endEditing:YES];
    
    [[ReapalSdk defaultSdk] smsWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
    
        if (resultDic == nil) {
            //             [self performSelectorOnMainThread:@selector(goPay) withObject:nil waitUntilDone:YES];
            return ;
        }
        
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [realpalUtil rsaDecryptContent:encryptkey];
        
        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
        
        NSString * deDataStr = [realpalUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);
        
        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
        
        
        NSLog(@"%@",myDict);
        
    }];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];

    
}

- (void)getSMS{
    
    

    
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
    goodOrder.merchant_id = self.order.merchant_id;
    goodOrder.order_no = self.order.order_no;
    
    
    NSString * calibrateKey = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809"; // 安全校验码
    
    ReapalUtil * reapalUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [reapalUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [reapalUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    // 支付
    [[ReapalSdk defaultSdk] bindCardWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
       
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [reapalUtil rsaDecryptContent:encryptkey];
        
        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
        
        NSString * deDataStr = [reapalUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);
        

    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
//    _smsBtn.titleLabel.text =
}

- (void)updateTime{
    
    static NSInteger k = 61;
    
    k --;
    
    _smsBtn.text = [NSString stringWithFormat:@"重新发送%ld",k];
    if (k == 0) {
        
        _smsBtn.text = @"重新发送";
        [_timer setFireDate:[NSDate distantFuture]];
        
        k = 61;
        
    }
    
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
