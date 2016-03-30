//
//  BindCardViewController.m
//  TestZ
//
//  Created by wanmeizty on 16/2/29.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "DebitCardViewController.h"

#import "ProtocolViewController.h"

#import "SmsViewController.h"


#import "ReapalUtil.h"

#import "ReapalSdk.h"

#import "GTMBase64.h"


#import "SmsViewController.h"

#import "PayViewController.h"

#import "MoneyView.h"


@interface DebitCardViewController ()<UITextFieldDelegate>
{
    UIButton * _selectBtn;
    BOOL _isRead;
    
//    UIView * _infoView;
    
    UIButton * _nextBtn;
    
//    BOOL _isUnfold;
    
    NSDictionary * _bankInfo;
    
//    MoneyView * _moneyView;
    
}
@end

@implementation DebitCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.title = @"签约";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popView)];
    
//    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    
//    [backBtn setImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.navigationController.navigationBar addSubview:backBtn];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];//WithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popView)];
    
    [self createUI];
}

- (void)popView{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (void)createUI{
    
    
    [self createViewWithTitle:self.order.title orderNO:self.order.order_no totalFee:self.order.total_fee];
    
//    UIView * headView = [[UIView alloc] initWithFrame:GTRectMake(0, 0, self.view.frame.size.width, 90)];
//    headView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:headView];
//    NSArray * array = @[@"商品名称",@"订单号"];
//    for (int i = 0; i < array.count; i ++) {
//        
//        UILabel * headLabel = [[UILabel alloc] initWithFrame:GTRectMake(10, 10 + i * 40, self.view.frame.size.width - 20, 30)];
//        [headView addSubview:headLabel];
//        if (i == 0) {
//            
//            headLabel.text = [NSString stringWithFormat:@"%@:    %@",array[i],self.order.title];
//            
//        }else if(i == 1){
//            
//            headLabel.text = [NSString stringWithFormat:@"%@:    %@",array[i],self.order.order_no];
//            
//        }
//        
//        UILabel * myline = [[UILabel alloc] initWithFrame:GTRectMake(10, 40 + i * 45, self.view.frame.size.width - 10, 1)];
//        myline.backgroundColor = [UIColor lightGrayColor];
//        [self.view addSubview:myline];
//        
//        
//        
//    }
//    
//    _infoView = [[UIView alloc] initWithFrame:GTRectMake(0, 0 , self.view.frame.size.width, 340)];
//    
//    _infoView.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:_infoView];
//    
//    MoneyView * moneyView = [[MoneyView alloc] initWithFrame:GTRectMake(0, 0, zwidth, 40)];
//    moneyView.totalFeeLabel.text = [NSString stringWithFormat:@"应付金额：￥%.2f",[self.order.total_fee doubleValue]];
//    
//    _moneyView = moneyView;
//    
//    moneyView.imageView.image = [UIImage imageNamed:@"down.png"];
//    [_infoView addSubview:moneyView];
//    
//    
//    _isUnfold = NO;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unfold)];
//    [moneyView addGestureRecognizer:tap];
//    
//    
//    
//    UILabel * label = [[UILabel alloc] initWithFrame:GTRectMake(0, 40, self.view.frame.size.width, 10)];
//    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [_infoView addSubview:label];

    
    NSArray * titles = @[@"卡号",@"姓名",@"身份证",@"手机号"];
    
//    NSArray * contents = @[@"持卡人卡号",@"付款银行卡的开户姓名",@"办理该银行卡的身份证号",@"该卡在银行的预留手机号"];
    
    NSArray * contents = @[@"6228480263096220417",@"张庭勇",@"522122199303072537",@"18363852573"];
    
    int i = 0;
    for (NSString * title in titles) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:GTRectMake(20, 60 +45 * i, 80, 40)];
        
        label.text = title;
        
        label.textColor = [UIColor blackColor];
        
        [self.mainView addSubview:label];
        
        if (i == titles.count - 1) {
            
            
        }else{
            
            UILabel * lineLabel = [[UILabel alloc] initWithFrame:GTRectMake(20, 60 +45 * i + 40 , self.view.frame.size.width - 30, 1)];
            
            lineLabel.backgroundColor = [UIColor lightGrayColor];
            
            [self.mainView addSubview:lineLabel];
            
        }
        
        
        UITextField * textField = [[UITextField alloc] initWithFrame:GTRectMake(100,60 + 45 * i, self.view.frame.size.width - 110, 40)];
        
        if (i == 0) {
            textField.delegate = self;
        }
        
        if (i == 3) {
            textField.frame = GTRectMake(100,60 + 45 * i, zwidth - 130, 40);
            
            UIButton * questBtn = [[UIButton alloc] initWithFrame:GTRectMake(zwidth - 40,60+ 45 * i + 5, 40, 30)];
            
            [questBtn setTitle:@"❓" forState:UIControlStateNormal];
            
            [questBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [questBtn addTarget:self action:@selector(quest) forControlEvents:UIControlEventTouchUpInside];
//            questBtn.backgroundColor = [UIColor redColor];
            [self.mainView addSubview:questBtn];
            
            
            
        }
        textField.text = contents[i];
//        textField.placeholder = contents[i];
//        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.clearButtonMode = UITextFieldViewModeAlways; //UITextFieldViewModeWhileEditing;
        textField.tag = i + 9;
        [self.mainView addSubview:textField];
        
        i ++;
        
    }
    
    UIView * readView = [[UIView alloc] initWithFrame:GTRectMake(0,60+ 180, self.view.frame.size.height, 100)];
    readView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.mainView addSubview:readView];
    
    _selectBtn =[[UIButton alloc] initWithFrame:GTRectMake(10, 10, 30, 30)];
    [_selectBtn setImage:[UIImage imageNamed:@"isRead_selectedButton@2x.png"] forState:(UIControlStateNormal)];
    [_selectBtn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    _isRead = YES;
    [readView addSubview:_selectBtn];
    
    
    UILabel * readLabel = [[UILabel alloc] initWithFrame:GTRectMake(40, 10, 40, 30)];
    
    readLabel.text = @"阅读";
    readLabel.font = [UIFont systemFontOfSize:14];
    [readView addSubview:readLabel];
    
    UIButton * protocelBtn = [[UIButton alloc] initWithFrame:GTRectMake(60, 10, 180, 30)];
    protocelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    protocelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [protocelBtn setTitle:@"《融宝快捷支付服务协议》" forState:UIControlStateNormal];
    [protocelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [protocelBtn addTarget:self action:@selector(myprotocol) forControlEvents:UIControlEventTouchUpInside];
    [readView addSubview:protocelBtn];
    
    
    
    UIButton * nextBtn = [[UIButton alloc] initWithFrame:GTRectMake(30, 50, self.view.frame.size.width - 60, 30)];
    _nextBtn = nextBtn;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor blueColor]];
    [nextBtn addTarget:self action:@selector(bindNext) forControlEvents:UIControlEventTouchUpInside];
    [readView addSubview:nextBtn];

    
}




