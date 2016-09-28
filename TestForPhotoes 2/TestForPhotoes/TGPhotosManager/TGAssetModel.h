//
//  TGAssetModel.h
//  TestForPhotoes
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
@interface TGAssetModel : NSObject<NSCopying>
@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic,strong) PHAsset *pAsset;
@property (nonatomic,assign) BOOL isSelected;
@end
