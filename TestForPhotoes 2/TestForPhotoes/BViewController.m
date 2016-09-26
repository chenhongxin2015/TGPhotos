//
//  BViewController.m
//  TestForPhotoes
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import "BViewController.h"
//#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TGImageCell.h"
#import "CViewController.h"
#import "AViewController.h"
#import "TGAssetModel.h"
#import "TGPickerImageManager.h"
static  ALAssetsLibrary *_assetsLibrary;
@interface BViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TGPickerImageManagerDelegate>
{
   
    NSMutableArray *_albumsArray;
    NSMutableArray *_imagesAssetArray;
//    ALAssetsLibrary *library;
    
}
@property (nonatomic,strong) TGPickerImageManager *pickerManager;
@property (nonatomic,strong)   NSMutableArray *selectedImages;
;

@end

@implementation BViewController
- (TGPickerImageManager *)pickerManager
{
    if (!_pickerManager) {
        _pickerManager = [TGPickerImageManager new];
        _pickerManager.delegate = self;
    }return _pickerManager;
}
- (NSMutableArray *)selectedImages
{
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray array];
    }return _selectedImages;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (self.pickerManager.selectedImages.count) {
//        TGAssetModel *asset = self.pickerManager.selectedImages[0];
//        ALAsset *asset1 = asset.asset;
//        ALAssetRepresentation *def = [asset1 defaultRepresentation];
//        UIImage *image =[UIImage imageWithCGImage: [def fullScreenImage]];
//    }
// 
    
    self.pickerManager.delegate = self;
}

- (void)pikerImageFinishedFromCamera:(BOOL)isCamera
{
    if (isCamera) {
        return;
    }
    
    
    [self pushToAVC];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
 
    if (self.pickerManager.selectedImages.count) {
        
//        CViewController *CVC = [CViewController new];
//        CVC.pickerManager = self.pickerManager;
//
//        self.pickerManager.selectedVC.pickerManager = se
        [self.navigationController pushViewController:self.pickerManager.selectedVC animated:YES];
        return;
    }
    

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getImageFromCamera];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self.pickerManager getListPhotosFromCamera:NO];
        
       

    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)pushToAVC
{
    AViewController *avc = [AViewController new];
    avc.manager= self.pickerManager;
    avc.delegate = self;
    
    [self.navigationController pushViewController:avc animated:YES];
}
- (void)selecteImages
{

    
    if (self.selectedImages.count) {
        CViewController *CVC = [CViewController new];

        [self.navigationController pushViewController:CVC animated:YES];
        return;
    }

}



- (void)pushToCVC
{

    
    if (self.pickerManager.selectedImages.count) {
//        CViewController *CVC = [CViewController new];
//        CVC.pickerManager = self.pickerManager;

        [self.navigationController pushViewController:self.pickerManager.selectedVC animated:YES];
        return;
    }

    
}
#pragma mark -- 从相机获取图片
- (void)selectedCameraImage
{
    if ([self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1] isKindOfClass:[BViewController class]]) {
        [self pushToCVC];
    }
}

- (void)pushCVCToWarning
{
    [self pushToCVC];
}





#pragma mark-- 拍照
- (void)getImageFromCamera
{
    
    [self.pickerManager getListPhotosFromCamera:YES];
  
    [self presentViewController:self.pickerManager.cameraVC animated:YES completion:nil];
}





- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//removeAllCachedResponses
}


@end
