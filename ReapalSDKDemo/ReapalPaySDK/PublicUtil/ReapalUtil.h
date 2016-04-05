//
//  UnionUtil.h
//  ReapalUnionPaySdk
//
//  Created by wanmeizty on 16/2/19.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GoodsOrder.h"

typedef void(^CompletionBlock)(NSDictionary *resultDic);


@interface ReapalUtil : NSObject

/**
 单例对象
 */

+ (ReapalUtil *)defaultUtil;

/**********************导入秘钥*************************/

/**
 *  只导入私钥
 *
 *  @param privateKeyFileName 私钥钥文件名
 *
 */
- (void)setPrivateKeyFileName:(NSString *)privateKeyFileName;

/**
 *  只导入公钥
 *
 *  @param publicKeyFileName 私钥钥文件名
 *
 */
- (void)setPublicFileName:(NSString *)publicKeyFileName;

/**
 *  设置私钥，公钥
 *
 *  @param privateKeyFileName 私钥钥文件名
 *  @param publicKeyFileName 私钥钥文件名
 *
 */
- (void)setPrivateKeyFileName:(NSString *)privateKeyFileName
            andPublicFileName:(NSString *)publicKeyFileName;

/********************加密解密方法**********************/

/**
 *  加密订单参数
 *
 *  @param goodsOrder 加密的订单对象
 *
 */

- (NSDictionary *)encodeOrder:(GoodsOrder *)goodsOrder andCalibratekey:(NSString *)calibrateKey;

/**
 *  还原订单参数
 *
 *  @param params 加密的字典
 *
 */
- (GoodsOrder *)decryptWithParams:(NSDictionary *) params;

/**
 *  私钥加密订单参数
 *
 *  @param goodsOrder 加密的订单对象
 *
 */
- (NSDictionary *)privateEncodeOrder:(GoodsOrder *)goodsOrder andCalibratekey:(NSString *)calibrateKey;

/**
 *  RSA 公钥加密
 *
 *  @param encontent 加密的内容
 *
 */


- (NSString *) rsaEncryptContent:(NSString*)encontent;

/**
 *  RSA 私钥解密
 *
 *  @param decontent 解密的内容
 *
 */
- (NSString *) rsaDecryptContent:(NSString*)decontent;


/**
 *  AES加密
 *
 *  @param string 加密的内容
 *  @param key 加密的key
 *
 */

- (NSString*)encryptAESContent:(NSString*)encontent app_key:(NSString*)key;

/**
 *  AES解密
 *
 *  @param data 解密的数据
 *  @param key 解密的key
 *
 */
- (NSString*)decryptAESData:(NSData*)data app_key:(NSString*)key;


/**
 *  AES解密
 *
 *  @param string 解密的字符串
 *  @param key 解密的key
 *
 */
- (NSString*)decryptAESWithString:(NSString*)string app_key:(NSString*)key;



/********************工具方法**********************/

/**
 获取16位随机字符序列
 */
+ (NSString *)get16bitRandomString;

/**
 生成签名
 */
+ (NSString *)signString:(NSString *)signStr;

/**
 字典转化为字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 随机产生订单号
 */
+ (NSString *)generateTradeNO;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


@end
