//
//  UnionUtil.m
//  ReapalUnionPaySdk
//
//  Created by wanmeizty on 16/2/19.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "ReapalUtil.h"


#import "GTMBase64.h"

#import "AESHandler.h"

#import "RSAHandler.h"

#import "GoodsOrder.h"

#import "Encrypt.h"

#import <CommonCrypto/CommonCrypto.h>

//#import "NSString+MD5.h"

@interface ReapalUtil (){
    
    RSAHandler * _handler;
}


@end

@implementation ReapalUtil


+ (ReapalUtil *)defaultUtil{
    
    static ReapalUtil * unionUtil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        unionUtil = [[ReapalUtil alloc] init];
        
    });
    
    return unionUtil;
    
}

- (instancetype)init{
    
    if (self = [super init]) {
        

        
    }
    
    return self;
}

/**
 *  只导入私钥
 *
 *  @param privateKeyFileName 私钥钥文件名
 *
 */
- (void)setPrivateKeyFileName:(NSString *)privateKeyFileName{
    
    
    NSString *privateKeyFilePath = [[NSBundle mainBundle] pathForResource:privateKeyFileName ofType:nil];
    
    [_handler importKeyWithType:KeyTypePrivate andPath:privateKeyFilePath];
    
    if (privateKeyFilePath == nil) {
        
        NSLog(@"私钥为空");
        
    }
    
}

/**
 *  只导入公钥
 *
 *  @param publicKeyFileName 私钥钥文件名
 *
 */
- (void)setPublicFileName:(NSString *)publicKeyFileName{
    
    
    _handler = [[RSAHandler alloc] init];
    
    NSString *publicKeyFilePath = [[NSBundle mainBundle] pathForResource:publicKeyFileName ofType:nil];
    
    
    if (publicKeyFilePath == nil) {
        
        NSLog(@"公钥为空");
        
        return ;
        
    }
    
    [_handler importKeyWithType:KeyTypePublic andPath:publicKeyFilePath];

    
}

/**
 *  设置私钥，公钥
 *
 *  @param privateKeyFileName 私钥钥文件名
 *  @param publicKeyFileName 私钥钥文件名
 *
 */
- (void)setPrivateKeyFileName:(NSString *)privateKeyFileName
            andPublicFileName:(NSString *)publicKeyFileName{
    
    
    _handler = [[RSAHandler alloc] init];
    
    NSString *publicKeyFilePath = [[NSBundle mainBundle] pathForResource:publicKeyFileName ofType:nil];
    
    
    if (publicKeyFilePath == nil) {
        
        NSLog(@"公钥为空");
        
    }
    
    [_handler importKeyWithType:KeyTypePublic andPath:publicKeyFilePath];
    
    NSString *privateKeyFilePath = [[NSBundle mainBundle] pathForResource:privateKeyFileName ofType:nil];
    
    [_handler importKeyWithType:KeyTypePrivate andPath:privateKeyFilePath];
    
    if (privateKeyFilePath == nil) {
        
        NSLog(@"私钥为空");
        
    }
    
}

/**
 *  加密订单参数
 *
 *  @param goodsOrder 加密的订单对象
 *
 */
- (NSDictionary *)encodeOrder:(GoodsOrder *)goodsOrder andCalibratekey:(NSString *)calibrateKey{
    
    NSString * orderSignStr = [goodsOrder sortParam];
    
    // 获取随机串
    NSString * key = [self get16bitRandomString];
    
    // 加密随机串
    NSString * enString = [_handler encryptWithPublicKey:key];
    
    // 把参数和安全校验码拼接起来签名
    NSString * signedStr = [self signString:[NSString stringWithFormat:@"%@%@",orderSignStr,calibrateKey]];
   
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:goodsOrder.dict];
    
    

    
    [dict setObject:signedStr forKey:@"sign"];
    
    [dict setObject:@"MD5" forKey:@"sign_type"];
    
        NSLog(@"%@",dict);
    
    NSString * jsonstr = [self dictionaryToJson:dict];
    
    
    NSString * enJsonStr = [AESHandler encryptAESData:jsonstr app_key:key];
    
    NSString * merchantNo = goodsOrder.merchant_id;
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setValue:merchantNo forKey:@"merchant_id"];
    
    
    [params setValue:enJsonStr forKey:@"data"];
    
    
    [params setValue:enString forKey:@"encryptkey"];
    
    return params;
    
}


