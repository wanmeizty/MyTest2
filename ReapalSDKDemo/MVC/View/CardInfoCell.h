//
//  CardInfoCell.h
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/29.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardInfoCell : UITableViewCell

@property (nonatomic,strong) UIImageView * cardIcon; // 银行卡图标

@property (nonatomic,strong) UILabel * typeLabel; // 银行卡类型

@property (nonatomic,strong) UILabel * numberLabel; // 银行卡尾号

@end
