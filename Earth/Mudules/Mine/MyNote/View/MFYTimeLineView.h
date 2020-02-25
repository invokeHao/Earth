//
//  MFYTimeLineView.h
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MFYArticle;
@interface MFYTimeLineView : UICollectionView

@property (nonatomic, copy)NSArray<MFYArticle*> * articleArr;

@end

NS_ASSUME_NONNULL_END
