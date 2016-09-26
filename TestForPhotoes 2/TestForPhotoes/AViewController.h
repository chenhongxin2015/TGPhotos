//
//  AViewController.h
//  TestForPhotoes
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BViewController.h"
#import "TGPickerImageManager.h"
@interface AViewController : UIViewController
@property (nonatomic,strong) TGPickerImageManager *manager;
@property (nonatomic,strong)   NSMutableArray *imagesAssetArray;
@property (nonatomic,strong) NSMutableArray *selectedImages;
@property (nonatomic,weak) BViewController *delegate;

@end
