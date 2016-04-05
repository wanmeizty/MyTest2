//
//  DebitTableViewCell.h
//  ReapalSDKDemo
//
//  Created by 一米阳光 on 16/3/28.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *phoneTarget;
@property (weak, nonatomic) IBOutlet UIImageView *bankCodeImg;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;

@end
