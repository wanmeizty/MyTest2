//
//  PartColorLabel.h
//  TestZ
//
//  Created by wanmeizty on 16/3/1.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartColorLabel : UILabel

- (PartColorLabel *)initWithFrame:(CGRect )frame;

- (void)labelAllStr:(NSString *)allStr andPartStr:(NSString *)partStr color:(UIColor *)color;

@end
