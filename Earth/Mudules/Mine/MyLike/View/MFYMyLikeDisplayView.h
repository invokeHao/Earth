//
//  MFYMyLikeDisplayView.h
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYBaseCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^scrollItemBlock)(NSInteger index);

@class MFYArticle;
@interface MFYMyLikeDisplayView : UIView

-(void)reloadDataWithArray:(NSArray<MFYArticle *> *)arr;

- (void)playTheMedia;

- (void)stopTheMedia;

//配合timeline做滚动
- (void)mfy_scrollToItem:(NSInteger)item;

@property (nonatomic, strong)scrollItemBlock scrollBlock;

@property (nonatomic, strong) MFYBaseCollectionView * mainCollection;

@end

NS_ASSUME_NONNULL_END
