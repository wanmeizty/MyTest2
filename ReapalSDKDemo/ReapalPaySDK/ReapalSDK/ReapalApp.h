//
//  ReapalApp.h
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/28.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "GoodsOrder.h"

#import "ReapalSdk.h"


@interface ReapalApp : NSObject

/**
 *  支付接口
 *
 *  @param GoodsOrder             订单信息
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param mode           支付环境
 *  @param viewController 启动支付控件的viewController
 *  @return 返回成功失败
 */


- (void)startPay:(GoodsOrder *)order fromScheme:(NSString *)schemeStr mode:(ReapalStatus*)reapalSatus viewController:(UIViewController*)viewController;

@end
