//
//  RSAHandler.m
//  ReapalUnionPaySdk
//
//  Created by wanmeizty on 16/2/16.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "RSAHandler.h"

#include <openssl/rsa.h>
#include <openssl/pem.h>
#include <openssl/err.h>
#include <openssl/md5.h>

// 加密填充模式
typedef enum {
    RSA_PADDING_TYPE_NONE       = RSA_NO_PADDING, // 不填充
    RSA_PADDING_TYPE_PKCS1      = RSA_PKCS1_PADDING, // 最常用的模式
    RSA_PADDING_TYPE_SSLV23     = RSA_SSLV23_PADDING
}RSA_PADDING_TYPE;

#define  PADDING   RSA_PADDING_TYPE_PKCS1


@implementation RSAHandler
{
    
    RSA* _rsa_pub; // 公钥文件
    RSA* _rsa_pri; // 私钥文件
}
#pragma mark - public methord

/**
 字符串获取导入公钥私钥
 */
- (void)getPriKey:(NSString * )privateKeyString AndPubKey:(NSString *)publicKeyString{
    // 读取字符串方式
    [self importKeyWithType:KeyTypePrivate andkeyString:privateKeyString];
    [self importKeyWithType:KeyTypePublic andkeyString:publicKeyString];
}

/**
 文件路径获取公钥私钥
 */
- (void)getPriKeyPath:(NSString *)privateKeyName AndPubKeyPath:(NSString *)publicKeyName{
    
    // 读pem文件方式  公钥
    NSString *publicKeyFilePath = [[NSBundle mainBundle] pathForResource:publicKeyName ofType:nil];
    // 读pem文件方式 私钥
    NSString *privateKeyFilePath = [[NSBundle mainBundle] pathForResource:privateKeyName ofType:nil];
    // 导入pem,或key文件方式
    [self importKeyWithType:KeyTypePublic andPath:publicKeyFilePath];
    [self importKeyWithType:KeyTypePrivate andPath:privateKeyFilePath];
    
}


/**
 *  通过文件路径方式导入公钥私钥
 *
 *  @param type 秘钥类型
 *  @param path 秘钥路径
 *
 */
- (BOOL)importKeyWithType:(KeyType)type andPath:(NSString*)path
{
    BOOL status = NO;
    // oc字符串转换为c语言字符串
    const char* cPath = [path cStringUsingEncoding:NSUTF8StringEncoding];
    
    // 打开二进制文件
    FILE* file = fopen(cPath, "rb");
    if (!file) {
        return status;
    }
    
    // 公钥
    if (type == KeyTypePublic) {
        _rsa_pub = NULL;
        
        // 读取 RSA 公钥pem文件
        if((_rsa_pub = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL))){
            status = YES;
        }
        
        // 私钥
    }else if(type == KeyTypePrivate){
        _rsa_pri = NULL;
        
        // 读取 RSA 私钥pem文件
        if ((_rsa_pri = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL))) {
            status = YES;
        }
        
    }
    // 关闭文件
    fclose(file);
    return status;
    
}

/**
 *  通过传入字符串方式导入公钥私钥
 *
 *  @param type 秘钥类型
 *  @param path 秘钥字符串
 *
 */

- (BOOL)importKeyWithType:(KeyType)type andkeyString:(NSString *)keyString
{
    if (!keyString) {
        return NO;
    }
    BOOL status = NO;
    BIO *bio = NULL;
    RSA *rsa = NULL;
    
    // 创建一个bio文件
    bio = BIO_new(BIO_s_file());
    NSString* temPath = NSTemporaryDirectory();
    
    NSLog(@"%@",temPath);
    
    
    NSString* rsaFilePath = [temPath stringByAppendingPathComponent:@"RSAKEY"];
    
    // 秘钥格式转换
    NSString* formatRSAKeyString = [self formatRSAKeyWithKeyString:keyString andKeytype:type];
    
    //写文件到本地
    BOOL writeSuccess = [formatRSAKeyString writeToFile:rsaFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (!writeSuccess) {
        return NO;
    }
    
    // c语言路径
    const char* cPath = [rsaFilePath cStringUsingEncoding:NSUTF8StringEncoding];
    
    // 读取bio格式的文件
    BIO_read_filename(bio, cPath);
    if (type == KeyTypePrivate) {
        // 从BIO重加载RSAPrivateKey格式私钥证书
        rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, "");
        _rsa_pri = rsa;
        
        
        if (rsa != NULL && 1 == RSA_check_key(rsa)) {
            status = YES;
        } else {
            status = NO;
        }
        
        
    }
    else{
        // 从BIO重加载RSAPublicKey格式公钥证书
        rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);
        
        _rsa_pub = rsa;
        if (rsa != NULL) {
            status = YES;
        } else {
            status = NO;
        }
    }
    
    BIO_free_all(bio);
    // 移除RSA文件
    [[NSFileManager defaultManager] removeItemAtPath:rsaFilePath error:nil];
    return status;
}


