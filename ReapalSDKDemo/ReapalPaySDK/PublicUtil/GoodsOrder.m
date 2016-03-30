//
//  GoodsOrder.m
//  ReapalDemo
//
//  Created by wanmeizty on 16/2/2.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "GoodsOrder.h"

@implementation GoodsOrder

- (NSString *)sortParam{
    
    
    NSMutableArray * mutArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary * mutDic = [[NSMutableDictionary alloc] init];
    
    if (self.body && ![self.body isEqualToString:@""]) {
        [mutArray addObject:@"body"];
        [mutDic setValue:self.body forKey:@"body"];
    }
    
    if (self.owner && ![self.owner isEqualToString:@""]) {
        
        [mutArray addObject:@"owner"];
        [mutDic setValue:self.owner forKey:@"owner"];
    }
    
    if (self.cert_type && ![self.cert_type isEqualToString:@""] ) {
        [mutArray addObject:@"cert_type"];
        [mutDic setValue:self.cert_type forKey:@"cert_type"];
    }
    
    if (self.phone && ![self.phone isEqualToString:@""]) {
        [mutArray addObject:@"phone"];
        [mutDic setValue:self.phone forKey:@"phone"];

    }
    
    if (self.default_bank && ![self.default_bank isEqualToString:@""]) {
        [mutArray addObject:@"default_bank"];
        [mutDic setValue:self.default_bank forKey:@"default_bank"];
    }
    
    if (self.bank_card_type &&![self.bank_card_type isEqualToString:@""]) {
        [mutArray addObject:@"bank_card_type"];
        [mutDic setValue:self.bank_card_type forKey:@"bank_card_type"];
    }
    
    if (self.member_id && ![self.member_id isEqualToString:@""]) {
        [mutArray addObject:@"member_id"];
        [mutDic setValue:self.member_id forKey:@"member_id"];
    }
    if (self.member_ip && ![self.member_ip isEqualToString:@""]) {
        [mutArray addObject:@"member_ip"];
        [mutDic setValue:self.member_ip forKey:@"member_ip"];
    }
    if (self.merchant_id && ![self.member_id isEqualToString:@""]) {
        [mutArray addObject:@"merchant_id"];
        [mutDic setValue:self.merchant_id forKey:@"merchant_id"];
        
    }
    if (self.notify_url && ![self.notify_url isEqualToString:@""]) {
        [mutArray addObject:@"notify_url"];
        [mutDic setValue:self.notify_url forKey:@"notify_url"];
    }
    if (self.order_no && ![self.order_no isEqualToString:@""]) {
        [mutArray addObject:@"order_no"];
        [mutDic setValue:self.order_no forKey:@"order_no"];
        
    }
    
    if (self.bind_id && ![self.bind_id isEqualToString:@""]) {
        
        [mutArray addObject:@"bind_id"];
        [mutDic setValue:self.bind_id forKey:@"bind_id"];
    }
    
    if (self.check_code && ![self.check_code isEqualToString:@""]) {
        [mutArray addObject:@"check_code"];
        [mutDic setValue:self.check_code forKey:@"check_code"];
    }
    
    if (self.pay_method && ![self.pay_method isEqualToString:@""]) {
        [mutArray addObject:@"pay_method"];
        [mutDic setValue:self.pay_method forKey:@"pay_method"];
    }
    if (self.payment_type && ![self.payment_type isEqualToString:@""]) {
        [mutArray addObject:@"payment_type"];
        [mutDic setValue:self.payment_type forKey:@"payment_type"];
    }
    
    if (self.return_url && ![self.return_url isEqualToString:@""]) {
        [mutArray addObject:@"return_url"];
        [mutDic setValue:self.return_url forKey:@"return_url"];
    }
    if (self.seller_email && ![self.seller_email isEqualToString:@""]) {
        [mutArray addObject:@"seller_email"];
        [mutDic setValue:self.seller_email forKey:@"seller_email"];
    }
    
    if (self.cvv2 && ![self.cvv2 isEqualToString:@""]) {
        [mutArray addObject:@"cvv2"];
        [mutDic setValue:self.cvv2 forKey:@"cvv2"];
    }
    
    if (self.validthru && ![self.validthru isEqualToString:@""]) {
        [mutArray addObject:@"validthru"];
        [mutDic setValue:self.validthru forKey:@"validthru"];
    }
    
    if (self.title && ![self.title isEqualToString:@""]) {
        [mutArray addObject:@"title"];
        [mutDic setValue:self.title forKey:@"title"];
    }
    if (self.total_fee && ![self.total_fee isEqualToString:@""]) {
        [mutArray addObject:@"total_fee"];
        [mutDic setValue:self.total_fee forKey:@"total_fee"];
    }
    
    if (self.transtime && ![self.transtime isEqualToString:@""]) {
        
        [mutArray addObject:@"transtime"];
        [mutDic setValue:self.transtime forKey:@"transtime"];
        
    }
    
    if (self.currency && ![self.currency isEqualToString:@""]) {
        
        [mutArray addObject:@"currency"];
        [mutDic setValue:self.currency forKey:@"currency"];
    }
    
    if (self.terminal_info && ![self.terminal_info isEqualToString:@""]) {
        [mutArray addObject:@"terminal_info"];
        [mutDic setValue:self.terminal_info forKey:@"terminal_info"];
    }
    
    if (self.terminal_type && ![self.terminal_type isEqualToString:@""]) {
        [mutArray addObject:@"terminal_type"];
        [mutDic setValue:self.terminal_type forKey:@"terminal_type"];
    }
    
    if (self.token_id && ![self.token_id isEqualToString:@""]) {
        [mutArray addObject:@"token_id"];
        [mutDic setValue:self.token_id forKey:@"token_id"];
    }
    
    if (self.version && ![self.version isEqualToString:@""]) {
        [mutArray addObject:@"version"];
        [mutDic setValue:self.version forKey:@"version"];
    }
    
    if (self.amount && ![self.amount isEqualToString:@""]) {
        [mutArray addObject:@"amount"];
        [mutDic setValue:self.amount forKey:@"amount"];

    }
    
    if (self.orig_order_no && ![self.orig_order_no isEqualToString:@""]) {
        [mutArray addObject:@"orig_order_no"];
        [mutDic setValue:self.orig_order_no forKey:@"orig_order_no"];
    }
    
    
    if (self.note && ![self.note isEqualToString:@""]) {
        [mutArray addObject:@"note"];
        [mutDic setValue:self.note forKey:@"note"];
    }
    
    if (self.status && ![self.status isEqualToString:@""]) {
        [mutArray addObject:@"status"];
        [mutDic setValue:self.status forKey:@"status"];
    }
    
    
    if (self.card_no && ![self.card_no isEqualToString:@""]) {
        [mutArray addObject:@"card_no"];
        [mutDic setValue:self.card_no forKey:@"card_no"];
    }
    
    if (self.cert_no && ![self.cert_no isEqualToString:@""]) {
        [mutArray addObject:@"cert_no"];
        [mutDic setValue:self.cert_no forKey:@"cert_no"];
    }
    
    self.dict = mutDic;
    
     NSArray * array = [mutArray sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString * mutStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i < array.count; i ++) {
        
        if (i == 0) {
            [mutStr appendFormat:@"%@=%@",array[i],[mutDic objectForKey:array[i]]];
        }else{
            
            [mutStr appendFormat:@"&%@=%@",array[i],[mutDic objectForKey:array[i]]];
        }
        
    }
    
    return mutStr;
}

@end
