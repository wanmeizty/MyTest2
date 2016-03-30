//
//  CardView.m
//  TestZ
//
//  Created by wanmeizty on 16/3/1.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "CardView.h"

@implementation CardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        
    }
    
    return self;
}

- (void)createUI{
    
    self.cardIcon = [[UIImageView alloc] initWithFrame:GTRectMake(self.frame.origin.x + 10, 10, 20, 20)];
    
    [self addSubview:self.cardIcon];
    
    
    self.textLabel = [[UILabel alloc] initWithFrame:GTRectMake(self.frame.origin.x + 30, 0, 70, 40)];
    self.textLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.textLabel];
    
    
    self.numberLabel = [[UILabel alloc] initWithFrame:GTRectMake(self.frame.origin.x + 100, 0, 120, 40)];
    self.numberLabel.font = [UIFont systemFontOfSize:14];
    self.numberLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.numberLabel];
    
    
//    self.updateBtn = [[UIButton alloc] initWithFrame:GTRectMake(self.frame.size.width * 0.8, 0, self.frame.size.width * 0.2, 40)];
//    [self.updateBtn setTitle:@"🔁更换" forState:UIControlStateNormal];
//    [self.updateBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    self.updateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    self.updateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self addSubview:self.updateBtn];
    
    self.changeView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.8, 0, self.frame.size.width * 0.2, 40)];
    
    [self addSubview:self.changeView];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10.5, 24, 19)];
    
    
    imageView.image = [UIImage imageNamed:@"changeIcon1.png"];
    
    [self.changeView addSubview:imageView];
    
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, self.frame.size.width * 0.2-24, 40)];
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.text = @"更换";
    textLabel.textColor = [UIColor blueColor];
    [self.changeView addSubview:textLabel];
    
    
}


@end
