//
//  GetTime.h
//  xpkc
//
//  Created by TopSageOSX on 14-8-18.
//  Copyright (c) 2014年 _YanLu_. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetTime : NSObject
/**
 *  获取时间
 *  @return NSString精确到秒
 */
+(NSString *)getTime;
/**
 *  时间转换年月日
 */
+(NSString *)getYYMMDDWithDate:(NSDate *)date;
+(NSString *)getYYMMDDWithDate2:(NSDate *)date;
+(NSString *)getYYMMDDHHMMWithDate:(NSDate *)date;
@end
