//
//  GetTime.m
//  xpkc
//
//  Created by TopSageOSX on 14-8-18.
//  Copyright (c) 2014年 _YanLu_. All rights reserved.
//

#import "GetTime.h"

@implementation GetTime
+(NSString *)getTime{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    NSString *timeString = [NSString stringWithFormat:@"%lld", date];
    return timeString;
}
+(NSString *)getYYMMDDWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
+(NSString *)getYYMMDDWithDate2:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
+(NSString *)getYYMMDDHHMMWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 hh:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
@end
