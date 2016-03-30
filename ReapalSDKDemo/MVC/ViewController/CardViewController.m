//
//  CardViewController.m
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/28.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "CardViewController.h"


#import "DebitCardViewController.h"

#import "CreditViewController.h"


@interface CardViewController ()
{
    UITextField * _textFiled;
}
@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"❌" style:UIBarButtonItemStylePlain target:self action:@selector(closeSDKVC)];

    [self createUI];
    
    // Do any additional setup after loading the view.
}

- (void)goToBack{
    
    if ([self isKindOfClass:[CardViewController class]] && self.isNotFirst == NO) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)createUI{
    
    [self createViewWithTitle:self.order.title orderNO:self.order.order_no totalFee:self.order.total_fee];
    
    UILabel * cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 80, 40)];
    
    cardLabel.text = @"银行卡号";
    cardLabel.font = [UIFont systemFontOfSize:14];
    [self.mainView addSubview:cardLabel];
    
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(80, 60, zwidth - 90, 40)];
    
    textFiled.placeholder = @"请输入银行卡号";
//    textFiled.borderStyle = UITextBorderStyleRoundedRect;
    _textFiled = textFiled;
    textFiled.clearButtonMode = UITextFieldViewModeAlways;
    [self.mainView addSubview:textFiled];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 140, zwidth - 40, 40)];
    
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    [btn addTarget:self action:@selector(searchCardInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:btn];
    
    
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

- (void)searchCardInfo{
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
    goodOrder.merchant_id = self.order.merchant_id;//@"100000000009085"; // 商户ID
    

    goodOrder.card_no = _textFiled.text ;//@"622908328856102214";
    
    //    NSString * calibrateKey = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809"; // 安全校验码
    
    
    NSString * calibrateKey = [self selectCalibrate:goodOrder.merchant_id];
    
    NSLog(@"%@",calibrateKey);
    
    ReapalUtil * unionUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [unionUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [unionUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    
    
    [[ReapalSdk defaultSdk] bankCardWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
        
        if (resultDic == nil) {
            
            NSLog(@"数据为空");
            
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
        
        
        if ([myDict[@"bank_card_type"] isEqualToString:@"0"]) {
            
            // 储蓄卡
            [self performSelectorOnMainThread:@selector(debitView) withObject:nil waitUntilDone:YES];
            
        }else{
            
            // 信用卡
            [self performSelectorOnMainThread:@selector(creditView) withObject:nil waitUntilDone:YES];
            
        }
        
//        [self performSelectorOnMainThread:@selector(refeshText) withObject:nil waitUntilDone:YES];
        
    }];
    
}

- (void)creditView{
    
    CreditViewController * creditVC = [[CreditViewController alloc] init];
    
    
    creditVC.order = self.order;
    
    [self.navigationController pushViewController:creditVC animated:YES];
    
}

- (void)debitView{
    
    DebitCardViewController * debitView = [[DebitCardViewController alloc] init];
    
    debitView.order = self.order;
    
    [self.navigationController pushViewController:debitView animated:YES];
    
}

- (void)closeSDKVC{
    
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
