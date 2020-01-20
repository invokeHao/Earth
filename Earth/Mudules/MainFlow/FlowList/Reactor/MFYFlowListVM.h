//
//  MFYFlowListVM.h
//  Earth
//
//  Created by colr on 2019/12/27.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYCoreflowService.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYFlowListVM : NSObject

@property (nonatomic, strong,readonly) NSMutableArray<MFYArticle *> * dataList;

@property (nonatomic, assign, readonly) NSInteger NewDataCount;


@end

NS_ASSUME_NONNULL_END
