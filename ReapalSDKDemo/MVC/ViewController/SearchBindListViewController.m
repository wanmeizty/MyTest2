//
//  SearchBindListViewController.m
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/21.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "SearchBindListViewController.h"

#import "GoodsOrder.h"

#import "ReapalSdk.h"

#import "ReapalUtil.h"

#import "DebitCardViewController.h"

#import "PayViewController.h"



@interface SearchBindListViewController ()
{
    GoodsOrder * _order;
}
@end

@implementation SearchBindListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"查询绑卡";

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"❌" style:UIBarButtonItemStylePlain target:self action:@selector(closeSDK)];
    
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (void)closeSDK{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)createUI{
    
    NSArray * titles = @[@"会员号",@"商户ID",@"商品名称",@"商品描述",@"交易金额￥"];
    NSArray * contents = @[@"1234567890002",@"100000000009085",@"t33257",@"yyyy",@"1"];
    int i = 0;
    for (NSString * title in titles) {
        
        UILabel * moneyLabel = [[UILabel alloc] initWithFrame:GTRectMake(20, 20 + 40 * i, 70, 30)];
        //        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.text =title;
        moneyLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:moneyLabel];
        
        UITextField * textField = [[UITextField alloc] initWithFrame:GTRectMake(100, 20 + 40 * i, self.view.frame.size.width - 100 - 20, 30)];
        
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.tag = 100 + i;
        textField.text = contents[i];
        [self.view addSubview:textField];
        
        i ++;
        
    }
    
    
    UIButton * bindcardBtn = [[UIButton alloc] initWithFrame:GTRectMake(20, 20 + 40 * i + 10  , self.view.frame.size.width - 40, 30)];
    bindcardBtn.backgroundColor = [UIColor grayColor];
    [bindcardBtn setTitle:@"确认" forState:UIControlStateNormal];
    
    [bindcardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [bindcardBtn addTarget:self action:@selector(searchBindCardList) forControlEvents:UIControlEventTouchUpInside];
    //    bindcardBtn.layer.masksToBounds = YES;
    //    bindcardBtn.layer.cornerRadius = 10;
    [self.view addSubview:bindcardBtn];
    
    
}

- (void)searchBindCardList{
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
    
    
    goodOrder.bank_card_type = @"0"; // 卡类型
    
    UITextField * text = [self.view viewWithTag:100];
    goodOrder.member_id = text.text;  //@"12345678900";  // 用户ID
    UITextField * text1 = [self.view viewWithTag:101];
    goodOrder.merchant_id = text1.text;  // @"100000000009085"; // 商户ID
    
    
    
    goodOrder.bind_id = @"6024"; //绑卡ID
    goodOrder.order_no = [ReapalUtil generateTradeNO]; // 商户订单号 // @"102015061216072101"; //@"102016022910422701";//
    goodOrder.transtime = @"2015-06-12 16:52:57";
    goodOrder.currency = @"156";
    UITextField * text4 = [self.view viewWithTag:104];
    
    //    NSInteger money = [text4.text doubleValue] * 100;
    //
    //    NSString * moneyStr = [NSString stringWithFormat:@"%ld",money];
    
    goodOrder.total_fee = text4.text ;//[NSString stringWithFormat:@"%.2f",money] ; // 元  // 交易金额
    
    //    NSLog(@"%@",moneyStr);
    
    UITextField * text2 = [self.view viewWithTag:102];
    goodOrder.title =  text2.text; //@"t33257"; // 商品名称
    
    UITextField * text3 = [self.view viewWithTag:103];
    goodOrder.body = text3.text; //@"yyyy"; // 商品描述
    goodOrder.terminal_type = @"mobile";
    goodOrder.terminal_info = @"dddss-daddd";
    goodOrder.member_ip = @"192.168.1.83"; // 用户IP
    goodOrder.seller_email = @"492215340@qq.com"; // @"492215340@qq.com"; // 商户邮箱
    goodOrder.notify_url = @"http://testcashier.reapal.com/test/mobile/notify";//@"http://192.168.2.33:20009/notify.jsp"; // @"192.168.1.1"; // @"http://192.168.0.173:8080/notify"; // 商户后台系统回调地址
    goodOrder.token_id = @"11534545fdsfsda";
    //    goodOrder.version = @"3.0";
    
    _order = goodOrder;
    
    GoodsOrder * searchOrder = [[GoodsOrder alloc] init];
    
    
    
    searchOrder.bank_card_type = goodOrder.bank_card_type; // @"0" // 卡类型
    
    searchOrder.member_id = goodOrder.member_id ; //@"12345678900";  // 用户ID
    
    searchOrder.merchant_id = goodOrder.merchant_id; // @"100000000009085"; // 商户ID
    
    NSString * calibrateKey = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809";// 安全校验码
    
    ReapalUtil * reapalUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [reapalUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [reapalUtil encodeOrder:searchOrder andCalibratekey:calibrateKey];
    
    //    [self.view endEditing:YES];
    
    //        NSLog(@"%@",params);
    
    // 绑卡请求
    [[ReapalSdk defaultSdk] searchBindCardlistWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
       
        if (resultDic == nil) {
            //             [self performSelectorOnMainThread:@selector(goPay) withObject:nil waitUntilDone:YES];
            return ;
        }
        
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [reapalUtil rsaDecryptContent:encryptkey];
        
        //        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
//        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
//        
//        NSString * deDataStr = [reapalUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        NSString * deDataStr = [reapalUtil decryptAESWithString:dataStr app_key:decryptKeyStr];
        //        NSLog(@"解密数据==>%@",deDataStr);
        
        
        //        NSString * sss  = [NSString stringWithFormat:@"解密key==>%@\n\n解密数据==>%@",decryptKeyStr,deDataStr];
        //
        //        [self performSelectorOnMainThread:@selector(getData:) withObject:sss waitUntilDone:YES];
        
        
        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
        
        
                        NSLog(@"%@",myDict);
        
        NSArray * cardList = [myDict objectForKey:@"bind_card_list"];
        
        
        
        
//        for (NSDictionary * subDic in cardList) {
//
//            if ([subDic[@"bind_id"] isEqualToString:goodOrder.bind_id]) {
//                
//                // 绑过卡
////                                _cardInfo = subDic;
//                                NSLog(@"%@",subDic);
//                                NSLog(@"%@",subDic[@"bank_name"]);
//                
//                
//                
//                [self performSelectorOnMainThread:@selector(goPay) withObject:nil waitUntilDone:YES];
//                
//                
//                return ;
//                
//            }
//            
//        }
        if (cardList.count > 0) {
            
            // 绑过卡
            
            [self performSelectorOnMainThread:@selector(goPay) withObject:nil waitUntilDone:YES];
            
        }else{
            
            // 没有绑过卡
            
            [self performSelectorOnMainThread:@selector(goDebit) withObject:nil waitUntilDone:YES];
            
        }
       
        
    }];
}

- (void)goPay{
    
    PayViewController * payVC = [[PayViewController alloc] init];
    
    payVC.order = _order;
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}

- (void)goDebit{
    
    DebitCardViewController * debitVC = [[DebitCardViewController alloc] init];
    
    debitVC.order = _order;
    
    [self.navigationController pushViewController:debitVC animated:YES];
    
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
