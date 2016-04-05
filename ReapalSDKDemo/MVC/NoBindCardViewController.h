//
//  NoBindCardViewController.h
//  ReapalSDKDemo
//
//  Created by 一米阳光 on 16/3/30.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "ParentViewController.h"
@class GoodsOrder;
@interface NoBindCardViewController : ParentViewController

@property (nonatomic,strong) GoodsOrder * order;

@property (nonatomic,assign) BOOL isNotFirst;

@end
