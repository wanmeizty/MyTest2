//
//  CardView.h
//  TestZ
//
//  Created by wanmeizty on 16/3/1.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic,strong) UIImageView * cardIcon; // 银行卡图标

@property (nonatomic,strong) UILabel * textLabel; // 银行卡类型

@property (nonatomic,strong) UILabel * numberLabel; // 银行卡尾号

//@property (nonatomic,strong) UIButton * updateBtn;

@property (nonatomic,strong) UIView * changeView; // 更换



@end
