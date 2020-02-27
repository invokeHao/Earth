//
//  MFYTimeLineView.h
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selecteItemBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@class MFYArticle;
@interface MFYTimeLineView : UICollectionView

@property (nonatomic, copy)NSArray<MFYArticle*> * articleArr;

@property (nonatomic, strong)selecteItemBlock itemBlock;

- (void)mfy_didScrollToItem:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
