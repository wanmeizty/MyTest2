//
//  CardViewController.h
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/28.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ParentViewController.h"

#import "GoodsOrder.h"

@interface CardViewController : ParentViewController

@property (nonatomic,strong) GoodsOrder * order;

@property (nonatomic,assign) BOOL isNotFirst;

@end
