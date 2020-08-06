//
//  MFYTagDisplayView.h
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYTagDisplayView : UICollectionView

@property (nonatomic, copy) void (^shouldUpdateHeight)(CGFloat height);

@property (nonatomic, copy) void (^addTagBlock)(void);

@property (nonatomic, copy) void (^deleteTagBlock)(NSString * tagStr);

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) UIColor * tagColor;


@end

NS_ASSUME_NONNULL_END
