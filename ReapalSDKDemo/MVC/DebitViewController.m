//
//  DebitViewController.m
//  ReapalSDKDemo
//
//  Created by 一米阳光 on 16/3/29.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "DebitViewController.h"

#import "GoodsOrder.h"

#import "ReapalUtil.h"

#import "ReapalSdk.h"

#import "PayAndSmsViewController.h"

#import "DebitTableViewCell.h"

#import "GTMBase64.h"

#import "CardView.h"

#import "ProtocolViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "VerifyExpression.h"

@interface DebitViewController ()<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
UIAlertViewDelegate
>

@end

@implementation DebitViewController
{
    NSArray * _titles;
    
    NSArray * _contents;
    
    NSArray * _creditTitles;
    
    NSArray * _creditContents;
    
    NSArray * _dataSourceDebit;
    
    NSArray * _dataSourceCredit;
    
    UITableView * _tableView;
    
    NSString * _cardNO;
    
    NSString * _owner;
    
    NSString * _certNo;
    
    NSString * _phone;
    
    NSString * _cvv2;
    
    NSString * _validthru;
    
    UIView * _phoneTargetButton;
    
    UIView * remindView;
    
    BOOL _isSureButton;
    
    NSString    *previousTextFieldContent;
    
    UITextRange *previousSelection;
    
    UITextField * _cardNoTextField;
    
    UITextField * _certNoTextField;
    
    UITextField * _phoneTextField;
    
    UITextField * _cvvTextField;
    
    UITextField * _validthruTextField;
    
    UIButton * _nextBtn;
    
    BOOL hasOwer ;
    BOOL hasCertNo ;
    BOOL hasPhoneNum ;
    BOOL hasCvv2;
    BOOL hasValidthut;
    BOOL hasAgree;
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"❌" style:UIBarButtonItemStylePlain target:self action:@selector(closeSDKVC2)];
    
    
    
    [self initData];
    
    [self initUI];
    


}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (int i = 2; i < 7; i++) {
        UITextField * text  =  [self.view viewWithTag:i];
        [text resignFirstResponder];
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (![_tableView.subviews isKindOfClass:[UITextField class]]) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.view.bounds.size.height/2 - 60);
                         }
                         completion:nil];
        
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![_tableView.subviews isKindOfClass:[UITextField class]]) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.view.bounds.size.height/2);
                         }
                         completion:nil];
        
    }

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if (![touch.view isKindOfClass: [UITextField class]] || ![touch.view isKindOfClass: [UITextView class]]) {
        
        [self.view endEditing:YES];
        
    }
    
}


- (void)initData
{

    _titles = @[@"会员号",@"商户ID",@"商品名称",@"商品描述",@"交易金额￥",@"卡号",@"持卡人",@"身份证",@"手机号"];
    
    _dataSourceDebit = @[@"发卡行",@"卡号",@"姓名",@"身份证",@"手机号"];
    
    _dataSourceCredit = @[@"发卡行",@"卡号",@"姓名",@"身份证",@"卡后三位",@"卡有效期",@"手机号"];

    _isSureButton = YES;
}

- (void)initUI
{



    [self createViewWithTitle:self.order.title orderNO:self.order.order_no totalFee:self.order.total_fee];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //tableview尾标题
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 100,[UIScreen mainScreen].bounds.size.width, 100)];
    
    //同意协议
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(10, 10, 30, 30);
    [sureButton setBackgroundImage:[UIImage imageNamed:@"isRead_selectedButton@2x.png"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:sureButton];
    
    UILabel * sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 40, 30)];
    sureLabel.text = @"同意";
    sureLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:sureLabel];
    
    
    UIButton * agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.frame = CGRectMake(60, 10, 180, 30);
    [agreeButton setTitle:@"《融宝快捷支付服务协议》" forState:UIControlStateNormal];
    [agreeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:agreeButton];
    
    
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(20, 50, self.view.bounds.size.width - 40, 40);
    _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [footerView addSubview:_nextBtn];
    
    _tableView.tableFooterView = footerView;
    
    [self.mainView addSubview:_tableView];
    
    _tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTableView)];
    
    [_tableView addGestureRecognizer:singleTap];

    
}

- (void)addTableView
{
    if (![_tableView.subviews isKindOfClass:[UITextField class]]) {
        for (int i = 2; i < 7; i++) {
            UITextField * text  =  [self.view viewWithTag:i];
            [text resignFirstResponder];
        }
    }
}

- (void)agreeButtonClick:(id)sender
{
    ProtocolViewController * protocolVC = [[ProtocolViewController alloc] init];
    
    [self.navigationController pushViewController:protocolVC animated:YES];
}

