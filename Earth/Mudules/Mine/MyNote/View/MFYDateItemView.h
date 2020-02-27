//
//  MFYDateItemView.h
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYDateItemView : MFYBaseCollectionViewCell

@property (nonatomic, strong)NSString * createDate;

- (void)itemDidSelected;

- (void)itemCancelSelected;

@end

NS_ASSUME_NONNULL_END
