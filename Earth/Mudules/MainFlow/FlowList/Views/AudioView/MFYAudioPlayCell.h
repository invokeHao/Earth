//
//  MFYAudioPlayCell.h
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseCollectionViewCell.h"
#import "MFYArticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYAudioPlayCell : MFYBaseCollectionViewCell

@property (nonatomic, strong) MFYArticle * model;

@property (copy, nonatomic)void(^longPressBlock)(void);

- (void)setupCardView;


@end

NS_ASSUME_NONNULL_END