- (void)quest{
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"银行预留手机号说明" message:@"银行预留的手机号是办理该银行卡时所填写的手机号。没有预留、手机号忘记或者已停用，请联系银行客服更新处理。95599" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    
    [alertView show];
    
}

- (void)updateCard{
    
    
    
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

- (void)bindNext{
    
    
    if (!_isRead) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请同意融宝支付协议" message:@"" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        
        [alert show];
        
        return ;
        
        
    }
    
    


    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
    goodOrder.merchant_id = self.order.merchant_id;
    UITextField * card = [self.mainView viewWithTag:9];
    
    NSMutableString * cardnumber = [[NSMutableString alloc] initWithString:card.text];
    
    [cardnumber replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, card.text.length - 1)];
    
    self.order.card_no = cardnumber;
    goodOrder.card_no = cardnumber;//self.order.card_no;
    UITextField * text = [self.mainView viewWithTag:10];
    goodOrder.owner = text.text; //self.order.owner;
    goodOrder.cert_type = @"01"; //self.order.cert_type;
    UITextField * text1 = [self.mainView viewWithTag:11];
    goodOrder.cert_no = text1.text; //self.order.card_no;
    
    UITextField * text2 = [self.mainView viewWithTag:12];
    goodOrder.phone = text2.text; //self.order.phone;
    goodOrder.order_no = self.order.order_no;
    goodOrder.transtime = self.order.transtime;
    goodOrder.currency = self.order.currency;
    goodOrder.total_fee = self.order.total_fee;
    goodOrder.title = self.order.title;
    goodOrder.body = self.order.body;
    goodOrder.member_id = self.order.member_id;
    goodOrder.terminal_info = self.order.terminal_info;
    goodOrder.terminal_type = self.order.terminal_type;
    goodOrder.member_ip = self.order.member_ip;
    goodOrder.seller_email = self.order.seller_email;
    goodOrder.notify_url = self.order.notify_url;
    goodOrder.token_id = self.order.token_id;
    goodOrder.version = @"3.1.2";

    
    // 信用卡
