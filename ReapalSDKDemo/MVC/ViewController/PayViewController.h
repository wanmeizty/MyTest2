//
//  PayViewController.h
//  TestZ
//
//  Created by wanmeizty on 16/2/23.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ParentViewController.h"

#import "GoodsOrder.h"

@interface PayViewController : ParentViewController

@property (nonatomic,strong) GoodsOrder * order;
@property (nonatomic,strong) NSDictionary * cardInfo;

@property (nonatomic ,assign) BOOL isBind;

@end
