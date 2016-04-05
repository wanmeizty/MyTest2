//
//  VerifyExpression.h
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/30.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyExpression : NSObject

/**
 
 正则匹配手机号
 
 */
+ (BOOL)checkTelNumber:(NSString *)telNumber;


/**
 
 正则匹配用户身份证号
 
 */
+ (BOOL)checkIdentityCardNo:(NSString*)cardNo;


/**
 
 正则匹配银行卡号
 
 */
+ (BOOL) checkCardNo:(NSString *) cardNo;

@end
