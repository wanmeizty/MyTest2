//
//  RSAHandler.h
//  ReapalUnionPaySdk
//
//  Created by wanmeizty on 16/2/16.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 公钥，私钥类型
 */
typedef enum {
    KeyTypePublic = 0, // 公钥类型
    KeyTypePrivate  // 私钥类型
}KeyType;


@interface RSAHandler : NSObject

/**
 *  通过文件路径方式导入公钥私钥
 *
 *  @param type 秘钥类型
 *  @param path 秘钥路径
 *
 */

- (BOOL)importKeyWithType:(KeyType)type andPath:(NSString*)path;


/**
 *  通过传入字符串方式导入公钥私钥
 *
 *  @param type 秘钥类型
 *  @param path 秘钥字符串
 *
 */

- (BOOL)importKeyWithType:(KeyType)type andkeyString:(NSString *)keyString;

 /**
 *  RSA 公钥加密
 *
 *  @param encontent 加密的内容
 *
 */

- (NSString *) encryptWithPublicKey:(NSString*)encontent;

/**
 *  RSA 私钥解密
 *
 *  @param decontent 解密的内容
 *
 */
- (NSString *) decryptWithPrivatecKey:(NSString*)decontent;

/**
 *  RSA 私钥加密
 *
 *  @param encontent 加密的内容
 *
 */

- (NSString *) encryptWithPrivatecKey:(NSString*)encontent;

/**
 *  RSA 公钥解密
 *
 *  @param decontent 解密的内容
 *
 */
- (NSString *) decryptWithPublicKey:(NSString*)decontent;



// 字符串获取公钥私钥
- (void)getPriKey:(NSString * )privateKeyString AndPubKey:(NSString *)publicKeyString;

// 文件路径获取公钥私钥
- (void)getPriKeyPath:(NSString *)privateKeyName AndPubKeyPath:(NSString *)publicKeyName;

//验证签名 Sha1 + RSA
- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString;
//验证签名 md5 + RSA
- (BOOL)verifyMD5String:(NSString *)string withSign:(NSString *)signString;

- (NSString *)signString:(NSString *)string;

- (NSString *)signMD5String:(NSString *)string;

@end
