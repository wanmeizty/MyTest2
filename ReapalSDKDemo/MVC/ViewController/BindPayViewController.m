//
//  BindPayViewController.m
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/29.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "BindPayViewController.h"

#import "ReapalUtil.h"

#import "PartColorLabel.h"

#import "ReapalSdk.h"

#import "CardView.h"

#import "MoneyView.h"

#import "CardInfoCell.h"

#import "CardViewController.h"

@interface BindPayViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
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
    
    UITableView * _tableView;
    
    
    UIView * _backgroundView;
    
    UIButton * _payBtn;
    

}
@end

@implementation BindPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBindPayView];
    
    [self createTableView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _tableView.hidden = YES;
    
    _backgroundView.hidden = YES;
    
}

- (void)createTableView{
    
    // 选择卡的时候加一层半透明图层
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, zwidth, zheight - 20)];
    _backgroundView.backgroundColor = [UIColor lightGrayColor];
    _backgroundView.alpha = 0.8;
    _backgroundView.hidden = YES;
    [self.view addSubview:_backgroundView];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    _tableView.scrollEnabled = NO;
    _tableView.layer.cornerRadius = 5;
    _tableView.layer.masksToBounds = YES;
    
    [self.view addSubview:_tableView];
    
}

#pragma mark -- tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cardList.count + 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0 || indexPath.row == self.cardList.count + 1) {
        
        
        
    }else{
        
        NSDictionary * dict = self.cardList[indexPath.row - 1];
        
        _backgroundView.hidden = YES;
        _tableView.hidden = YES;
        
        [self setcardViewWithCardInfo:dict];
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"head"];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 100, 40)];
        
        label.text = @"选择支付方式";
        label.textColor = [UIColor lightGrayColor];
//        label.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:label];
        label.font = [UIFont systemFontOfSize:14];
        UIButton * headBtn = [[UIButton alloc] initWithFrame:CGRectMake(zwidth - 100, 0, 40, 40)];
        
//        [headBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [headBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [headBtn setTitle:@"✖️" forState:UIControlStateNormal];
        [headBtn addTarget:self action:@selector(closeTabelView) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:headBtn];
        
        
        return cell;
        
        
        
    }else if (indexPath.row == self.cardList.count + 1){
        
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"foot"];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 140, 40)];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"选择其它支付方式";
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
        
        UIButton * footBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
        
//        [footBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        
        [footBtn setTitle:@"➕" forState:UIControlStateNormal];
        [footBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [footBtn addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:footBtn];
        
        
        return cell;
        
        
    }else{
        
        
        CardInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            
            cell = [[CardInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        NSDictionary * cardInfo = self.cardList[indexPath.row - 1];
        
        NSString * imageName = [NSString stringWithFormat:@"bank_%@.png",cardInfo[@"bank_code"]];
        // bank_BOCM.png
        
        cell.cardIcon.image = [UIImage imageNamed:imageName];
        
        cell.typeLabel.text = [NSString stringWithFormat:@"%@(尾号%@)",cardInfo[@"bank_name"],cardInfo[@"card_last"]];
        
        
        
        
        if ([cardInfo[@"bank_card_type"] isEqualToString:@"0"]) {
            
            cell.numberLabel.text = [NSString stringWithFormat:@"储蓄卡"];
            
        }else{
            
            cell.numberLabel.text = [NSString stringWithFormat:@"信用卡"];
            
        }
        
        return cell;
        
    }
    
    
    
}


#pragma mark UItextFieldDelegate
// 输入验证码为6位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    

    if (textField.text.length - range.length == 0 && range.length != 0){
        
        _payBtn.enabled = NO;
        _payBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
        
    }else{
        
        _payBtn.enabled = YES;
        _payBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_03.png"]];

    }
 
    if (textField.text.length >= 6 && range.length == 0) {
        
        return NO;
        
    }
    
    return YES;
    
}

// 选择其他支付方式
- (void)addCard{
    
    CardViewController * cardVC = [[CardViewController alloc] init];
    
    cardVC.order = self.order;
    
    cardVC.isNotFirst = YES;
    
    [self.navigationController pushViewController:cardVC animated:YES];
    
}

// 关闭tableView
- (void)closeTabelView{
    
    _backgroundView.hidden = YES;
    _tableView.hidden = YES;
    
}


