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
#import "TGSelecedController.h"
#import "TGPhotoLibraryController.h"
#import "TGAssetModel.h"
#import "TGPickerImageManager.h"
static  ALAssetsLibrary *_assetsLibrary;
@interface BViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TGPickerImageManagerDelegate,TGPhotoLibraryControllerDelegate>
{
   
    NSMutableArray *_albumsArray;
    NSMutableArray *_imagesAssetArray;
//    ALAssetsLibrary *library;
    
}

@property (nonatomic,strong) TGPickerImageManager *pickerManager;
//@property (nonatomic,strong)   NSMutableArray *selectedImages;
;
//- (void)pushToCVC;
@end

@implementation BViewController
- (TGPickerImageManager *)pickerManager
{
    if (!_pickerManager) {
        _pickerManager = [TGPickerImageManager new];
        _pickerManager.delegate = self;
    }return _pickerManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.pickerManager.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
 
    if (self.pickerManager.selectedImages.count) {

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
    TGPhotoLibraryController *avc = [TGPhotoLibraryController new];
    avc.manager= self.pickerManager;
    avc.delegate = self;
    
    [self.navigationController pushViewController:avc animated:YES];
}


//
//- (void)pushToCVC
//{
//
//    if (self.pickerManager.selectedImages.count) {
//        [self.navigationController pushViewController:self.pickerManager.selectedVC animated:YES];
//        return;
//    }
//
//    
//}






- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

}

#pragma mark -- TGPickerImageManagerDelegate
- (void)pikerImageFinishedFromCamera:(BOOL)isCamera
{
    if (isCamera) {
        return;
    }
    
    
    [self pushToAVC];
}
- (void)getImageFromCamera
{
    
    [self.pickerManager getListPhotosFromCamera:YES];
    
    [self presentViewController:self.pickerManager.cameraVC animated:YES completion:nil];
}
- (void)selectedCameraImage
{
    if ([self.navigationController.viewControllers[self.navigationController.viewControllers.count - 1] isKindOfClass:[BViewController class]]) {
        if (self.pickerManager.selectedImages.count) {
            [self.navigationController pushViewController:self.pickerManager.selectedVC animated:YES];
            return;
        }
    }
}

- (void)pushCVCToWarning
{
    
    if (self.pickerManager.selectedImages.count) {
        [self.navigationController pushViewController:self.pickerManager.selectedVC animated:YES];
        return;
    }
//    [self pushToCVC];
}
#pragma mark -- TGPhotoLibraryControllerDelegate
- (void)pushToSelectedVC{
    
    if (self.pickerManager.selectedImages.count) {
        [self.navigationController pushViewController:self.pickerManager.selectedVC animated:YES];
        return;
    }
    
    //    [self pushToCVC];
}




@end
