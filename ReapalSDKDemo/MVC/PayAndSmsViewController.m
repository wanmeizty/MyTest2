//
//  PayAndSmsViewController.m
//  ReapalSDKDemo
//
//  Created by 一米阳光 on 16/3/28.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "PayAndSmsViewController.h"

#import "GoodsOrder.h"

#import "ReapalUtil.h"

#import "ReapalSdk.h"

#import "PayResultViewController.h"

#import "PaySuccessViewController.h"

#import "GTMBase64.h"

@interface PayAndSmsViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UITextField *IdentifyingCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIView *massageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

static int stopSendNum = 1;

@implementation PayAndSmsViewController
{
    NSArray * _titles;
    
    NSArray * _contents;
    
    NSArray * _payTitles;
    
    NSArray * _payContents;
    
    NSTimer * _timer;
    
    UITextRange * previousSelection;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self initData];
    
    [self initUI];
    
    
    
    [self sendMassageTime];
    
    
    
}

- (void)initUI
{
    
    
    NSString * phoneNumHead= [self.order.phone substringToIndex:3];//截取掉下标7之后的字符串
    NSString * phoneNumFoot = [self.order.phone substringFromIndex:7];//截取掉下标2之前的字符串
    self.remindLabel.text = [[NSString alloc] initWithFormat:@"    为了保障您的用卡安全，本次交易需要短信确认，验证码已发送至手机%@****%@",phoneNumHead,phoneNumFoot];
    
    
    
    [self initWithLabel:self.remindLabel WithAllString:self.remindLabel.text WithEditString:[NSString stringWithFormat:@"%@****%@",phoneNumHead,phoneNumFoot] WithColor:[UIColor orangeColor]];
    
    
    
    self.timeLabel.text = @"获取验证码";
    self.timeLabel.font = [UIFont systemFontOfSize:16];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor blueColor];
    self.timeLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendMassageTime)];
    
    [self.timeLabel addGestureRecognizer:singleTap];
    
    self.payButton.enabled = NO;
    self.payButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
    self.IdentifyingCodeTextField.delegate = self;
    previousSelection = self.IdentifyingCodeTextField.selectedTextRange;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length - range.length == 0 && range.length != 0){
        
        self.payButton.enabled = NO;
        self.payButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
        
    }else{
        
        self.payButton.enabled = YES;
        self.payButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_03.png"]];
        
    }
    
    if (textField.text.length >= 6 && range.length == 0) {
        
        return NO;
        
    }
    
    return YES;
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    self.payButton.enabled = NO;
    self.payButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
    
    return YES;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if (![touch.view isKindOfClass: [UITextField class]] || ![touch.view isKindOfClass: [UITextView class]]) {
        
        [self.view endEditing:YES];
        
    }
    
}

-(void)initWithLabel:(UILabel *)label WithAllString:(NSString *)allString WithEditString:(NSString *)editString WithColor:(UIColor *)color

{
    
    if (self)
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allString];
        [str addAttribute:NSForegroundColorAttributeName value:color range:[allString rangeOfString:editString]];
        label.attributedText = str;
        
        // UIFont *font = [UIFont systemFontOfSize:12];
        
    }

    
}





- (void)sendMassageTime
{
    stopSendNum++;
    if (stopSendNum < 5) {
        [self sendMSGTest];
    }
    
  
}



- (void)initData
{
    _titles = @[@"商户ID",@"订单号"];
    _contents = @[@"100000000009085",@"MP1Q7QO420H0RPND6YD5"];
    
    _payTitles = @[@"商户ID",@"卡号",@"持卡人",@"身份证",@"手机号",@"订单号",@"验证码",@"有效期"];
    _payContents = @[@"100000000009085",@"6217000010066764658",@"张庭勇",@"5622567743366363452",@"18363852573",@"MP1Q7QO420H0RPND6YD2",@"434526",@"0221"];
    
}



- (IBAction)surePay:(id)sender {
    [self payTest];
}

