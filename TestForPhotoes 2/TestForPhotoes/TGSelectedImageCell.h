//
//  TGSelectedImageCell.h
//  TestForPhotoes
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 lzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGAssetModel.h"
@interface TGSelectedImageCell : UICollectionViewCell
@property (nonatomic,strong) TGAssetModel *asset;
@property (weak, nonatomic) IBOutlet UILabel *firstImage;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)selectedBtn:(UIButton *)sender;

@end
