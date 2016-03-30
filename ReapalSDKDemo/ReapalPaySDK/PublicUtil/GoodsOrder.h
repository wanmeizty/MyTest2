//
//  GoodsOrder.h
//  ReapalDemo
//
//  Created by wanmeizty on 16/2/2.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsOrder : NSObject

@property (nonatomic,copy) NSString * body; // 商品描述
@property (nonatomic,copy) NSString * owner; // 持卡人信吗
@property (nonatomic,copy) NSString * cert_type; // 证件类型
@property (nonatomic,copy) NSString * phone; // 手机号
@property (nonatomic,copy) NSString * default_bank; //
@property (nonatomic,copy) NSString * bank_card_type; // 卡类型
@property (nonatomic,copy) NSString * member_id; // 用户ID
@property (nonatomic,copy) NSString * member_ip; // 用户IP
@property (nonatomic,copy) NSString * merchant_id; // 商户ID
@property (nonatomic,copy) NSString * notify_url; // 商户后台系统回调地址
@property (nonatomic,copy) NSString * order_no; // 商户订单号
@property (nonatomic,copy) NSString * bind_id; // 绑卡ID
@property (nonatomic,copy) NSString * check_code; // 短信校验码
@property (nonatomic,copy) NSString * pay_method; // 支付方式
@property (nonatomic,copy) NSString * payment_type; //支付类型
@property (nonatomic,copy) NSString * return_url; // 商户前台系统的回调地址
@property (nonatomic,copy) NSString * seller_email; // 商户邮箱
@property (nonatomic,copy) NSString * sign; // 签名
@property (nonatomic,copy) NSString * sign_type; // 签名类型
@property (nonatomic,copy) NSString * cvv2; // 信用卡背后的后三位数字
@property (nonatomic,copy) NSString * validthru; // 卡有效期
@property (nonatomic,copy) NSString * title; // 商品名称
@property (nonatomic,copy) NSString * total_fee; // 交易金额
@property (nonatomic,copy) NSString * transtime; // 交易时间
@property (nonatomic,copy) NSString * currency; // 交易币种
@property (nonatomic,copy) NSString * terminal_info; // 终端信息
@property (nonatomic,copy) NSString * terminal_type; // 终端类型
@property (nonatomic,copy) NSString * token_id; // 指纹ID
@property (nonatomic,copy) NSString * version; // 版本号
@property (nonatomic,copy) NSString * amount; // 退款金额
@property (nonatomic,copy) NSString * orig_order_no; // 原商户订单号
@property (nonatomic,copy) NSString * note; // 退款说明
@property (nonatomic,copy) NSString * status; // 状态

@property (nonatomic,copy) NSString * card_no; // 银行卡号
@property (nonatomic,copy) NSString * cert_no; // 证件号

@property (nonatomic,copy) NSString * calibrateKey;

@property (nonatomic,readonly) NSDictionary * extraParams;

@property (nonatomic,strong) NSDictionary * dict;


/**
 给各个参数按字母升序排序
 */
- (NSString *)sortParam;

@end
