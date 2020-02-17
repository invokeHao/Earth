//
//  MFYAudioListVM.h
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYCoreflowService.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYAudioListVM : NSObject

@property (nonatomic, strong,readonly) NSMutableArray<MFYArticle *> * dataList;

@property (nonatomic, assign, readonly) NSInteger NewDataCount;

- (instancetype)initWithTopicId:(NSString *)topicId;

-(void)refreshData;

@end

NS_ASSUME_NONNULL_END