/**
 *  RSA 公钥加密
 *
 *  @param encontent 加密的内容
 *
 */
- (NSString *) rsaEncryptContent:(NSString*)encontent{
    
    return  [_handler encryptWithPublicKey:encontent];
    
}



/**
 *  RSA 私钥解密
 *
 *  @param decontent 解密的内容
 *
 */
- (NSString *) rsaDecryptContent:(NSString*)decontent{
    
    return  [_handler decryptWithPrivatecKey:decontent];
    
}

/**
 *  AES加密
 *
 *  @param string 加密的内容
 *  @param key 加密的key
 *
 */

- (NSString*)encryptAESContent:(NSString*)encontent app_key:(NSString*)key{
    
    return [AESHandler encryptAESData:encontent app_key:key];
}

/**
 *  AES解密
 *
 *  @param data 解密的数据
 *  @param key 解密的key
 *
 */
- (NSString*)decryptAESData:(NSData*)data app_key:(NSString*)key{
    
    return  [AESHandler decryptAESData:data app_key:key];
}


/**
 *  AES解密
 *
 *  @param string 解密的字符串
 *  @param key 解密的key
 *
 */
- (NSString*)decryptAESWithString:(NSString*)string app_key:(NSString*)key{
    
    NSLog(@"string==>%@",string);
    NSLog(@"key==>%@",key);
    
    NSData *EncryptData = [GTMBase64 decodeString:string];//解密前进行GTMBase64编码
    
    NSString * deDataStr = [AESHandler decryptAESData:EncryptData app_key:key];
    
    return deDataStr;
    
}

/**
 获取16位随机字符序列
 */
- (NSString *)get16bitRandomString{
    
    char base64EncodingTable[62] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
    };
    NSMutableString * randomStr = [[NSMutableString alloc] init];
    
    
    while (randomStr.length < 16) {
        int r = arc4random() % 62;
        [randomStr appendFormat:@"%c",base64EncodingTable[r]];
    }
    
    return randomStr;
}



/**
 生成签名
 */
- (NSString *)signString:(NSString *)signStr{
    
//    NSString * signedStr = [[signStr md5] lowercaseString]; // 签名字符串中的全部字母转为小写字母
    
    Encrypt * encypt = [[Encrypt alloc] init];
    
    NSString * signedStr = [[encypt md5WithString:signStr] lowercaseString];
    
    return signedStr;
    
}

/**
 字典转化为字符串
 */
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (NSString *)stringEncodeWithParam:(NSDictionary *)params{
    
    NSMutableString *urlString =[NSMutableString string];   //The URL starts with the base string[urlString appendString:baseString];
    NSString *escapedString;
    NSInteger keyIndex = 0;
    for (id key in params) {
        //First Parameter needs to be prefixed with a ? and any other parameter needs to be prefixed with an &
        if(keyIndex ==0) {
            
            escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[params valueForKey:key], NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8));
            [urlString appendFormat:@"%@=%@",key,escapedString];
            
        }else{
            
            escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[params valueForKey:key], NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8));
            [urlString appendFormat:@"&%@=%@",key,escapedString];
            
            
        }
        keyIndex++;
    }
    
    return urlString;
    
}

/**
 获取16位随机字符序列
 */
+ (NSString *)get16bitRandomString{
    
    char base64EncodingTable[62] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
    };
    NSMutableString * randomStr = [[NSMutableString alloc] init];
    
    
    while (randomStr.length < 16) {
        int r = arc4random() % 62;
        [randomStr appendFormat:@"%c",base64EncodingTable[r]];
    }
    
    return randomStr;
}



/**
 生成签名
 */
+ (NSString *)signString:(NSString *)signStr{
    
    Encrypt * encypt = [[Encrypt alloc] init];
    
    NSString * signedStr = [[encypt md5WithString:signStr] lowercaseString];
    
    return signedStr;
    
}



/**
 字典转化为字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


#pragma mark   ==============产生随机订单号==============

+ (NSString *)generateTradeNO
{
    static int kNumber = 20;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
