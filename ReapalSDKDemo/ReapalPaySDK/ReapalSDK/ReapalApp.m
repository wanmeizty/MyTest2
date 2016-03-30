//
//  ReapalApp.m
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/28.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "ReapalApp.h"

#import "ReapalSdk.h"

#import "ReapalUtil.h"

#import "BindPayViewController.h"

#import "CardViewController.h"

@interface ReapalApp ()
{
    GoodsOrder * _order;
    NSArray * _cardList;
    NSDictionary * _bankInfo;
//    UIViewController * _vc;
}

@property (nonatomic,strong) UIViewController * vc;

@end

@implementation ReapalApp

/**
 *  支付接口
 *
 *  @param GoodsOrder             订单信息
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param mode           支付环境
 *  @param viewController 启动支付控件的viewController
 *  @return 返回成功失败
 */


- (void)startPay:(GoodsOrder *)order fromScheme:(NSString *)schemeStr mode:(ReapalStatus*)reapalSatus viewController:(UIViewController*)viewController{
    
    
    _order = order;
    
    _vc = viewController;
    
    NSLog(@"%@",viewController);
    
    GoodsOrder * searchOrder = [[GoodsOrder alloc] init];
    
    
    
    searchOrder.bank_card_type = order.bank_card_type; // @"0" // 卡类型
    
    searchOrder.member_id = order.member_id ; //@"12345678900";  // 用户ID
    
    searchOrder.merchant_id = order.merchant_id; // @"100000000009085"; // 商户ID
    
//    NSString * calibrateKey = @"48958gg3a25eeabg5fdgb4d95g93d4a4gfeb92c4g02ef276518da56cb9c7a809";// 安全校验码
    
    ReapalUtil * reapalUtil = [ReapalUtil defaultUtil];
    
    // 导入公钥私钥文件
    [reapalUtil setPrivateKeyFileName:@"1_pri.key" andPublicFileName:@"1_pub.key"];
    
    // 加密数据
    NSDictionary * params = [reapalUtil encodeOrder:searchOrder andCalibratekey:order.calibrateKey];
    
    //    [self.view endEditing:YES];
    
    //        NSLog(@"%@",params);
    
    // 绑卡请求
    [[ReapalSdk defaultSdk] searchBindCardlistWithDictionary:params isTest:ReapalTestStatus callback:^(NSDictionary *resultDic) {
        
        
        NSLog(@"dddd");
        
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
                NSLog(@"解密数据==>%@",deDataStr);
        
        
        //        NSString * sss  = [NSString stringWithFormat:@"解密key==>%@\n\n解密数据==>%@",decryptKeyStr,deDataStr];
        //
        //        [self performSelectorOnMainThread:@selector(getData:) withObject:sss waitUntilDone:YES];
        
        
        NSDictionary * myDict = [ReapalUtil dictionaryWithJsonString:deDataStr];
        
        
        NSLog(@"%@",myDict);
        
        NSArray * cardList = [myDict objectForKey:@"bind_card_list"];
        
        
        _cardList = cardList;
        
//        for (NSDictionary * subDic in cardList) {
//            
//            if ([subDic[@"bind_id"] isEqualToString:order.bind_id]) {
//                
//                // 绑过卡
//                //                                _cardInfo = subDic;
//                NSLog(@"%@",subDic);
//                NSLog(@"%@",subDic[@"bank_name"]);
//                
//                
//                
//                [self performSelectorOnMainThread:@selector(goPayVC) withObject:nil waitUntilDone:YES];
//                
//                
//                return ;
//                
//            }
//            
//        }
        
        if (cardList.count > 0) {
            // 绑过卡
        
            _bankInfo = cardList[0];
            [self performSelectorOnMainThread:@selector(goPayVC) withObject:nil waitUntilDone:YES];
            
            
        }else{
            
            // 没有绑过卡
            
            [self performSelectorOnMainThread:@selector(gobindCardVC) withObject:nil waitUntilDone:YES];
            
        }
        
        
        
    }];
    
}

- (void)goPayVC{
    
    BindPayViewController * payVC = [[BindPayViewController alloc] init];
    
    payVC.order = _order;
//    payVC.cardInfo = _bankInfo;
    payVC.cardList = _cardList;
    
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:payVC];
    
//    [navc pushViewController:payVC animated:YES];
    [_vc presentViewController:navc animated:YES completion:nil];
    
    //    SmsViewController * smsVC = [[SmsViewController alloc] init];
    //
    //    smsVC.order = self.order;
    //
    //    [self.navigationController pushViewController:smsVC animated:YES];
    
}

- (void)gobindCardVC{
    
    CardViewController * cardVC = [[CardViewController alloc] init];
    
    cardVC.order = _order;
    
    
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:cardVC];
    
    
    
    [_vc presentViewController:navc animated:YES completion:nil];
}

@end
