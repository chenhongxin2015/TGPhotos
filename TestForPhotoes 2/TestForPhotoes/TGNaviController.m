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
    
    
    

    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
