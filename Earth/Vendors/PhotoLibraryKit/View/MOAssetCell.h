//
//  MOAssetCell.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOAssetModel.h"
@class MOAssetCell;

@protocol MOAssetCellDelegate <NSObject>

- (void)cellDidClickSelectBtn:(UIButton *)button selectedModel:(MOAssetModel *)model;

@end

@interface MOAssetCell : UICollectionViewCell

@property (nonatomic, weak) id <MOAssetCellDelegate> delegate;

- (void)loadData:(MOAssetModel *)assetModel;

@end
