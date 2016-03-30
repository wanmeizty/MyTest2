//
//  MoneyView.m
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/21.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "MoneyView.h"

@implementation MoneyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    
    return self;
    
}

- (void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.totalFeeLabel = [[UILabel alloc] initWithFrame:GTRectMake(10, self.frame.origin.y, zwidth - 70, 40)];
    [self addSubview:self.totalFeeLabel];
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:GTRectMake(zwidth - 40, self.frame.origin.y, 40,40)];
    [self addSubview:self.imageView];
    
    
}




@end
