//
//  DebitViewController.h
//  ReapalSDKDemo
//
//  Created by 一米阳光 on 16/3/29.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "ParentViewController.h"
@class GoodsOrder;

@interface DebitViewController : ParentViewController

@property (nonatomic,strong) GoodsOrder * order;
@property (nonatomic,copy) NSString * bankCode;
@property (nonatomic,copy) NSString * bankName;

@end
