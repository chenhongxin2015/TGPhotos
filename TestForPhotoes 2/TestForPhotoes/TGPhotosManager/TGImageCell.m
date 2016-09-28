//
//  TGImageCell.m
//  TestForPhotoes
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import "TGImageCell.h"
#import <Photos/Photos.h>
@implementation TGImageCell


- (void)setAsset:(TGAssetModel *)asset
{
    _asset = asset;
    
    // 获取资源图片的 fullScreenImage
//    UIImage *contentImage = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    //仅显示缩略图，不控制质量显示
    /**
     PHImageRequestOptionsResizeModeNone,
     PHImageRequestOptionsResizeModeFast, //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
     PHImageRequestOptionsResizeModeExact //精确的加载与传入size相匹配的图像
     */
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
//    __block NSInteger num = 0;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset.pAsset targetSize:CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height * 3) contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {

        self.imageView.image = [self wf_thumbnailsCutfullPhoto:image];

    }];
#else
  self.imageView.image  =   [UIImage imageWithCGImage:asset.asset.thumbnail];
#endif
    
//    ALAssetRepresentation *representation = [asset.asset defaultRepresentation];
  
   
    self.selectedBtn.hidden = !asset.isSelected;

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
- (IBAction)selectedBtn:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    self.asset.isSelected = sender.selected;
}
@end
