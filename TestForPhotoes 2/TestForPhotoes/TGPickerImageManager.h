//
//  TGPickerImageManager.h
//  TestForPhotoes
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
//#import "CViewController.h"
@class CViewController;
@protocol  TGPickerImageManagerDelegate<NSObject>
@optional
- (void)pikerImageFinishedFromCamera:(BOOL)isCamera;
- (void)selectedCameraImage;
- (void)cancelSelectedCameraImage;
- (void)pushCVCToWarning;

- (void)warningForMaxCount;
@end
@interface TGPickerImageManager : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PHPhotoLibraryChangeObserver>
@property (nonatomic,weak) id <TGPickerImageManagerDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *albumsArray;
@property (nonatomic,strong) NSMutableArray *imagesAssetArray;;
@property (nonatomic,strong)   NSMutableArray *selectedImages;
;
@property (nonatomic,assign) NSInteger maxCount;//默认九张图片
@property (nonatomic,strong) UIImagePickerController *cameraVC;
@property (nonatomic,strong)  CViewController *selectedVC;
//- (instancetype)initWithMaxImageCount:(NSInteger)
- (void)getListPhotosFromCamera:(BOOL)isCamera;
@end
