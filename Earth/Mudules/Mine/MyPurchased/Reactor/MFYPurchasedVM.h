//
//  MFYPurchasedVM.h
//  Earth
//
//  Created by colr on 2020/3/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYPurchasedVM : NSObject

@property (nonatomic, strong,readonly) NSArray<MFYItem *> * dataList;

@property (nonatomic, assign, readonly) NSInteger NewDataCount;

-(void)refreshData;

-(void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
