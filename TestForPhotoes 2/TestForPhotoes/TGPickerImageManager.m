//
//  TGPickerImageManager.m
//  TestForPhotoes
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import "TGPickerImageManager.h"
#import "TGAssetModel.h"
#import "CViewController.h"
#define TG_DEBUG
static  ALAssetsLibrary *_assetsLibrary;

//#define TG_SystemVersion9 4
//(([UIDevice currentDevice].systemVersion.floatValue) > 9.0)
//#define TG_SystemVersion8 (([UIDevice currentDevice].systemVersion.floatValue) < 9.0)
@implementation TGPickerImageManager
- (CViewController *)selectedVC
{
    if (!_selectedVC) {
        _selectedVC = [CViewController new];
        _selectedVC.pickerManager = self;
    }return _selectedVC;
}
- (instancetype)init
{
    if (self = [super init]) {
        
        self.albumsArray = [NSMutableArray array];
        self.imagesAssetArray = [NSMutableArray array];
        self.selectedImages = [NSMutableArray array];
        self.maxCount = 9;
        if (!_assetsLibrary) {
            _assetsLibrary = [ALAssetsLibrary new];
            
        }
        
    }return self;
}
- (UIImagePickerController *)cameraVC
{
    if (!_cameraVC) {
        _cameraVC = [UIImagePickerController new];
        _cameraVC.delegate = self;
        _cameraVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }return _cameraVC;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    //先把图片转成NSData
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
    NSLog(@"ok");
    [self savePhoto:image viewController:picker];
//    "Use creationRequestForAssetFromImage: on PHAssetChangeRequest from the Photos framework to create a new asset instead");
    
    
    
#else
    NSLog(@"yes");
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
       
        if (!_assetsLibrary) {
            _assetsLibrary  = [[ALAssetsLibrary alloc] init];
            
        }
        [_assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                // TODO: error handling
            } else {
                [_assetsLibrary  assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if (self.selectedImages.count >= self.maxCount) {
                        
                        [picker dismissViewControllerAnimated:YES completion:^{
                            
                            if ([self.delegate respondsToSelector:@selector(warningForMaxCount)]) {
                                [self.delegate warningForMaxCount];
                            }
                            
                        }];
                        return ;
                    }
                    NSLog(@"%s,line = %d ",__FUNCTION__,__LINE__);
                    NSLog(@"当前方法：%s\n,当前行数%d\n,当前线程%@\n",__func__,__LINE__,[NSThread currentThread]);
                    
                    TGAssetModel *model = [TGAssetModel new];
                    model.asset = asset;
                    model.isSelected = YES;
                    [_imagesAssetArray insertObject:model atIndex:0];
                    //                    [_imagesAssetArray addObject:model];
                    [self.selectedImages addObject:model];
                    [picker dismissViewControllerAnimated:YES completion:^{
                        if ([self.delegate respondsToSelector:@selector(selectedCameraImage)]) {
                            [self.delegate selectedCameraImage];
                        }
                        
                        
                    }];
                    
                } failureBlock:^(NSError *error) {
                    
                }];
            }
        }];
    }

    
#endif

    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)getListPhotosFromCamera:(BOOL)isCamera
{
    
    
    
    if (_imagesAssetArray.count) {
        [self.delegate pikerImageFinishedFromCamera:isCamera];
        return;
    }
//    [_imagesAssetArray removeAllObjects];
#ifdef TG_DEBUG
    NSLog(@"当前方法：%s\n,当前行数%d\n,当前线程%@\n",__func__,__LINE__,[NSThread currentThread]);
    NSLog(@"%s,line = %d ",__FUNCTION__,__LINE__);
#endif
    NSLog(@"okd");
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
    NSLog(@"ok");
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        // 这里便是无访问权限
    }else
    {
        [[PHPhotoLibrary sharedPhotoLibrary]registerChangeObserver:self] ;
//        library 
        [self getAllAssetInPhotoAblumWithAscending:NO fromCamera:isCamera];


    }
    
#else
    NSLog(@"yes");
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        [self.delegate  pushCVCToWarning];
        //        [self pushToAVC];
        return;
    }
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    [_albumsArray removeAllObjects];

    
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            if (group.numberOfAssets > 0) {
                // 把相册储存到数组中，方便后面展示相册时使用
                [_albumsArray addObject:group];
                
                
                
            }
        } else {
            if ([_albumsArray count] > 0) {
                
                for (ALAssetsGroup * group in _albumsArray) {
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        
                        
                        if (result) {
                            
                            TGAssetModel *asset = [TGAssetModel new];
                            asset.asset = result;
                            asset.isSelected = NO;
                            [_imagesAssetArray addObject:asset];
                            //                            [self.selectedImages addObject:asset];
                        } else {
                            
                            //                            [self setupImage];
                            //                            UIImageView *imageView = [UIImageView alloc]
                            if (index == _albumsArray.count- 1) {
                                //                                [self.collectionView reloadData];
                            }
                            *stop = YES;
                            return;
                            
                            // result 为 nil，即遍历相片或视频完毕，可以展示资源列表
                        }
                        
                    }];
                }
                [self.delegate pikerImageFinishedFromCamera:isCamera];
                //                [self  pushToAVC];
                //                [self.collectionView reloadData];
                // 把所有的相册储存完毕，可以展示相册列表
            } else {
                // 没有任何有资源的相册，输出提示
            }
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Asset group not found!\n");
    }];
    
