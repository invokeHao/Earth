//
//  MFYChatListVM.h
//  Earth
//
//  Created by colr on 2020/3/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JMSGConversation;
@interface MFYChatListVM : NSObject

@property (nonatomic, strong,readonly) NSMutableArray<JMSGConversation *> * dataList;

@property (nonatomic, assign, readonly) NSInteger NewDataCount;

- (void)addChatTop:(JMSGConversation *)conversation;

- (void)deleteTheTopChat:(JMSGConversation *)conversation;

@end

NS_ASSUME_NONNULL_END
