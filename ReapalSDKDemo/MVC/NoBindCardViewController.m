//
//  NoBindCardViewController.m
//  ReapalSDKDemo
//
//  Created by 一米阳光 on 16/3/30.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "NoBindCardViewController.h"

#import "GoodsOrder.h"

#import "ReapalUtil.h"

#import "ReapalSdk.h"

#import "DebitViewController.h"

#import "GTMBase64.h"

#import "VerifyExpression.h"

@interface NoBindCardViewController ()<UITextFieldDelegate>
{
    UITextField * _textFiled;
    
    NSString * _bankCode;
    
    NSString * _bankName;
    
    NSString    *previousTextFieldContent;
    
    UITextRange *previousSelection;
    
    UIButton * _cardBtn;
    
}

@end

@implementation NoBindCardViewController
{
    NSArray * _titles;
    
    NSArray * _contents;
    
    NSString * _bankCardType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"❌" style:UIBarButtonItemStylePlain target:self action:@selector(closeSDKVC2)];
    [self initData];
    [self initUI];
}

- (void)goToBack{
    
    if ([self isKindOfClass:[NoBindCardViewController class]] && self.isNotFirst == NO) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//- (void)closeSDKVC2{
//    
//    if (self.isFirstIn && [self isKindOfClass:[NoBindCardViewController class]]) {
//        
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//    }else{
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//    
//    
//}

- (void)initData
{
    
    _titles = @[@"商户ID",@"卡号"];
    
//        _contents = @[,self.bindCardTextField.text];
//    _contents = @[self.order.merchant_id,@"6228480263096220417"];
    
    NSLog(@"%@",_contents);
}
//

- (void)initUI
{
    [self createViewWithTitle:self.order.title orderNO:self.order.order_no totalFee:self.order.total_fee];
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, zwidth, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.mainView addSubview:backView];
    
    UILabel * cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
    cardLabel.text = @"银行卡号";
    cardLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:cardLabel];
    
    UITextField * textFiled = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, zwidth - 90, 40)];
    textFiled.delegate = self;
    [textFiled addTarget:self action :@selector(reformatAsCardNumber:) forControlEvents:UIControlEventEditingChanged];
    textFiled.placeholder = @"请输入银行卡号";
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    _textFiled = textFiled;
    textFiled.clearButtonMode = UITextFieldViewModeAlways;
    [backView addSubview:textFiled];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 120, zwidth - 40, 40)];
    
    [btn setTitle:@"下一步" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    _cardBtn = btn;
    _cardBtn.enabled = NO;
    _cardBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:btn];
    
    
    
}

- (void)buttonClick:(id)sender
{
    

    NSString * cardNoStr = [_textFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"输出卡号%@",_textFiled.text);
    if (![VerifyExpression checkCardNo:cardNoStr]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的银行卡号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
        return ;
        
    }
    // 
    
    [self bankCardTest];
}

