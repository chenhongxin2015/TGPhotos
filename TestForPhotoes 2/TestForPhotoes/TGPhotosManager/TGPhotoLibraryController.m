//
//  AViewController.m
//  TestForPhotoes
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 lzq. All rights reserved.
//
#import "TGPickerImageManager.h"
#import "TGPhotoLibraryController.h"
#import "TGImageCell.h"
#define TG_W [UIScreen mainScreen].bounds.size.width
#define TG_H [UIScreen mainScreen].bounds.size.height
@interface TGPhotoLibraryController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger count;

@property (nonatomic,strong) UIButton *finishBtn;
@property (nonatomic,strong) UILabel *promptTitleLabel;
@end

@implementation TGPhotoLibraryController
- (UILabel *)promptTitleLabel
{
    if (!_promptTitleLabel) {
        _promptTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, TG_W-20, 80)];
        _promptTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_promptTitleLabel];
        _promptTitleLabel.numberOfLines = 0;
        [_promptTitleLabel setBackgroundColor:[UIColor whiteColor]];
        _promptTitleLabel.hidden = YES;
        
    }return _promptTitleLabel;
}

- (void)promptTitle
{
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        self.promptTitleLabel.hidden = NO;
        
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
        self.promptTitleLabel.text = tipTextWhenNoPhotosAuthorization;
        self.collectionView.hidden = YES;
    }else
    {
        self.promptTitleLabel.hidden = YES;
        self.collectionView.hidden = NO;
    }
    
    
}
- (UIButton *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, TG_H - 50, TG_W, 50)];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setBackgroundColor:[UIColor orangeColor]];
        [_finishBtn addTarget:self action:@selector(selecteImages) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_finishBtn];
        
    }return _finishBtn;
}
- (void)finish:(UIButton *)sender
{
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _imagesAssetArray.count;
}
- (void)setManager:(TGPickerImageManager *)manager
{
    _manager = manager;
    _selectedImages = [[NSMutableArray alloc]initWithArray:manager.selectedImages copyItems:YES];
    _imagesAssetArray = [[NSMutableArray alloc]initWithArray:manager.imagesAssetArray copyItems:YES];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TGImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TGImageCell" forIndexPath:indexPath];
    cell.asset = _imagesAssetArray[indexPath.item];
//    cell.selectedBtn.selected = 
    return cell;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        CGFloat w = (TG_W - 15)/4;
        
        layout.itemSize = CGSizeMake(w, w);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, TG_W, TG_H - 50-64) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"TGImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TGImageCell"];
        [self.view addSubview:_collectionView];
        
    }return _collectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TGImageCell *cell = (TGImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    TGAssetModel *model = _imagesAssetArray[indexPath.item];
    model.isSelected = !model.isSelected;

    
    if (model.isSelected) {
        
        if (self.count >=self.manager.maxCount) {
            NSString *message = [NSString stringWithFormat:@"最多选择%ld张图片",(long)self.manager.maxCount];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
            model.isSelected = NO;
            return;
        }
        
        
        self.count++;
        [self.selectedImages addObject:model];
        
        
    }else
    {
        self.count--;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
        for (TGAssetModel *asset in self.selectedImages) {
            if ([asset.pAsset isEqual:model.pAsset]) {
                [self.selectedImages removeObject:asset];
                break;
            }
            
        }
#else
        for (TGAssetModel *asset in self.selectedImages) {
            if ([asset.asset isEqual:model.asset]) {
                [self.selectedImages removeObject:asset];
                break;
            }
            
        }
#endif
     
       
    }
    self.title = [NSString stringWithFormat:@"已选%ld张",(long)self.count];
//    cell.asset = model;
    cell.selectedBtn.hidden = !model.isSelected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self promptTitle];//设置提示标题
    [self finishBtn];//加载确定按钮
    [self collectionView];//加载collectionView

   
    //显示选中图片张数

    [self setupNavigationItems];//设置导航
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.count = self.manager.selectedImages.count;
    
    self.title = [NSString stringWithFormat:@"已选%ld张", (unsigned long)self.count];
    _selectedImages = [[NSMutableArray alloc]initWithArray:self.manager.selectedImages copyItems:YES];
    _imagesAssetArray = [[NSMutableArray alloc]initWithArray:self.manager.imagesAssetArray copyItems:YES];
    [self.collectionView reloadData];
}
- (void)setupNavigationItems
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"x" style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
}

- (void)goToBack
{
       [self.navigationController popViewControllerAnimated:YES];
}


- (void)selecteImages
{
    
    
    self.manager.imagesAssetArray = _imagesAssetArray;
    self.manager.selectedImages = _selectedImages;
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(pushToSelectedVC)]  ) {
         [self.delegate pushToSelectedVC];
    }
   
}



- (void)dealloc
{
    NSLog(@"AVC death");
}

@end
