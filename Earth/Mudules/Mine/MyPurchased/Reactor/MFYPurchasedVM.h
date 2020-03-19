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

@property (nonatomic, strong,readonly) NSMutableArray<MFYArticle *> * dataList;

@property (nonatomic, assign, readonly) NSInteger NewDataCount;

-(void)refreshData;

@end

NS_ASSUME_NONNULL_END
