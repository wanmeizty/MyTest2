//
//  ParentViewController.h
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/24.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReapalSdk.h"

#import "ReapalUtil.h"


static NSInteger viewCount;

@interface ParentViewController : UIViewController

@property (nonatomic,strong) UIView * mainView;

@property (nonatomic,strong) UIView * customNavigationBar;

- (void)createViewWithTitle:(NSString *)title
                    orderNO:(NSString *)orderNO
                   totalFee:(NSString *)totalfee;

- (void)unfold;

- (void)goToBack;

@end
