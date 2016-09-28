//
//  AViewController.h
//  TestForPhotoes
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BViewController.h"

@class TGPickerImageManager;
@protocol TGPhotoLibraryControllerDelegate <NSObject>

- (void)pushToSelectedVC;

@end
@interface TGPhotoLibraryController : UIViewController

@property (nonatomic,weak) TGPickerImageManager *manager;
@property (nonatomic,strong)   NSMutableArray *imagesAssetArray;
@property (nonatomic,strong) NSMutableArray *selectedImages;
@property (nonatomic,weak) id <TGPhotoLibraryControllerDelegate> delegate;

@end