- (void)goToBack{
    
    if ([self isKindOfClass:[BindPayViewController class]]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}


- (void)setcardViewWithCardInfo:(NSDictionary *)cardInfo{
    

    
    UIView * backView = [[UIView alloc] initWithFrame:GTRectMake(0, 50, zwidth, 120)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.mainView addSubview:backView];
    
    CardView * cardView = [[CardView alloc] initWithFrame:GTRectMake(0, 0, zwidth, 40)];
    
    NSString * imageName = [NSString stringWithFormat:@"bank_%@.png",cardInfo[@"bank_code"]];
    // bank_BOCM.png
    
    cardView.cardIcon.image = [UIImage imageNamed:imageName];
    
    cardView.textLabel.text = cardInfo[@"bank_name"];
    
    cardView.changeView.userInteractionEnabled = YES;
    
    
    
    
    
    UITapGestureRecognizer * changTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCard)];
    
    [cardView.changeView addGestureRecognizer:changTap];
    
    //    NSString * lastStr = [self.order.card_no substringFromIndex:self.order.card_no.length - 4];
    
    if ([cardInfo[@"bank_card_type"] isEqualToString:@"0"]) {
        
        cardView.numberLabel.text = [NSString stringWithFormat:@"尾号(%@)储蓄卡",cardInfo[@"card_last"]];
        
    }else{
        
        cardView.numberLabel.text = [NSString stringWithFormat:@"尾号(%@)信用卡",cardInfo[@"card_last"]];
        
    }
    
    
    [backView addSubview:cardView];
    
    
    UILabel * line1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, zwidth - 10, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line1];
    
    
    UILabel * phoneLabel = [[UILabel alloc] initWithFrame:GTRectMake(10, 40, zwidth - 20, 40)];
    
    
    phoneLabel.text = cardInfo[@"phone"];//[NSString stringWithFormat:@"手机号      %@",mutStr];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:phoneLabel];
    
    
    UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 79, zwidth - 10, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:line2];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:GTRectMake(10, 80, 60,30)];
    
    label.text = @"验证码";
    
    [backView addSubview:label];
    
    _calibrate = [[UITextField alloc] initWithFrame:GTRectMake(70, 80, zwidth - 190, 30)];
    
    //    _calibrate.borderStyle = UITextBorderStyleRoundedRect;
    _calibrate.placeholder = @"输入验证码";
    _calibrate.delegate = self;
    [backView addSubview:_calibrate];
    
    
    _smsBtn = [[UILabel alloc] initWithFrame:GTRectMake(zwidth - 110, 80, 100, 30)];
    _smsBtn.text = @"获取验证码";
    _smsBtn.font = [UIFont systemFontOfSize:16];
    _smsBtn.textAlignment = NSTextAlignmentCenter;
    _smsBtn.textColor = [UIColor blueColor];
    //    _smsBtn.backgroundColor = [UIColor redColor];
    [backView addSubview:_smsBtn];
    
    _smsBtn.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendSMS)];
    
    [_smsBtn addGestureRecognizer:singleTap];
    
    
    UIButton * payBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, zwidth - 40, 40)];
    
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
//    payBtn.backgroundColor = [UIColor grayColor];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _payBtn = payBtn;
    payBtn.enabled = NO;
    payBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buttons_13.png"]];
    
    [payBtn addTarget:self action:@selector(payEnsure) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mainView addSubview:payBtn];
    
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

- (void)payEnsure{
    
    
    GoodsOrder * goodOrder = [[GoodsOrder alloc] init];
    
    goodOrder.merchant_id = self.order.merchant_id; // 商户ID
    goodOrder.order_no = self.order.order_no; // @"MP1Q7QO420H0RPND6YD2"; //[UnionPayUtil generateTradeNO];
    goodOrder.check_code = _calibrate.text; //@"434526";
    goodOrder.card_no = self.order.card_no;  //@"6217000010066764658";
    goodOrder.owner = self.order.owner; //@"zty"; //self.order.owner;
    goodOrder.cert_no = self.order.cert_no; //@"426754534534534545"; //self.order.card_no;
    goodOrder.phone = self.order.phone; // @"18314533172"; //self.order.phone;
    
    goodOrder.version = @"3.1.2";
    
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

- (void)createBindPayView{
    
    
    [self createViewWithTitle:self.order.title orderNO:self.order.order_no totalFee:self.order.total_fee];
    
    
    [self setcardViewWithCardInfo:self.cardList[0]];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}

- (void)sendSMS{
    
    
    
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
//        NSData *EncryptData = [GTMBase64 decodeString:dataStr];//解密前进行GTMBase64编码
//        
//        NSString * deDataStr = [realpalUtil decryptAESData:EncryptData app_key:decryptKeyStr];
        
        NSString * deDataStr = [realpalUtil decryptAESWithString:dataStr app_key:decryptKeyStr];
        
        NSLog(@"解密数据==>%@",deDataStr);
        
        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
        
        
        NSLog(@"%@",myDict);
        
    }];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime3) userInfo:nil repeats:YES];
    
    
}


// 短信验证倒计时
- (void)updateTime3{
    
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

// 打开换卡界面
- (void)changeCard{
    
    _backgroundView.hidden = NO;
    _tableView.hidden = NO;
    _tableView.frame = CGRectMake(30,180,zwidth - 60,40 * self.cardList.count + 80);
    
    
    
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
