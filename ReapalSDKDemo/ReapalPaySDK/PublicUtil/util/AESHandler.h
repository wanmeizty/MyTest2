//
//  SecurityUtil.h
//  AES+Base64
//
//  Created by wanmeizty on 16/1/27.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESHandler : NSObject


#pragma mark - AES加密

/**
 *  AES加密
 *
 *  @param string 加密的内容
 *  @param key 加密的key
 *
 */

+ (NSString*)encryptAESData:(NSString*)string app_key:(NSString*)key;

/**
 *  AES解密
 *
 *  @param data 解密的数据
 *  @param key 解密的key
 *
 */
+ (NSString*)decryptAESData:(NSData*)data app_key:(NSString*)key;


#pragma mark - base64
// 字符串进行base64编码解密
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
// 二进制数据进行base64编码解密
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;


@end
