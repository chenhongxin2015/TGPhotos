//
//  TGImageCell.h
//  TestForPhotoes
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TGAssetModel.h"
@interface TGImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)selectedBtn:(UIButton *)sender;
@property (nonatomic,strong) TGAssetModel *asset;
@end
