//
//  MFYTagCellCollectionViewCell.h
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYTagCell : MFYBaseCollectionViewCell

@property (strong, nonatomic) UILabel *tagLabel;

@property (strong, nonatomic) UIColor * themeColor;

@property (strong, nonatomic) UIImageView * addImageV;

@property (strong, nonatomic) NSString * titleStr;

- (void)setTitleStr:(NSString * _Nonnull)titleStr;

@end

NS_ASSUME_NONNULL_END
