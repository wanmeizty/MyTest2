//
//  BindPayViewController.h
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/29.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//


#import "ParentViewController.h"

#import "GoodsOrder.h"

@interface BindPayViewController : ParentViewController

@property (nonatomic,strong) GoodsOrder * order;
//@property (nonatomic,strong) NSDictionary * cardInfo;

@property (nonatomic,strong) NSArray * cardList;


@end