#pragma mark RSA sha1验证签名
//signString为base64字符串
- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString
{
    if (!_rsa_pub) {
        NSLog(@"please import public key first");
        return NO;
    }
    
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = [[NSData alloc]initWithBase64EncodedString:signString options:0];
    unsigned char *sig = (unsigned char *)[signatureData bytes];
    unsigned int sig_len = (int)[signatureData length];
    
    
    
    
    unsigned char sha1[20];
    SHA1((unsigned char *)message, messageLength, sha1);
    int verify_ok = RSA_verify(NID_sha1
                               , sha1, 20
                               , sig, sig_len
                               , _rsa_pub);
    
    if (1 == verify_ok){
        return   YES;
    }
    return NO;
    
    
}
#pragma mark RSA MD5 验证签名
- (BOOL)verifyMD5String:(NSString *)string withSign:(NSString *)signString
{
    if (!_rsa_pub) {
        NSLog(@"please import public key first");
        return NO;
    }
    
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    // int messageLength = (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSData *signatureData = [[NSData alloc]initWithBase64EncodedString:signString options:0];
    unsigned char *sig = (unsigned char *)[signatureData bytes];
    unsigned int sig_len = (int)[signatureData length];
    
    unsigned char digest[MD5_DIGEST_LENGTH];
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, message, strlen(message));
    MD5_Final(digest, &ctx);
    int verify_ok = RSA_verify(NID_md5
                               , digest, MD5_DIGEST_LENGTH
                               , sig, sig_len
                               , _rsa_pub);
    if (1 == verify_ok){
        return   YES;
    }
    return NO;
    
}

- (NSString *)signString:(NSString *)string
{
    if (!_rsa_pri) {
        NSLog(@"please import private key first");
        return nil;
    }
    // oc转换为c字符串
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int messageLength = (int)strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
    unsigned int sig_len;
    
    unsigned char sha1[20];
    SHA1((unsigned char *)message, messageLength, sha1);
    
    // 签名
    int rsa_sign_valid = RSA_sign(NID_sha1
                                  , sha1, 20
                                  , sig, &sig_len
                                  , _rsa_pri);
    if (rsa_sign_valid == 1) {
        NSData* data = [NSData dataWithBytes:sig length:sig_len];
        
        NSString * base64String = [data base64EncodedStringWithOptions:0];
        free(sig);
        return base64String;
    }
    
    free(sig);
    return nil;
}
- (NSString *)signMD5String:(NSString *)string
{
    if (!_rsa_pri) {
        NSLog(@"please import private key first");
        return nil;
    }
    const char *message = [string cStringUsingEncoding:NSUTF8StringEncoding];
    //int messageLength = (int)strlen(message);
    unsigned char *sig = (unsigned char *)malloc(256);
    unsigned int sig_len;
    
    unsigned char digest[MD5_DIGEST_LENGTH];
    MD5_CTX ctx;
    MD5_Init(&ctx);
    MD5_Update(&ctx, message, strlen(message));
    MD5_Final(digest, &ctx);
    
    // 签名
    int rsa_sign_valid = RSA_sign(NID_md5
                                  , digest, MD5_DIGEST_LENGTH
                                  , sig, &sig_len
                                  , _rsa_pri);
    
    if (rsa_sign_valid == 1) {
        NSData* data = [NSData dataWithBytes:sig length:sig_len];
        
        NSString * base64String = [data base64EncodedStringWithOptions:0];
        free(sig);
        return base64String;
    }
    
    free(sig);
    return nil;
    
    
}

/**
 *  RSA 公钥加密
 *
 *  @param encontent 加密的内容
 *
 */

- (NSString *) encryptWithPublicKey:(NSString*)encontent
{
    if (!_rsa_pub) {
        NSLog(@"please import public key first");
        return nil;
    }
    int status;
    int length  = (int)[encontent length];
    unsigned char input[length + 1];
    bzero(input, length + 1);
    int i = 0;
    for (; i < length; i++)
    {
        input[i] = [encontent characterAtIndex:i];
    }
    // 根据填充模式获得字符串长度
    NSInteger  flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING andRSA:_rsa_pub];
    
    char *encData = (char*)malloc(flen);
    
    // 将内存（字符串）前n个字节清零
    bzero(encData, flen);
    
    // RSA 公钥加密
    status = RSA_public_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa_pub, PADDING);
    
    if (status){
        NSData *returnData = [NSData dataWithBytes:encData length:status];
        free(encData);
        encData = NULL;
        
        //NSString *ret = [returnData base64EncodedString];
        NSString *ret = [returnData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength];
        return ret;
    }
    
    free(encData);
    encData = NULL;
    
    return nil;
}