// 发送短信接口
- (void)sendMSGTest{
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    goodOrder.merchant_id = _contents[0]; // @"100000000009085"; // 商户ID
    goodOrder.order_no = _contents[1]; //
    
    NSString * calibrateKey = [self selectCalibrate:goodOrder.merchant_id];
    
    ReapalUtil * unionUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [unionUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [unionUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    [self.view endEditing:YES];
    
    // 支付
    [[ReapalSdk defaultSdk] smsWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
        
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [unionUtil rsaDecryptContent:encryptkey];
        
        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
        
        NSString * deDataStr = [unionUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);

        
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime3) userInfo:nil repeats:YES];
}

- (void)updateTime3{
    
    static NSInteger k = 5;
    
    k --;
    self.timeLabel.userInteractionEnabled = NO;
    self.timeLabel.enabled = NO;
    self.timeLabel.text = [NSString stringWithFormat:@"(%ld)秒后重发",k];
    
    if (k == 0) {
        if (stopSendNum == 4) {
            self.timeLabel.userInteractionEnabled = NO;
            self.timeLabel.enabled = NO;
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"您本次订单请求次数过多，请在一个小时后重新请求" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            
            [alter show];
            
        }else{
            self.timeLabel.enabled = YES;
            self.timeLabel.userInteractionEnabled = YES;
        }
        self.timeLabel.text = @"获取验证码";
        [_timer setFireDate:[NSDate distantFuture]];
        
        
        k = 5;
        
        
    }
    
    
    
}



// 确认支付接口
- (void)payTest{
    
    //    NSArray * titles = @[@"商户ID",@"卡号",@"持卡人",@"身份证",@"手机号",@"订单号",@"验证码",@"信用卡尾号3位",@"有效期"];
    //    NSArray * contents = @[@"100000000009085",@"6217000010066764658",@"张庭勇",@"5622567743366363452",@"18363852573",@"MP1Q7QO420H0RPND6YD2",@"434526",@"417",@"0221"];
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    goodOrder.merchant_id = self.order.merchant_id; //@"100000000009085"; // 商户ID
    
    goodOrder.order_no = self.order.order_no; // @"MP1Q7QO420H0RPND6YD2"; //[UnionPayUtil generateTradeNO];
    
    goodOrder.check_code = [NSString stringWithFormat:@"%@",self.IdentifyingCodeTextField.text]; //@"434526";
    goodOrder.card_no = self.order.card_no; //@"6217000010066764658";
    goodOrder.owner = self.order.owner; //@"zty"; //self.order.owner;
    goodOrder.cert_no = self.order.cert_no; //@"426754534534534545"; //self.order.card_no;
    goodOrder.phone = self.order.phone; // @"18314533172"; //self.order.phone;
    goodOrder.version = self.order.version;
    if ([self.order.bank_card_type isEqualToString:@"1"]) {
        goodOrder.cvv2 = self.order.cvv2;
        goodOrder.validthru = self.order.validthru;
    }
//    goodOrder.cvv2 = [goodOrder.card_no substringWithRange:NSMakeRange(goodOrder.card_no.length - 3, 3)];//@"417";
//    goodOrder.validthru = _payContents[7]; //@"0221";
  
    
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
        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
        
        NSString * deDataStr = [unionUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);
        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
        NSString * myMsgStr = myDict[@"result_code"];
        
        
        if ([myMsgStr isEqualToString:@"0000"]) {
            [self performSelectorOnMainThread:@selector(payResult) withObject:nil waitUntilDone:YES];
        }
        
        
        
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

- (void)payResult
{
//    PayResultViewController * payResultVC = [[PayResultViewController alloc] init];
//    
//    payResultVC.order = self.order;
//    
//    [self.navigationController pushViewController:payResultVC animated:YES];
    PaySuccessViewController * paySucc = [[PaySuccessViewController alloc] init];
    
    paySucc.order = self.order;
    
    [self.navigationController pushViewController:paySucc animated:YES];
    
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