#endif
   
}


#pragma mark -- PHPhotoLibraryChangeObserver
//相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
#ifdef TG_DEBUG
    NSLog(@"当前方法：%s\n,当前行数%d\n,当前线程%@\n",__func__,__LINE__,[NSThread currentThread]);
    NSLog(@"%s,line = %d ",__FUNCTION__,__LINE__);
#endif
 
    dispatch_sync(dispatch_get_main_queue(), ^{
        // your codes
        NSLog(@"保存相册");
        
    });
    
    
}


#pragma mark - 获取相册内所有照片资源
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending fromCamera:(BOOL)isCamera
{
    
    
    
    
    
    
//    [_imagesAssetArray removeAllObjects];
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
        TGAssetModel *model = [TGAssetModel new];
        model.pAsset = asset;
        model.isSelected = NO;
        
        [_imagesAssetArray addObject:model];
        [assets addObject:asset];
#ifdef TG_DEBUG
         NSLog(@"%s,line = %d ",__FUNCTION__,__LINE__);
         NSLog(@"当前方法：%s\n,当前行数%d\n,当前线程%@\n",__func__,__LINE__,[NSThread currentThread]);
#endif
    }];
    [self.delegate pikerImageFinishedFromCamera:isCamera];
    return assets;
}


//// 点击保存调用
//- (IBAction)save:(id)sender {
//    //查看当前app授权状态
//    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//    switch (status) {
//        case PHAuthorizationStatusNotDetermined:
//        { // 未授权,弹出授权框
//            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//                // 用户选择完毕就会调用—选择允许,直接保存
//                if (status == PHAuthorizationStatusAuthorized) {
//                    [self savePhoto];
//                }
//            }];
//            选择不允许访问,就不保存
//            break;
//        }
//        case PHAuthorizationStatusAuthorized:
//        { // 授权,就直接保存
//            [self savePhoto];
//            break;
//        }
//        default:
//        {// 拒绝   告知用户去哪打开授权
//            [SVProgressHUD showInfoWithStatus:@"打开设置 -> 查找百思不得姐 -> 打开照片开关 -> 允许当前app访问系统相册就可以保存图片"];
//            break;
//        }
//    }
//}

// 添加图片到自己相册
- (void)savePhoto:(UIImage *)image viewController:(UIViewController *)pikerVC
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.创建图片请求类(创建系统相册中新的图片)PHAssetCreationRequest
        // 把图片放在系统相册
        PHAssetCreationRequest *assetCreationRequest = [PHAssetCreationRequest creationRequestForAssetFromImage:image];
        
        // 2.创建相册请求类(修改相册)PHAssetCollectionChangeRequest
        PHAssetCollectionChangeRequest *assetCollectionChangeRequest = nil;
        
        // 获取之前相册
        PHAssetCollection *assetCollection = [self fetchAssetCollection:@"上传照片"];
        
        // 判断是否已有相册
        if (assetCollection) {
            // 如果存在已有同名相册   指定这个相册,创建相册请求修改类
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else {  //不存在,创建新的相册
            assetCollectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"上传照片"];
        }
        // 3.把图片添加到相册中
        // NSFastEnumeration:以后只要看到这个,就可以表示数组
        //assetCreationRequest.placeholderForCreatedAsset 图片请求类占位符(相当于一个内存地址)
        //因为creationRequestForAssetFromImage方法是异步实行的,在这里不能保证 assetCreationRequest有值
        
        [assetCollectionChangeRequest addAssets:@[assetCreationRequest.placeholderForCreatedAsset]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
         NSLog(@"当前方法：%s\n,当前行数%d\n,当前线程%@\n",__func__,__LINE__,[NSThread currentThread]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [pikerVC dismissViewControllerAnimated:YES completion:^{
                
                [self addPhotoFromCamera];
            }];
        });
       
        if (success) {
             NSLog(@"当前方法：%s\n,当前行数%d\n,当前线程%@\n",__func__,__LINE__,[NSThread currentThread]);

        } else {
             NSLog(@"当前方法：%s\n,当前行数%d\n,当前线程%@\n",__func__,__LINE__,[NSThread currentThread]);
        }
    }];
}
//
// 指定相册名称,获取相册
- (PHAssetCollection *)fetchAssetCollection:(NSString *)title
{
    // 获取相簿中所有自定义相册
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //遍历相册,判断是否存在同名的相册
    for (PHAssetCollection *assetCollection in result) {
        if ([title isEqualToString:assetCollection.localizedTitle]) {
            // 存在,就返回这个相册
            return assetCollection;
        }
    }
    return nil;
}



- (void)addPhotoFromCamera
{
    // 列出所有相册智能相册
    //    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //
    //    // 列出所有用户创建的相册
    //    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    
    //    // 在资源的集合中获取第一个集合，并获取其中的图片
    //    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    PHAsset *asset = [assetsFetchResults lastObject];
    
    TGAssetModel *model = [TGAssetModel new];
    model.pAsset = asset;
    model.isSelected = YES;
    
    [self.selectedImages addObject:model];
    //    [self.imagesAssetArray addObject:model];
    [self.imagesAssetArray insertObject:model atIndex:0];
    
    if ([self.delegate respondsToSelector:@selector(selectedCameraImage)]) {
        [self.delegate selectedCameraImage];
    }
    
    
}




@end
