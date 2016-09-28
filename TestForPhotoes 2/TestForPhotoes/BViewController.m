//
//  BViewController.m
//  TestForPhotoes
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import "BViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TGSelecedController.h"
#import "TGPhotoLibraryController.h"
#import "TGAssetModel.h"
#import "TGPickerImageManager.h"
#define TG_W [UIScreen mainScreen].bounds.size.width
#define TG_H [UIScreen mainScreen].bounds.size.height
static  ALAssetsLibrary *_assetsLibrary;
@interface BViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TGPickerImageManagerDelegate>
{
    NSMutableArray *_albumsArray;
    NSMutableArray *_imagesAssetArray;
    
    
}

@property (nonatomic,strong) TGPickerImageManager *pickerManager;



@end

@implementation BViewController
- (TGPickerImageManager *)pickerManager
{
    if (!_pickerManager) {
        _pickerManager = [TGPickerImageManager new];
//        _pickerManager.delegate = self;
    }return _pickerManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.pickerManager.delegate = self;
    
    if (!self.pickerManager.selecteImage.count) {
        return;
    }
    CGFloat w = TG_W / 3;
    for (int i = 0; i < self.pickerManager.selecteImage.count; i++) {
//        TGAssetModel *asset = self.pickerManager.selectedImage[i];
        UIImageView *imageView =self.pickerManager.selecteImage[i];
        imageView.frame = CGRectMake(10, 64, TG_W - 20, TG_H - 64);
        
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
//        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
//        //仅显示缩略图，不控制质量显示
//        /**
//         PHImageRequestOptionsResizeModeNone,
//         PHImageRequestOptionsResizeModeFast, //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
//         PHImageRequestOptionsResizeModeExact //精确的加载与传入size相匹配的图像
//         */
//        option.resizeMode = PHImageRequestOptionsResizeModeFast;
//        option.networkAccessAllowed = YES;
//        //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
//        
//        typeof(self) weakSelf = self;
//        [[PHCachingImageManager defaultManager] requestImageForAsset:asset.pAsset targetSize:CGSizeMake(TG_W * 3 ,TG_H * 3) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
//            //解析出来的图片
//            imageView.image = [weakSelf wf_thumbnailsCutfullPhoto:image];
//        }];
//        
////        NSLog(@"%@",NSStringFromCGRect(self.bounds));
//#else
//        imageView.image  =   [UIImage imageWithCGImage:asset.asset.thumbnail];
//#endif

//        imageView.image = self.pickerManager.selecteImage[i];
        [self.view addSubview:imageView];
        
    }
}
//裁剪图片,此处裁剪为125*125大的图,即为我们的缩略图
- (UIImage *)wf_thumbnailsCutfullPhoto:(UIImage*)fullPhoto
{
    CGSize newSize;
    CGImageRef imageRef = nil;
    if ((fullPhoto.size.width / fullPhoto.size.height) < 1) {
        newSize.width = fullPhoto.size.width;
        newSize.height = fullPhoto.size.width * 1;
        imageRef = CGImageCreateWithImageInRect([fullPhoto CGImage], CGRectMake(0, fabs(fullPhoto.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = fullPhoto.size.height;
        newSize.width = fullPhoto.size.height * 1;
        imageRef = CGImageCreateWithImageInRect([fullPhoto CGImage], CGRectMake(fabs(fullPhoto.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
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

    [self.navigationController pushViewController:self.pickerManager.photoVC animated:YES];
}
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

}




@end
