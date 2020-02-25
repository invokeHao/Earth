//
//  MFYImageCardCell.h
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseCollectionViewCell.h"
#import "MFYArticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYImageCardCell : MFYBaseCollectionViewCell

@property (strong, nonatomic)MFYArticle * article;

- (void)mfy_stopPlay;

- (void)mfy_startPlay;


@end

NS_ASSUME_NONNULL_END
