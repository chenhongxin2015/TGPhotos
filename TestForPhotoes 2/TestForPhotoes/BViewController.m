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
#import "TGImageCell.h"
#define TG_W [UIScreen mainScreen].bounds.size.width
#define TG_H [UIScreen mainScreen].bounds.size.height
static  ALAssetsLibrary *_assetsLibrary;
@interface BViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TGPickerImageManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_albumsArray;
    NSMutableArray *_imagesAssetArray;
    
    
}

@property (nonatomic,strong) TGPickerImageManager *pickerManager;

@property (nonatomic,strong) UICollectionView  *collectionView;

@end

@implementation BViewController

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//        CGFloat w = (TG_W - 10)/3;
        
        layout.itemSize = CGSizeMake(TG_W - 10 , TG_H - 50);
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(64, 5, 0, 5);
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, TG_W, TG_H - 50) collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //        [_collectionView setBackgroundColor:[[UIColor alloc]initWithRed:230 green:230 blue:230 alpha:1]];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"TGImageCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"TGImageCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self.view addSubview:_collectionView];
        
    }return _collectionView;
}

- (TGPickerImageManager *)pickerManager
{
    if (!_pickerManager) {
        _pickerManager = [TGPickerImageManager new];
//        _pickerManager.delegate = self;
    }return _pickerManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self collectionView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(click)];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.pickerManager.delegate = self;
    [self.collectionView reloadData];
}
- (void)click
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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (self.pickerManager.selecteImage.count) {
        for (int i = 0; i < self.pickerManager.selecteImage.count; i++) {
            //        TGAssetModel *asset = self.pickerManager.selectedImage[i];
            UIImageView *imageView =self.pickerManager.selecteImage[i];
            imageView.frame = CGRectMake(10, 64, TG_W - 20, TG_H - 64);
             [self.view addSubview:imageView];
        }
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
    {
         
            return  self.pickerManager.selectedImages.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TGImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TGImageCell" forIndexPath:indexPath];
    cell.asset = self.pickerManager.selectedImages[indexPath.row];
    return cell;
         
}

@end