// 卡BIN查询接口
- (void)bankCardTest{
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
    goodOrder.merchant_id = self.order.merchant_id;
    
    

    NSString * cardNoStr = [_textFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    goodOrder.card_no = cardNoStr;
    
    NSString * calibrateKey = [self selectCalibrate:goodOrder.merchant_id];
    
    ReapalUtil * unionUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [unionUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [unionUtil encodeOrder:goodOrder andCalibratekey:calibrateKey];
    
    [[ReapalSdk defaultSdk] bankCardWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
        
        NSString * dataStr = resultDic[@"data"];
        
        NSString * encryptkey = resultDic[@"encryptkey"];
        
        NSString * decryptKeyStr = [unionUtil rsaDecryptContent:encryptkey];
        
        NSLog(@"解密key==>%@",decryptKeyStr);
        
        // 解密：
        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
        
        NSString * deDataStr = [unionUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);
        
        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
        
        //        NSArray * bankCardType= [myDict objectForKey:@"bind_card_type"];
        _bankCardType = myDict[@"bank_card_type"];
        
        _bankCode = myDict[@"bank_code"];
        
        _bankName = myDict[@"bank_name"];
        //        if ([banCardTypeStr isEqualToString:@"0"]) {
        //             [self performSelectorOnMainThread:@selector(debit) withObject:nil waitUntilDone:YES];
        //        }else if ([banCardTypeStr isEqualToString:@"1"]){
        //             [self performSelectorOnMainThread:@selector(credit) withObject:nil waitUntilDone:YES];
        //        }
        
        [self performSelectorOnMainThread:@selector(debit) withObject:nil waitUntilDone:YES];
        
        NSString * dekey = [NSString stringWithFormat:@"解密key==>%@",decryptKeyStr];
        
        NSString * deStr = [NSString stringWithFormat:@"解密数据==>%@",deDataStr];
        
        NSString * showStr = [NSString stringWithFormat:@"%@\n%@",dekey,deStr];
        NSLog(@"%@",showStr);
        
        
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

- (void)debit
{
    
    self.order.bank_card_type = _bankCardType;
    self.order.card_no = _textFiled.text;
    DebitViewController * debitVC = [[DebitViewController alloc] init];
    
    
    debitVC.order = self.order;
    debitVC.bankCode = _bankCode;
    debitVC.bankName = _bankName;
    
    [self.navigationController pushViewController:debitVC animated:YES];
}


//实现四位一隔
- (void)reformatAsCardNumber:(UITextField *)textField
{
    
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    
    NSString *cardNumberWithoutSpaces =
    [self removeNonDigits:textField.text
andPreserveCursorPosition:&targetCursorPosition];
    
    if ([cardNumberWithoutSpaces length] > 21) {
        
        [textField setText:previousTextFieldContent];
        textField.selectedTextRange = previousSelection;
        return;
    }
    
    NSString *cardNumberWithSpaces =
    [self insertSpacesEveryFourDigitsIntoString:cardNumberWithoutSpaces
                      andPreserveCursorPosition:&targetCursorPosition];
    
    textField.text = cardNumberWithSpaces;
    UITextPosition *targetPosition =
    [textField positionFromPosition:[textField beginningOfDocument]
                             offset:targetCursorPosition];
    
    [textField setSelectedTextRange:
     [textField textRangeFromPosition:targetPosition
     toPosition                      :targetPosition]
     ];
}

- (BOOL)textField                       :(UITextField *)textField
        shouldChangeCharactersInRange   :(NSRange)range
        replacementString               :(NSString *)string
{
    
    if (textField.text.length - range.length == 0 && range.length != 0){
        
        _cardBtn.enabled = NO;
        _cardBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
        
    }else{
        
        _cardBtn.enabled = YES;
        _cardBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_03.png"]];
        
    }
    
    previousTextFieldContent = textField.text;
    previousSelection = textField.selectedTextRange;
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    _cardBtn.enabled = NO;
    _cardBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
    
    return YES;
    
}

- (NSString *)  removeNonDigits             :(NSString *)string
                andPreserveCursorPosition   :(NSUInteger *)cursorPosition
{
    NSUInteger      originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    
    for (NSUInteger i = 0; i < [string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        } else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

- (NSString *)  insertSpacesEveryFourDigitsIntoString   :(NSString *)string
                andPreserveCursorPosition               :(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger      cursorPositionInSpacelessString = *cursorPosition;
    
    for (NSUInteger i = 0; i < [string length]; i++) {
        if ((i > 0) && ((i % 4) == 0)) {
            [stringWithAddedSpaces appendString:@" "];
            
            if (i < cursorPositionInSpacelessString) {
                (*cursorPosition)++;
            }
        }
        
        unichar     characterToAdd = [string characterAtIndex:i];
        NSString    *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if (![touch.view isKindOfClass: [UITextField class]] || ![touch.view isKindOfClass: [UITextView class]]) {
        
        [self.view endEditing:YES];
        
    }
    
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
