//
//  ParentViewController.m
//  ReapalSDKDemo
//
//  Created by wanmeizty on 16/3/24.
//  Copyright © 2016年 wanmeizty. All rights reserved.
//

#import "ParentViewController.h"



#import "MoneyView.h"

@interface ParentViewController ()
{

    BOOL _isUnfold;
    
    MoneyView * _moneyView;
}
@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationbar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
//    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBarHidden = YES;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, zwidth, 44)];
    
    self.customNavigationBar = view;
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(zwidth * 0.5 - 50,0, 100, 44)];
    titleLabel.text = @"融宝收银台";
    titleLabel.textAlignment = NSTextAlignmentCenter ;
    titleLabel.textColor = [UIColor whiteColor];
    [view addSubview:titleLabel];
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    
    [backBtn setImage:[UIImage imageNamed:@"buttons_05.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    
    
    self.view.backgroundColor = [UIColor whiteColor];

}



- (void)goToBack{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)createViewWithTitle:(NSString *)title
                    orderNO:(NSString *)orderNO
                   totalFee:(NSString *)totalfee{
    
    UIView * headView = [[UIView alloc] initWithFrame:GTRectMake(0, 64, self.view.frame.size.width, 90)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    NSArray * array = @[@"商品名称",@"订单号"];
    for (int i = 0; i < array.count; i ++) {
        
        UILabel * headLabel = [[UILabel alloc] initWithFrame:GTRectMake(10, 10 + i * 40, self.view.frame.size.width - 20, 30)];
        [headView addSubview:headLabel];
        if (i == 0) {
            
            headLabel.text = [NSString stringWithFormat:@"%@:    %@",array[i],title];
            
        }else if(i == 1){
            
            headLabel.text = [NSString stringWithFormat:@"%@:    %@",array[i],orderNO];
            
        }
        
        UILabel * myline = [[UILabel alloc] initWithFrame:GTRectMake(10, 40 + i * 45, self.view.frame.size.width - 10, 1)];
        myline.backgroundColor = [UIColor lightGrayColor];
        [headView addSubview:myline];
        
        
        
    }
    
    self.mainView = [[UIView alloc] initWithFrame:GTRectMake(0, 64 , self.view.frame.size.width, zheight - 64)];
    
    self.mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.mainView.userInteractionEnabled = YES;
    [self.view addSubview:self.mainView];
    

    
    MoneyView * moneyView = [[MoneyView alloc] initWithFrame:GTRectMake(0, 0, zwidth, 40)];
    
    
    NSString *contentStr = [NSString stringWithFormat:@"应付金额：￥%.2f",[totalfee doubleValue] / 100.0]; //@"简介：￥hello world";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, contentStr.length - 5 )];

    moneyView.totalFeeLabel.font = [UIFont boldSystemFontOfSize:16];
    moneyView.totalFeeLabel.attributedText = str;
    _moneyView = moneyView;
    
    

    
    moneyView.imageView.image = [UIImage imageNamed:@"down.png"];
    [self.mainView addSubview:moneyView];
    
    
    _isUnfold = NO;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unfold)];
    [moneyView addGestureRecognizer:tap];
    
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:GTRectMake(0, 40, self.view.frame.size.width, 10)];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.mainView addSubview:label];
    
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

- (void)unfold{
    
    
    if (!_isUnfold) {
        
        NSLog(@"开始展开");
        
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect rect = self.mainView.frame;
            
            rect.origin.y = 90 + 64;
            
            self.mainView.frame = rect;
            
        }];
        
        
        _moneyView.imageView.image = [UIImage imageNamed:@"right.png"];
        _isUnfold = YES;
        
        
    }else{
        NSLog(@"开始闭合");
        
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect rect = self.mainView.frame;
            
            rect.origin.y = 0 + 64;
            
            self.mainView.frame = rect;
            
        }];
        

        _moneyView.imageView.image = [UIImage imageNamed:@"down.png"];
        _isUnfold = NO;
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
