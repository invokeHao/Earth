//
//  MFYChatListVM.h
//  Earth
//
//  Created by colr on 2020/3/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYProfile.h"

typedef NS_ENUM(NSUInteger, MFYChatListType) {
    MFYChatListFriendsType,
    MFYChatListSearchType,
    MFYChatListMayKnowType,
};

NS_ASSUME_NONNULL_BEGIN

@class JMSGConversation;
@interface MFYChatListVM : NSObject

@property (nonatomic, strong,readonly) NSMutableArray<JMSGConversation *> * dataList;

@property (nonatomic, strong,readonly) NSMutableArray<MFYProfile*> * userList;

@property (nonatomic, assign, readonly) NSInteger NewDataCount;

- (instancetype)initWithType:(MFYChatListType)listType;

//置顶相关
- (void)addChatTop:(JMSGConversation *)conversation;

- (void)deleteTheTopChat:(JMSGConversation *)conversation;

//搜索相关
- (void)searchTheFriendWithKeyWord:(NSString *)keyword;



@end

NS_ASSUME_NONNULL_END
