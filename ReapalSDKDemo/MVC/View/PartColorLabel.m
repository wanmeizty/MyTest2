//
//  PartColorLabel.m
//  TestZ
//
//  Created by wanmeizty on 16/3/1.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "PartColorLabel.h"

@implementation PartColorLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (PartColorLabel *)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
    
}

- (void)labelAllStr:(NSString *)allStr andPartStr:(NSString *)partStr color:(UIColor *)color{
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:allStr];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range=[[hintString string]rangeOfString:partStr];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    self.attributedText=hintString;
}

@end