- (void)sureButtonClick:(id)sender
{
    if (_isSureButton == YES) {
        [sender setBackgroundImage:[UIImage imageNamed:@"isRead_waiting_selectButton@2x"] forState:UIControlStateNormal];
//        _nextBtn.backgroundColor = [UIColor grayColor];
        _isSureButton = NO;
//        _nextBtn.enabled = NO;
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"isRead_selectedButton@2x.png"] forState:UIControlStateNormal];
//        _nextBtn.backgroundColor = [UIColor blueColor];
        _isSureButton = YES;
//        _nextBtn.enabled = YES;
    }
    
    
    if ([self.order.bank_card_type isEqualToString:@"1"]) {
        
        if (hasCertNo && hasOwer && hasPhoneNum  && hasValidthut && hasCvv2 && _isSureButton) {
            
            _nextBtn.enabled = YES;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_03.png"]];
            
        }else{
            
            _nextBtn.enabled = NO;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
        }
        
    }else{
        
        if (hasCertNo  && hasOwer  && hasPhoneNum && _isSureButton) {
            
            _nextBtn.enabled = YES;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_03.png"]];
            
        }else{
            
            _nextBtn.enabled = NO;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
        }
        
    }
    
    
}

- (void)alertShowWithTitlte:(NSString *)title{
    
    // 准备初始化配置参数

    NSString *message = @""; // @"I need your attention NOW!";
    NSString *okButtonTitle = @"确认";
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建操作
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 操作具体内容
        // Nothing to do.
    }];
    
    // 添加操作
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    [self presentViewController:alertDialog animated:YES completion:nil];
    
}

- (void)buttonClick:(id)sender
{
    
    
        
    
    NSLog(@"身份证号码%@",_certNoTextField.text);
        if (![VerifyExpression checkIdentityCardNo:_certNoTextField.text]) {
            // 验证身份证号
            
            [self alertShowWithTitlte:@"请输入正确的身份证号"];
            
            NSLog(@"%@",_certNoTextField.text);
            
            return ;
            
        }else{
            if (![VerifyExpression checkTelNumber:_phone]) {
                // 验证手机号
                [self alertShowWithTitlte:@"请输入正确的手机号"];
                
                return ;
                
            }else{

                    for (int i = 2; i < 7; i++) {
                        UITextField * text  =  [self.view viewWithTag:i];
                        [text resignFirstResponder];
                    }
        
                [self debitOrCrebit];
            }

        }
        
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numSection = 0;
    if ([self.order.bank_card_type isEqualToString:@"0"]) {
        numSection = 5;
        
    }else if ([self.order.bank_card_type isEqualToString:@"1"]){
        numSection = 7;
    }
    return numSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DebitTableViewCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DebitTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    
    if ([self.order.bank_card_type isEqualToString:@"0"]) {
         cell.titleLabel.text = _dataSourceDebit[indexPath.row];
    }else if ([self.order.bank_card_type isEqualToString:@"1"]){
        cell.titleLabel.text = _dataSourceCredit[indexPath.row];
    }
    
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    cell.textField.clearButtonMode = UITextFieldViewModeAlways;
    [cell.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textField.hidden = YES;
        cell.cardNoLabel.hidden = YES;
        cell.bankCodeImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"bank_%@",self.bankCode]];
        cell.bankName.text = self.bankName;
    }
    
    if (indexPath.row == 1) {
        cell.phoneTarget.hidden = YES;
        cell.bankCodeImg.hidden = YES;
        cell.textField.hidden = YES;
        cell.bankName.hidden = YES;
        cell.textField.placeholder = @"持卡人卡号";
        cell.cardNoLabel.text = self.order.card_no;
        _phoneTextField = cell.textField;
        _phone = cell.textField.text;
    }
    
    if (indexPath.row == 2) {
        cell.bankCodeImg.hidden = YES;
        cell.bankName.hidden = YES;
        cell.phoneTarget.hidden = YES;
        cell.cardNoLabel.hidden = YES;
        cell.textField.placeholder = @"持卡人真实姓名";
//        cell.textField.text = @"张庭勇";
        _owner = cell.textField.text;
        hasOwer = YES;

        
    }
    
    if (indexPath.row == 3) {
        cell.bankCodeImg.hidden = YES;
        cell.bankName.hidden = YES;
        cell.phoneTarget.hidden = YES;
        cell.cardNoLabel.hidden = YES;
        cell.textField.placeholder = @"持卡人身份证号";
        _certNoTextField = cell.textField;
    }
    
    if (indexPath.row == 4){
        cell.bankCodeImg.hidden = YES;
        cell.bankName.hidden = YES;
        cell.cardNoLabel.hidden = YES;
        cell.textField.placeholder = @"银行预留手机号";
        [cell.phoneTarget setBackgroundImage:[UIImage imageNamed:@"aboutPhoneNo.png"] forState:UIControlStateNormal];
        _phoneTextField = cell.textField;
        [cell.phoneTarget addTarget:self action:@selector(phoneRemind:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([self.order.bank_card_type isEqualToString:@"1"]){
        if (indexPath.row == 5){
            cell.bankCodeImg.hidden = YES;
            cell.bankName.hidden = YES;
            cell.phoneTarget.hidden = YES;
            cell.cardNoLabel.hidden = YES;
            cell.textField.placeholder = @"持卡人信用卡有效期";
            _validthruTextField = cell.textField;
        }

    }
    
    if (indexPath.row == 6) {
        cell.bankCodeImg.hidden = YES;
        cell.bankName.hidden = YES;
        cell.cardNoLabel.hidden = YES;
        cell.textField.placeholder = @"卡后三位";
        cell.phoneTarget.hidden = YES;
        _cvvTextField = cell.textField;
    }
    

    
    return cell;
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 2:
            _owner = textField.text;
            break;
        case 3:
            _certNo = textField.text;
            break;
        case 4:
            _phone = textField.text;
            break;
        case 5:
            _validthru = textField.text;
            break;
        case 6:
            _cvv2 = textField.text;
            break;
        default:
            break;
    }
}


- (void)phoneRemind:(id)sender
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"银行预留手机号说明" message:@"银行预留的手机号是办理该银行卡时所填写的手机号。\n没有预留、手机号忘记或者已停用，请联系银行客服更新处理。" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    
    [alertView show];
}

