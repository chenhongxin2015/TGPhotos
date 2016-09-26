//
//  TGAssetModel.m
//  TestForPhotoes
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import "TGAssetModel.h"

@implementation TGAssetModel
- (id)copyWithZone:(NSZone *)zone
{
    TGAssetModel *model = [TGAssetModel new];
    model.asset = self.asset;
    model.isSelected = self.isSelected;
    model.pAsset = self.pAsset;
    return model;
}
@end
