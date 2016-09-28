//
//  TGNaviController.m
//  TestForPhotoes
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import "TGNaviController.h"

@interface TGNaviController ()

@end

@implementation TGNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationBar.tintColor  = [UIColor grayColor];
//    self.navigationI
    self.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
    self.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:13],
                                                                    NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]
                                                                    
                                                                    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
