//
//  MFYMyLikeVM.h
//  Earth
//
//  Created by colr on 2020/2/22.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYArticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYMyLikeVM : NSObject

@property (nonatomic, strong,readonly) NSArray<MFYArticle *> * dataList;

@property (nonatomic, assign, readonly) NSInteger NewDataCount;

-(void)refreshData;

- (void)loadMoreData;

@end

NS_ASSUME_NONNULL_END
