//
//  CViewController.m
//  TestForPhotoes
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import "TGSelecedController.h"
#import "TGSelectedImageCell.h"
#import "TGPhotoLibraryController.h"
#import "TGPickerImageManager.h"
#define TG_RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define TG_W [UIScreen mainScreen].bounds.size.width
#define TG_H [UIScreen mainScreen].bounds.size.height
@interface TGSelecedController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TGPickerImageManagerDelegate>
{


}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *sureBtn;
@end

@implementation TGSelecedController
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, TG_H - 50, TG_W, 50)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[UIColor orangeColor]];
        [_sureBtn addTarget:self action:@selector(sureImage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sureBtn];
    }return  _sureBtn;
}


//#warning 实际逻辑
- (void)sureImage
{
    self.pickerManager.selecteImage = [NSMutableArray array];
    for (TGAssetModel *model in self.pickerManager.selectedImages) {
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
        
        typeof(self) weakSelf = self;
        [[PHCachingImageManager defaultManager] requestImageForAsset:model.pAsset targetSize:CGSizeMake(TG_W * 3, TG_H * 3) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            //解析出来的图片
            
          
            UIImageView *imageView = [UIImageView new];
            imageView.image = image;
             [self.pickerManager.selecteImage addObject: imageView];
            
            if(self.pickerManager.selecteImage.count == self.pickerManager.selectedImages.count)
            {
                //     self.pickerManager.selecteImage = [arr copy];
                [self.navigationController popViewControllerAnimated:YES];
            }
        
        }];
       
       
#else
      [arr addObject: [UIImage imageWithCGImage:.asset.thumbnail];
#endif

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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.pickerManager.selectedImages.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == self.pickerManager.selectedImages.count) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        UIButton *btn = [cell viewWithTag:10];
        if (!btn) {
            btn = [[UIButton alloc]initWithFrame:cell.bounds];
            btn.tag = 10;
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitle:@"+" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:35];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            btn.titleLabel.textColor = [UIColor grayColor];
            [btn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            
        }
        return cell;
    }
    
    TGSelectedImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TGSelectedImageCell" forIndexPath:indexPath];
//    cell.selectedBtn.hidden = YES;
    if (indexPath.item == 0) {
        cell.firstImage.hidden = NO;
        
    }else
    {
        cell.firstImage.hidden = YES;
    }
    cell.asset = self.pickerManager.selectedImages[indexPath.item];
    
    return cell;
}
- (void)addImage:(UIButton *)sender
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getImageFromCamera];
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getFromLibrary];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
   
    
}


- (void)getFromLibrary
{
    TGPhotoLibraryController *avc = [TGPhotoLibraryController new];
    avc.manager = self.pickerManager;

    [self.navigationController pushViewController:avc animated:YES];

}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        CGFloat w = (TG_W - 10)/3;
        
        layout.itemSize = CGSizeMake(w, w);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, TG_W, TG_H - 50) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        [_collectionView setBackgroundColor:[[UIColor alloc]initWithRed:230 green:230 blue:230 alpha:1]];
        _collectionView.backgroundColor = TG_RGB(245, 245, 250);
        [_collectionView registerNib:[UINib nibWithNibName:@"TGSelectedImageCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"TGSelectedImageCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self.view addSubview:_collectionView];
        
    }return _collectionView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    [self.collectionView reloadData];
}
- (void)goToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionView];
    [self sureBtn];
    self.pickerManager.delegate = self;
    self.title = @"图片";
    self.view.backgroundColor = TG_RGB(230, 230, 230);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSelectedImage:) name:@"TGDeleteSelectedImage" object:nil];
    
    
    // Do any additional setup after loading the view.
}

- (void)warningForMaxCount
{
    
  
        NSString *message = [NSString stringWithFormat:@"最多选择%ld张图片,先删除不需要的图片",(long)self.pickerManager.maxCount];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];

}

- (void)deleteSelectedImage:(NSNotification *)noti
{
    
    TGAssetModel *model = noti.object;
//    for (TGAssetModel *asset in self.pickerManager.selectedImages) {
//        
//    }
    NSInteger index = [self.pickerManager.selectedImages indexOfObject:model];
    
    [self.pickerManager.selectedImages removeObject:noti.object];
//    self.pickerManager.imagesAssetArray
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
    for (TGAssetModel *asset in self.pickerManager.imagesAssetArray) {
        if ([asset.pAsset isEqual:model.pAsset]) {
            asset.isSelected = NO;
            break;
        }
    }
#else
    for (TGAssetModel *asset in self.pickerManager.imagesAssetArray) {
        if ([asset.asset isEqual:model.asset]) {
            asset.isSelected = NO;
            break;
        }
    }
#endif
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0 ]]];
    if (index == 0&&self.pickerManager.selectedImages.count) {
        
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0 ]]];
       
    }
    


    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-- 拍照
- (void)getImageFromCamera
{
    if (self.pickerManager.selectedImages.count >=self.pickerManager.maxCount) {
        
        [self warningForMaxCount];
        return;
        
    }
    [self presentViewController:self.pickerManager.cameraVC animated:YES completion:nil];
}



- (void)selectedCameraImage
{
    
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.pickerManager.selectedImages.count - 1 inSection:0]]];

}


- (void)dealloc
{
    NSLog(@"CVC death");
}
@end