/**
 *  RSA 私钥解密
 *
 *  @param decontent 解密的内容
 *
 */
- (NSString *) decryptWithPrivatecKey:(NSString*)decontent
{
    if (!_rsa_pri) {
        NSLog(@"please import private key first");
        return nil;
    }    int status;
    
    //NSData *data = [content base64DecodedData];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:decontent options:NSDataBase64DecodingIgnoreUnknownCharacters];
    int length = (int)[data length];
    
    // 根据填充模式获得字符串长度
    NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING andRSA:_rsa_pri];
    char *decData = (char*)malloc(flen);
    
    // 将内存（字符串）前n个字节清零
    bzero(decData, flen);
    
    // RSA 私钥解密
    status = RSA_private_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa_pri, PADDING);
    
    if (status)
    {
        // 解密字符串
        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
        free(decData);
        decData = NULL;
        
        return decryptString;
    }
    
    free(decData);
    decData = NULL;
    
    return nil;
}


/**
 *  RSA 私钥加密
 *
 *  @param encontent 加密的内容
 *
 */

- (NSString *) encryptWithPrivatecKey:(NSString*)encontent{
    
    
    if (!_rsa_pri) {
        NSLog(@"please import private key first");
        return nil;
    }
    int status;
    int length  = (int)[encontent length];
    unsigned char input[length + 1];
    bzero(input, length + 1);
    int i = 0;
    for (; i < length; i++)
    {
        input[i] = [encontent characterAtIndex:i];
    }
    // 根据填充模式获得字符串长度
    NSInteger  flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING andRSA:_rsa_pri];
    
    char *encData = (char*)malloc(flen);
    
    // 将内存（字符串）前n个字节清零
    bzero(encData, flen);
    
    // RSA 私钥加密
    
    status = RSA_private_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa_pri, PADDING);
    
    if (status){
        NSData *returnData = [NSData dataWithBytes:encData length:status];
        free(encData);
        encData = NULL;
        
        //NSString *ret = [returnData base64EncodedString];
        NSString *ret = [returnData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength];
        return ret;
    }
    
    free(encData);
    encData = NULL;
    
    return nil;
}

/**
 *  RSA 公钥解密
 *
 *  @param decontent 解密的内容
 *
 */
- (NSString *) decryptWithPublicKey:(NSString*)decontent{
    
    if (!_rsa_pub) {
        NSLog(@"please import public key first");
        return nil;
    }    int status;
    
    //NSData *data = [content base64DecodedData];
    NSData *data = [[NSData alloc]initWithBase64EncodedString:decontent options:NSDataBase64DecodingIgnoreUnknownCharacters];
    int length = (int)[data length];
    
    // 根据填充模式获得字符串长度
    NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING andRSA:_rsa_pub];
    char *decData = (char*)malloc(flen);
    
    // 将内存（字符串）前n个字节清零
    bzero(decData, flen);
    
    // RSA 公钥解密
    status = RSA_public_decrypt(length,(unsigned char*)[data bytes], (unsigned char*)decData, _rsa_pub, PADDING);
    
    if (status)
    {
        // 解密字符串
        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
        free(decData);
        decData = NULL;
        
        return decryptString;
    }
    
    free(decData);
    decData = NULL;
    
    return nil;
    
}

// 根据填充类型得到秘钥字符串长度
- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type andRSA:(RSA*)rsa
{
    int len = RSA_size(rsa);
    
    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }
    
    return len;
}


// 公钥私钥 格式拼接
-(NSString*)formatRSAKeyWithKeyString:(NSString*)keyString andKeytype:(KeyType)type
{
    NSInteger lineNum = -1;
    NSMutableString *result = [NSMutableString string];
    
    // 私钥
    if (type == KeyTypePrivate) {
        //        [result appendString:@"-----BEGIN PRIVATE KEY-----\n"];
        
        [result appendString:@"-----BEGIN RSA PRIVATE KEY-----\n"];
        
        lineNum = 79;
        
        // 公钥
    }else if(type == KeyTypePublic){
        [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
        
        
        lineNum = 76;
    }
    
    int count = 0;
    // oc字符串转换为c语言字符串
    for (int i = 0; i < [keyString length]; ++i) {
        unichar c = [keyString characterAtIndex:i];
        if (c == '\n' || c == '\r') {
            continue;
        }
        
        [result appendFormat:@"%c", c];
        if (++count == lineNum) {
            
            [result appendString:@"\n"];
            
            count = 0;
            
        }
    }
    if (type == KeyTypePrivate) {
        //        [result appendString:@"\n-----END PRIVATE KEY-----"];
        [result appendString:@"\n-----END RSA PRIVATE KEY-----"];
        
    }else if(type == KeyTypePublic){
        [result appendString:@"\n-----END PUBLIC KEY-----"];
    }
    return result;
    
}


@end
