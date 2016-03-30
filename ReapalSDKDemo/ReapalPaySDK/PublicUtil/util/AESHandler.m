//
//  SecurityUtil.m
//  AES+Base64
//
//  Created by wanmeizty on 16/1/27.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "AESHandler.h"

#import "GTMBase64.h"

#import "Encrypt.h"

@implementation AESHandler


#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

#pragma mark - AES加密
/**
 *  AES加密
 *
 *  @param string 加密的内容
 *  @param key 加密的key
 *
 */
+(NSString*)encryptAESData:(NSString*)string app_key:(NSString*)key
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
//    NSData *encryptedData = [data AES128EncryptWithKey:key];
    Encrypt * encrypt = [[Encrypt alloc] init];
    
    NSData * encryptedData = [encrypt AES128EncryptWithKey:key andData:data];
    
//    NSLog(@"加密后的字符串 :%@",[encryptedData base64Encoding]);
    
    return [encryptedData base64Encoding];
}

#pragma mark - AES解密
/**
 *  AES解密
 *
 *  @param data 解密的数据
 *  @param key 解密的key
 *
 */
+(NSString*)decryptAESData:(NSData*)data  app_key:(NSString*)key
{
    //使用密码对data进行解密
//    NSData *decryData = [data AES128DecryptWithKey:key];
    Encrypt * encrypt = [[Encrypt alloc] init];
    NSData * decryData = [encrypt AES128DecryptWithKey:key andData:data];
    //将解了密码的nsdata转化为nsstring
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
//    NSLog(@"解密后的字符串 :%@",str);
    return str;
}

@end