- (void)debitOrCrebit
{
    if ([self.order.bank_card_type isEqualToString:@"0"]) {
        [self debitTest];
    }else if ([self.order.bank_card_type isEqualToString:@"1"]){
        [self creditTest];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

// 储蓄卡签约支付请求接口
- (void)debitTest{
    NSLog(@"%@",_cardNO);
    //    UITextField * text = [self.view viewWithTag:100];
    //    goodOrder.member_id = text.text;  //@"12345678900";  // 用户ID
    //    UITextField * text1 = [self.view viewWithTag:101];
    //    goodOrder.merchant_id = text1.text;  // @"100000000009085"; // 商户ID
    //    goodOrder.bind_id = @"6024"; //绑卡ID
    //    goodOrder.order_no = [ReapalUtil generateTradeNO]; // 商户订单号 // @"102015061216072101"; //@"102016022910422701";//
    //    goodOrder.transtime = @"2015-06-12 16:52:57";
    //    goodOrder.currency = @"156";
    //    UITextField * text4 = [self.view viewWithTag:104];
    //
    //    goodOrder.total_fee = text4.text ;//[NSString
    //
    //    UITextField * text2 = [self.view viewWithTag:102];
    //    goodOrder.title =  text2.text; //@"t33257"; // 商品名称
    //
    //    UITextField * text3 = [self.view viewWithTag:103];
    //    goodOrder.body = text3.text; //@"yyyy"; // 商品描述
    //    goodOrder.terminal_type = @"mobile";
    //    goodOrder.terminal_info = @"dddss-daddd";
    //    goodOrder.member_ip = @"192.168.1.83"; // 用户IP
    //    goodOrder.seller_email = @"492215340@qq.com"; // @"492215340@qq.com"; // 商户邮箱
    
    //    goodOrder.notify_url = @"http://testcashier.reapal.com/test/mobile/notify";//@"http://192.168.2.33:20009/notify.jsp"; // @"192.168.1.1"; // @"http://192.168.0.173:8080/notify"; // 商户后台系统回调地址
    //    goodOrder.token_id = @"11534545fdsfsda";
    //    //    goodOrder.version = @"3.0";
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
    goodOrder.merchant_id = self.order.merchant_id; //@"100000000009085"; // 商户ID
    _cardNO = [self.order.card_no stringByReplacingOccurrencesOfString:@" " withString:@""];
    goodOrder.card_no =  _cardNO; //@"6217000010066764658";
    goodOrder.owner = _owner ;// @"张庭勇"; //self.order.owner; 
    goodOrder.cert_type = @"01"; //证件类型
    
    goodOrder.cert_no = _certNo; //@"5622567743366363452"; //self.order.card_no;
    
    goodOrder.phone = _phone; //@"18363852573"; //self.order.phone;
    goodOrder.order_no = self.order.order_no;
    goodOrder.transtime = @"2015-06-12 16:52:57";
    goodOrder.currency = @"156";//人民币
    goodOrder.total_fee = self.order.total_fee;// @"1";
    goodOrder.title = self.order.title; //@"t33257"; // 商品名称
    goodOrder.body = self.order.body; // @"yyyy"; // 商品描述
    
    goodOrder.member_id = self.order.member_id;//@"12345678900";  // 用户ID
    
    goodOrder.terminal_info = self.order.terminal_info;
    goodOrder.terminal_type = self.order.terminal_type;
    goodOrder.member_ip = self.order.member_ip; // 用户IP
    goodOrder.seller_email = self.order.seller_email; // @"492215340@qq.com"; // 商户邮箱
    goodOrder.notify_url = self.order.notify_url;
    goodOrder.token_id = self.order.token_id;
    goodOrder.version = self.order.version;
    
    
    
    //    NSString * calibrateKey = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809";// 安全校验码
    NSString * calibrateKey = [self selectCalibrate:goodOrder.merchant_id];
    
    ReapalUtil * unionUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [unionUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [unionUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    
    // 储蓄卡签约请求
    
    [[ReapalSdk defaultSdk] debitWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
        
        if (resultDic == nil) {
            NSLog(@"这个字典为空");
            return ;
        }
        
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [unionUtil rsaDecryptContent:encryptkey];
        
        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
        
        NSString * deDataStr = [unionUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);
        
        
        
        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
        
        NSLog(@"%@",myDict);
        NSLog(@"%@",myDict[@"result_msg"]);
        NSString * myMsgStr = myDict[@"result_code"];
        
        
        if ([myMsgStr isEqualToString:@"0000"]) {
            [self performSelectorOnMainThread:@selector(payAndSms) withObject:nil waitUntilDone:YES];
        }
        
        
        
        
    }];
}

// 信用卡签约支付请求接口
- (void)creditTest{
    
    //    NSArray * titles = @[@"会员号",@"商户ID",@"商品名称",@"商品描述",@"交易金额￥",@"卡号",@"持卡人",@"身份证",@"手机号",@"日期"];
    //    NSArray * contents = @[@"123456789001",@"100000000009085",@"t33257",@"yyyy",@"1",@"6217000010066764658",@"张庭勇",@"5622567743366363452",@"18363852573",@"0221"];
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
    goodOrder.merchant_id = self.order.merchant_id;//@"100000000009085"; // 商户ID
    goodOrder.card_no = self.order.card_no; //@"6325452566444346";
    goodOrder.owner = _owner; //@"张庭勇"; //self.order.owner;
    goodOrder.cert_type = @"01"; //self.order.cert_type;
    goodOrder.cert_no = _certNo; //@"34354768634234234"; //self.order.card_no;
    goodOrder.phone = _phone; //@"15793413163"; //self.order.phone;
    
    
    goodOrder.cvv2 = _cvv2; //@"417";
    goodOrder.validthru = _validthru; // @"0221";
    goodOrder.order_no = [ReapalUtil generateTradeNO];
    goodOrder.transtime = @"2015-06-12 16:52:57";
    goodOrder.currency = @"156";
    goodOrder.total_fee = self.order.total_fee; //@"1";
    goodOrder.title = self.order.title; //@"t33257"; // 商品名称
    goodOrder.body = self.order.body; //@"yyyy"; // 商品描述
    goodOrder.member_id = self.order.member_id; //@"12345678900";  // 用户ID
    goodOrder.terminal_info = self.order.terminal_info;
    goodOrder.terminal_type = self.order.terminal_type;
    goodOrder.member_ip = self.order.member_ip; // 用户IP
    goodOrder.seller_email = self.order.seller_email; // @"492215340@qq.com"; // 商户邮箱
    goodOrder.notify_url = self.order.notify_url;
    goodOrder.token_id = self.order.token_id;
    goodOrder.version = self.order.version;
    
    
    
    //    NSString * calibrateKey = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809";// 安全校验码
    
    NSString * calibrateKey = [self selectCalibrate:goodOrder.merchant_id];
    
    ReapalUtil * unionUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [unionUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [unionUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    
    // 信用卡签约请求
    [[ReapalSdk defaultSdk] creditWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
        
        if (resultDic == nil) {
            //             [self performSelectorOnMainThread:@selector(goPay) withObject:nil waitUntilDone:YES];
            return ;
        }
        
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [unionUtil rsaDecryptContent:encryptkey];
        
        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
        
        NSString * deDataStr = [unionUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);
        
        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
        
        NSLog(@"%@",myDict);
        NSLog(@"%@",myDict[@"result_msg"]);
        
        NSString * myMsgStr = myDict[@"result_code"];
        
        
        if ([myMsgStr isEqualToString:@"0000"]) {
            
            [self performSelectorOnMainThread:@selector(payAndSms) withObject:nil waitUntilDone:YES];
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

- (void)payAndSms
{
    self.order.phone = _phone;
    self.order.owner = _owner;
    self.order.card_no = _cardNO;
    self.order.cert_no = _certNo;
    self.order.cvv2 = _cvv2;
    self.order.validthru = _validthru;
    PayAndSmsViewController * payAndSmsVC = [[PayAndSmsViewController alloc] init];
    
    payAndSmsVC.order = self.order;
    
    [self.navigationController pushViewController:payAndSmsVC animated:YES];
    
}


#pragma mark UITextFielDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    

    
    NSLog(@"tag====>%ld",textField.tag);
    

        

        if (textField.tag == 2) {
            // 姓名
            hasOwer = [self judgeContentIsNull:textField.text.length withRangLenth:range.length];
            
            if (textField.text.length >= 20 && range.length == 0) {
                
                return NO;
                
            }
           
            
        }else if (textField.tag == 3){
            // 身份证号
            hasCertNo = [self judgeContentIsNull:textField.text.length withRangLenth:range.length];
            
            if (textField.text.length >= 18 && range.length == 0) {
                
                return NO;
                
            }
            
        }else if (textField.tag == 4){
            // 手机号码
            hasPhoneNum = [self judgeContentIsNull:textField.text.length withRangLenth:range.length];
            
            if (textField.text.length >= 11 && range.length == 0) {
                
                return NO;
                
            }
            
        }else if (textField.tag == 5){
            
            // 信用卡有效期
            hasValidthut = [self judgeContentIsNull:textField.text.length withRangLenth:range.length];
            
            if (textField.text.length >= 4 && range.length == 0) {
                
                return NO;
                
            }
            
            
        }else if (textField.tag == 6){
            
            // 信用卡背后三位
            hasCvv2 = [self judgeContentIsNull:textField.text.length withRangLenth:range.length];
            
            if (textField.text.length >= 3 && range.length == 0) {
                
                return NO;
                
            }
            
        }

        
    if ([self.order.bank_card_type isEqualToString:@"1"]) {
        
        if (hasCertNo && hasOwer && hasPhoneNum  && hasValidthut && hasCvv2 && _isSureButton) {
            
            _nextBtn.enabled = YES;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_03.png"]];
            
        }else{
            
            _nextBtn.enabled = NO;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
        }

    }else{
        
        if (hasCertNo  && hasOwer  && hasPhoneNum && _isSureButton) {
            
            _nextBtn.enabled = YES;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_03.png"]];
            
        }else{
            
            _nextBtn.enabled = NO;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
        }
        
    }
        
    
    return YES;
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    if (textField.tag == 2) {
        // 姓名
        hasOwer = NO;
        
        
    }else if (textField.tag == 3){
        // 身份证号
        hasCertNo = NO;
        
    }else if (textField.tag == 4){
        // 手机号码
        hasPhoneNum =  NO;
        
        
    }else if (textField.tag == 5){
        
        // 信用卡有效期
        hasValidthut = NO;

        
        
    }else if (textField.tag == 6){
        
        // 信用卡背后三位
        hasCvv2 = NO;
            
        
    }
    
    
    if ([self.order.bank_card_type isEqualToString:@"1"]) {
        
        if (hasCertNo && hasOwer && hasPhoneNum  && hasValidthut && hasCvv2 && _isSureButton) {
            
            _nextBtn.enabled = YES;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_03.png"]];
            
        }else{
            
            _nextBtn.enabled = NO;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
        }
        
    }else{
        
        if (hasCertNo  && hasOwer  && hasPhoneNum && _isSureButton) {
            
            _nextBtn.enabled = YES;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_03.png"]];
            
        }else{
            
            _nextBtn.enabled = NO;
            _nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
        }
        
    }
    
    return YES;
    
}


- (BOOL)judgeContentIsNull:(NSInteger)textLength withRangLenth:(NSInteger)rangeLength{
    
    if (textLength - rangeLength == 0 && rangeLength != 0){
        
        return NO;
        
    }else{
        
        return YES;
        
    }

}


@end
