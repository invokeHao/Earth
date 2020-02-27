//
//  UIScrollView+RefreshAble.h
//  Earth
//
//  Created by colr on 2020/2/25.
//  Copyright © 2020 fuYin. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WHRefreshType) {
    WHRefreshTypeNone = 0,
    WHRefreshTypeHeader = 1,
    WHRefreshTypeFooter = 2,
    WHRefreshTypeAll = 3
};

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (RefreshAble)

@property (nonatomic, strong) RACSubject *onRefreshSubject;

@property (nonatomic, strong, readonly) MJRefreshNormalHeader *headerRefresher;
@property (nonatomic, strong, readonly) MJRefreshBackGifFooter *footerRefresher;
@property (nonatomic, assign) WHRefreshType refreshType;


/**
 打开刷新行为

 @param refreshType 需要刷新的类型
 */
- (void)openRefreshWithRefreshType:(WHRefreshType)refreshType;

/**
 停止刷新
 
 @param count 当前数据的数量
 */
- (void)stopRefreshWithCurrentDataCount:(NSInteger)count;

- (void)stopRefresh;

- (void)onNoMoreData;

- (void)resetNoMoreData;

/**
 开始下拉重新加载
 */
- (void)beginHeaderRefreshing;

@end

NS_ASSUME_NONNULL_END
