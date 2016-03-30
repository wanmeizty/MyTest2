//
//  Encrypt.h
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/28.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encrypt : NSObject


/******AES加解密*******/
- (NSData *)AES128EncryptWithKey:(NSString *)key andData:(NSData *)data;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key andData:(NSData *)data;   //解密

/*******MD5*********/
- (NSString *)md5WithString:(NSString *)str;

@end
