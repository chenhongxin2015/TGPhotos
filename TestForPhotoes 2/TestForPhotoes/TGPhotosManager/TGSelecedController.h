//
//  CViewController.h
//  TestForPhotoes
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

//#import "BViewController.h"
@class TGPickerImageManager;
@interface TGSelecedController : UIViewController
@property (nonatomic,weak) TGPickerImageManager *pickerManager;

@end