//    goodOrder.cvv2 = [goodOrder.card_no substringFromIndex:goodOrder.card_no.length - 3];
//    
//    goodOrder.validthru = @"0221";
    if (goodOrder.card_no.length < 19) {
        
        
        NSLog(@"%ld",goodOrder.card_no.length);
        NSLog(@"%@",goodOrder.card_no);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的卡号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        return ;
    }
    
    if ([goodOrder.owner isEqualToString:@""]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的姓名" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        return ;
        
    }
    
    if (goodOrder.cert_no.length != 18) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的身份证号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        return ;
    }
    
    if (goodOrder.phone.length != 11) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        return ;
    }
    
    self.order = goodOrder;

    
    
    
    NSString * calibrateKey = [self selectCalibrate:self.order.merchant_id];// 安全校验码
    
    ReapalUtil * reapalUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [reapalUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [reapalUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    
    // 储蓄卡签约请求
    
    [[ReapalSdk defaultSdk] debitWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
       
        if (resultDic == nil) {
            //             [self performSelectorOnMainThread:@selector(goPay) withObject:nil waitUntilDone:YES];
            return ;
        }
        
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [reapalUtil rsaDecryptContent:encryptkey];
        
        //        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
        
        NSString * deDataStr = [reapalUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        //        NSLog(@"解密数据==>%@",deDataStr);
        
        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
        
        NSLog(@"%@",myDict);
        NSLog(@"%@",myDict[@"result_msg"]);
        
        _bankInfo = myDict;
        // 签约成功
        if ([myDict[@"result_code"] isEqualToString:@"0000"]) {
            
            self.order.bind_id = myDict[@"bind_id"];
            
            
            [self performSelectorOnMainThread:@selector(goToPayView) withObject:nil waitUntilDone:YES];
        }
        
    }];
    
    
//    [[ReapalSdk defaultSdk] creditWithDictionary:params callback:^(NSDictionary *resultDic) {
//       
//        if (resultDic == nil) {
//            //             [self performSelectorOnMainThread:@selector(goPay) withObject:nil waitUntilDone:YES];
//            return ;
//        }
//        
//        NSString * dataStr = resultDic[@"data"];
//        
//        NSString * encryptkey = resultDic[@"encryptkey"];
//        
//        NSString * decryptKeyStr = [reapalUtil rsaDecryptContent:encryptkey];
//        
//        //        NSLog(@"解密key==>%@",decryptKeyStr);
//        
//        // 解密：
//        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
//        
//        NSString * deDataStr = [reapalUtil decryptAESData:EncryptData app_key:decryptKeyStr];
//        
//        //        NSLog(@"解密数据==>%@",deDataStr);
//        
//        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
//        
//        NSLog(@"%@",myDict);
//        NSLog(@"%@",myDict[@"result_msg"]);
//        
//        _bankInfo = myDict;
//        // 签约成功
//        if ([myDict[@"result_code"] isEqualToString:@"0000"]) {
//            
//            self.order.bind_id = myDict[@"bind_id"];
//            
//            
//            [self performSelectorOnMainThread:@selector(goPay) withObject:nil waitUntilDone:YES];
//        }
//
//        
//    }];
    
    


}



- (void)goToPayView{
    
    PayViewController * payVC = [[PayViewController alloc] init];
    
    payVC.order = self.order;
    
    payVC.cardInfo = _bankInfo;
    
    [self.navigationController pushViewController:payVC animated:YES];
    
//    SmsViewController * smsVC = [[SmsViewController alloc] init];
//    
//    smsVC.order = self.order;
//    
//    [self.navigationController pushViewController:smsVC animated:YES];
    
}




- (void)myprotocol{
    
    ProtocolViewController * protocolVC = [[ProtocolViewController alloc] init];
    
    [self.navigationController pushViewController:protocolVC animated:YES];
    
}

- (void)buttonClicked{
    
    if (_isRead) {
        
        [_selectBtn setImage:[UIImage imageNamed:@"isRead_waiting_selectButton@2x"] forState:UIControlStateNormal];
        
        _nextBtn.backgroundColor = [UIColor grayColor];
        _nextBtn.enabled = NO;
        _isRead = NO;
    }else{
        
        [_selectBtn setImage:[UIImage imageNamed:@"isRead_selectedButton@2x"] forState:UIControlStateNormal];
        _nextBtn.backgroundColor = [UIColor blueColor];
        _isRead = YES;
        _nextBtn.enabled = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"textField==>%@",textField.text);
    
    NSMutableString * mutStr = [[NSMutableString alloc] initWithString:textField.text];
    //    [self addOrRemove:textField.text];
    
    NSInteger location = range.location;
    
    
    //    NSLog(@"string==>%@",string);
    //
    NSLog(@"%ld---%ld",range.length,range.location);
    
    if (range.length > 0) {
        
        //        if (textField.text.length > 0) {
        //
        //            [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, textField.text.length - 1)];
        //        }
        //
        //        for (int i = 0; i < textField.text.length; i ++) {
        //
        //            if (i % 5 == 4) {
        //                [mutStr insertString:@" " atIndex:i];
        //            }
        //
        //        }
        
        [self remove:textField.text andRange:range];
        
        
    }else{
        
        [self add:textField.text];
        
        //        if (  location % 5 == 4) {
        //
        ////            [mutStr insertString:@" " atIndex:location];
        //
        //            [self add:textField.text];
        //
        //        }
        
    }
    
    
    return YES;
    
}

- (void)remove:(NSString *)str andRange:(NSRange)range{
    
    NSLog(@"%@",str);
    
    NSMutableString * mutStr = [[NSMutableString alloc] initWithString:str];
//
//    if (str.length > 0) {
//        
//        [mutStr deleteCharactersInRange:range];
//        
//        
//    }
//    
//    NSLog(@"%@",mutStr);
//    
//    for (int i = 0; i < str.length; i ++) {
//        
//        if (i % 5 == 4 && range.location != i) {
//            //            [mutStr insertString:@" " atIndex:i];
//            
//            
//        }
//        
//    }
    
    UITextField * card = [self.mainView viewWithTag:9];
    
    card.text = mutStr;

    
}

- (void)add:(NSString *)str{
    
    NSMutableString * mutStr = [[NSMutableString alloc] initWithString:str];
    
    if (str.length > 0) {
        
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length - 1)];
    }
    
    NSLog(@"%@",mutStr);
    
    for (int i = 0; i < str.length; i ++) {
        
        if (i % 5 == 4) {
            [mutStr insertString:@" " atIndex:i];
        }
        
    }
    
    
    UITextField * card = [self.mainView viewWithTag:9];
    
    card.text = mutStr;
    
}

@end
