//
//  CardInfoCell.m
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/29.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "CardInfoCell.h"

@implementation CardInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self createUI];
        
    }
    
    return self;
}

- (void)createUI{
    
    self.cardIcon = [[UIImageView alloc] initWithFrame:CGRectMake( 0 + 10, 12, 16, 16)];
    
    [self.contentView addSubview:self.cardIcon];
    
    
    NSLog(@"%f--%f--%f--%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 40, 0, 140, 40)];
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.typeLabel];
    
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake( 180, 0, 60, 40)];
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.numberLabel];
    
}

@end
