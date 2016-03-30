//
//  ReapalSdk.h
//  TestZ
//
//  Created by wanmeizty on 16/2/26.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^CompletionBlock)(NSDictionary *resultDic);

typedef NS_ENUM(NSInteger,ReapalStatus) {
    
    ReapalTestStatus,        //测试环境
    ReapalFormalStatus        //正式环境

};

@interface ReapalSdk : NSObject

/**
 单例对象
 */

+ (ReapalSdk *)defaultSdk;

/**
 *  卡BIN查询接口
 *
 *  @param params 加密数据字典
 *  @param callback 退款完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)bankCardWithDictionary:(NSDictionary *)params
                        isTest:(ReapalStatus)reapalStatus
                      callback:(CompletionBlock)completionBlock;

/**
 *  储蓄卡签约支付请求接口
 *
 *  @param params 加密数据字典
 *  @param callback 请求完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)debitWithDictionary:(NSDictionary *)params
                     isTest:(ReapalStatus)reapalStatus
                   callback:(CompletionBlock)completionBlock;

/**
 *  信用卡签约支付请求接口
 *
 *  @param params 加密数据字典
 *  @param callback 请求完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 *
 */

- (void)creditWithDictionary:(NSDictionary *)params
                      isTest:(ReapalStatus)reapalStatus
                    callback:(CompletionBlock)completionBlock;

/**
 *  查询绑卡信息列表接口
 *
 *  @param params 加密参数数据字典
 *  @param callback 查询完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)searchBindCardlistWithDictionary:(NSDictionary *)params
                                  isTest:(ReapalStatus)reapalStatus
                                callback:(CompletionBlock)completionBlock;
/**
 *  绑卡支付请求接口
 *
 *  @param params 加密数据字典
 *  @param callback 请求完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)bindCardWithDictionary:(NSDictionary *)params
                        isTest:(ReapalStatus)reapalStatus
                      callback:(CompletionBlock)completionBlock;

/**
 *  确认支付接口
 *
 *  @param params 加密数据字典
 *  @param callback 退款完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)payWithDictionary:(NSDictionary *)params
                   isTest:(ReapalStatus)reapalStatus
                 callback:(CompletionBlock)completionBlock;
/**
 *  支付结果查询接口
 *
 *  @param params 加密数据字典
 *  @param callback 请求完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)searchWithDictionary:(NSDictionary *)params
                      isTest:(ReapalStatus)reapalStatus
                    callback:(CompletionBlock)completionBlock;

/**
 *  解绑卡接口
 *
 *  @param params 加密数据字典
 *  @param callback 请求完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)cancleBindCardWithDictionary:(NSDictionary *)params
                              isTest:(ReapalStatus)reapalStatus
                            callback:(CompletionBlock)completionBlock;
/**
 *  发送短信接口
 *
 *  @param params 加密数据字典
 *  @param callback 请求完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)smsWithDictionary:(NSDictionary *)params
                   isTest:(ReapalStatus)reapalStatus
                 callback:(CompletionBlock)completionBlock;


   
/**
 *  退款请求接口
 *
 *  @param params 加密参数数据字典
 *  @param callback 查询完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)refundWithDictionary:(NSDictionary *)params
                      isTest:(ReapalStatus)reapalStatus
                    callback:(CompletionBlock)completionBlock;

/**
 *  卡密鉴权接口
 *
 *  @param params 加密参数数据字典
 *  @param callback 查询完成后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)certificateWithDictionary:(NSDictionary *)params
                      isTest:(ReapalStatus)reapalStatus
                    callback:(CompletionBlock)completionBlock;

/**
 *  更换手机号接口
 *
 *  @param params 加密参数数据字典
 *  @param callback 更换手机号后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)changePhoneWithDictionary:(NSDictionary *)params
                           isTest:(ReapalStatus)reapalStatus
                         callback:(CompletionBlock)completionBlock;





@end
