//
//  ReapalSdk.m
//  TestZ
//
//  Created by wanmeizty on 16/2/26.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "ReapalSdk.h"

@interface ReapalSdk()

@property (nonatomic,copy) void(^postBlock)(NSString *);

@end


@implementation ReapalSdk

//typedef void(^postBlock)(NSDictionary *resultDic);

/**
 单例对象
 */

+ (ReapalSdk *)defaultSdk{
    
    static ReapalSdk * reapalSdk;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        reapalSdk = [[ReapalSdk alloc] init];
        
    });
    
    return reapalSdk;
    
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        
    }
    
    return self;
    
}

- (void)postRequestWithURLStr:(NSString *)urlStr andPara:(NSDictionary *)params callback:(CompletionBlock)completionBlock{
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    
    NSString *str= [self stringEncodeWithParam:params];  // @"username=wyzc&pwd=wyzc";
    
    
    
//    NSLog(@"%@?%@",urlStr,str);
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod=@"POST";
    
    request.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
    //此处发送千万不能设置，这个地方只发送了口令数据接收者未使用json格式
    //  [request setValue:@"application/jason" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    
//        NSLog(@"error==>%@",error);
//        
//        NSLog(@"response==>%@",response);
//        
//        NSLog(@"data==>%@",data);
//        
//        NSError * myError;
//        
//        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&myError];
//        
//        NSLog(@"dict==>%@",dict);
//        NSLog(@"myError==>%@",myError);
        
        NSDictionary * rootDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        
        completionBlock(rootDic);
        
        
    }];
    [dataTask resume];
    
    
}



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
                 callback:(CompletionBlock)completionBlock{
    
    NSString * urlStr;
    if (reapalStatus == ReapalTestStatus) {
        urlStr = @"http://testapi.reapal.com/fast/bankcard/list";
    }else{
        urlStr = @"http://api.reapal.com/fast/bankcard/list";
    }
                            
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
       
        completionBlock(resultDic);
        
    }];

    
}

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
                   callback:(CompletionBlock)completionBlock
                     {
    
     NSString * urlStr;
                         
     if (reapalStatus == ReapalTestStatus) {// 测试环境
         
         urlStr = @"http://testapi.reapal.com/fast/debit/portal";
         
     }else{
         
         urlStr = @"http://api.reapal.com/fast/debit/portal";
     }

    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];

    
}

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
                   callback:(CompletionBlock)completionBlock
                      {
                          
      NSString * urlStr;
      
      if (reapalStatus == ReapalTestStatus) {// 测试环境
          
          urlStr = @"http://testapi.reapal.com/fast/credit/portal";
          
      }else{
          
          urlStr = @"http://api.reapal.com/fast/credit/portal";
      }
    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];

    
}

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
                                callback:(CompletionBlock)completionBlock
                                  {
                                      NSString * urlStr;
                                      
      if (reapalStatus == ReapalTestStatus) {// 测试环境
          
          urlStr = @"http://testapi.reapal.com/fast/bindcard/list";
          
      }else{
          
          urlStr = @"http://api.reapal.com/fast/bindcard/list";
      }
    
//    NSString * urlStr = @"http://testapi.reapal.com/fast/bindcard/list";
    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];

    
    
}

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
                      callback:(CompletionBlock)completionBlock
                        {
    NSString * urlStr;
                            
    if (reapalStatus == ReapalTestStatus) {// 测试环境
        
        urlStr = @"http://testapi.reapal.com/fast/bindcard/portal";
        
    }else{
        
        urlStr = @"http://api.reapal.com/fast/bindcard/portal";
    }

    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];

    
}

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
                 callback:(CompletionBlock)completionBlock
                   {
    
    NSString * urlStr ;
                       
   if (reapalStatus == ReapalTestStatus) {// 测试环境
       
       urlStr = @"http://testapi.reapal.com/fast/pay";
       
   }else{
       
       urlStr = @"http://api.reapal.com/fast/pay";
   }
    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];

    
}

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
                      callback:(CompletionBlock)completionBlock
                      {
      NSString * urlStr ;
      
      if (reapalStatus == ReapalTestStatus) {// 测试环境
          
          urlStr = @"http://testapi.reapal.com/fast/search";
          
      }else{
          
          urlStr = @"http://testapi.reapal.com/fast/search";
      }
    
    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];

    
}

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
                      callback:(CompletionBlock)completionBlock
                              {
      NSString * urlStr ;
      
      if (reapalStatus == ReapalTestStatus) {// 测试环境
          
          urlStr = @"http://testapi.reapal.com/fast/cancle/bindcard";
          
      }else{
          
          urlStr = @"http://api.reapal.com/fast/cancle/bindcard";
      }
    
    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];

    
}

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
                 callback:(CompletionBlock)completionBlock
                   {
    
   NSString * urlStr ;
   
   if (reapalStatus == ReapalTestStatus) {// 测试环境
       
       urlStr = @"http://testapi.reapal.com/fast/sms";
       
   }else{
       
       urlStr = @"http://api.reapal.com/fast/sms";
   }
    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];

    
    
}


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
                                callback:(CompletionBlock)completionBlock{
    
    NSString * urlStr ;
    
    if (reapalStatus == ReapalTestStatus) {// 测试环境
        
        urlStr = @"http://testapi.reapal.com/fast/refund";
        
    }else{
        
        urlStr = @"http://api.reapal.com/fast/refund";
    }

    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];

    
    
}

/**
 *  卡密鉴权接口
 *
 *  @param params 加密参数数据字典
 *  @param callback 卡密鉴权后回调取得结果
 *  @param isTest 是否测试环境
 *
 */

- (void)certificateWithDictionary:(NSDictionary *)params
                           isTest:(ReapalStatus)reapalStatus
                         callback:(CompletionBlock)completionBlock{
    
    NSString * urlStr ;
    
    if (reapalStatus == ReapalTestStatus) {// 测试环境
        
        urlStr = @"http://testapi.reapal.com/fast/certificate";
        
    }else{
        
        urlStr = @"http://api.reapal.com/fast/certificate";
    }
    
//    NSLog(@"params==>%@",params);
    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];
    
}

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
                         callback:(CompletionBlock)completionBlock{
    
    NSString * urlStr ;
    
    if (reapalStatus == ReapalTestStatus) {// 测试环境
        
        urlStr = @"http://testapi.reapal.com/fast/changePhone";
        
    }else{
        
        urlStr = @"http://api.reapal.com/fast/changePhone";
    }
    
    
    [self postRequestWithURLStr:urlStr andPara:params callback:^(NSDictionary *resultDic) {
        
        completionBlock(resultDic);
        
    }];
    
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


@end
