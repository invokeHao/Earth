//
//  MFYChatListVM.m
//  Earth
//
//  Created by colr on 2020/3/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYChatListVM.h"
#import "MFYChatService.h"

@interface MFYChatListVM ()

@property (nonatomic, strong) NSMutableArray<JMSGConversation *> * dataList;

@property (nonatomic, strong) NSArray<NSString *>* topIdList;

@property (nonatomic, assign) NSInteger NewDataCount;

@end


@implementation MFYChatListVM

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadAllConversations];
    }
    return self;
}

- (void)loadAllConversations {
    [MFYChatService getTopChatListCompletion:^(NSArray<NSString *> * _Nonnull imIdArr, NSError * _Nonnull error) {
        self.topIdList = [imIdArr copy];
        if (imIdArr.count > 0) {
            //根据置顶的聊天，重新排序聊天
            [JMSGConversation allConversations:^(id resultObject, NSError *error) {
                if (!error) {
                    self.dataList = [self sortConversation:resultObject];
                }
            }];
        }
    }];
    
    
}

#pragma mark- public method
- (void)addChatTop:(JMSGConversation *)conversation {
    JMSGUser * user = conversation.target;
    [MFYChatService postAddTopsChat:user.username Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            conversation.isTop = YES;
            [self loadAllConversations];
        }
    }];
}

- (void)deleteTheTopChat:(JMSGConversation *)conversation {
    JMSGUser * user = conversation.target;
    [MFYChatService postRemoveTopsChat:user.username Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            conversation.isTop = NO;
            [self loadAllConversations];
        }
    }];
}


#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSArray *)conversationArr {
    //1.取出置顶的会话
    NSMutableArray * conversationList = [NSMutableArray arrayWithArray:conversationArr];
    NSMutableArray * topListArr = [NSMutableArray arrayWithCapacity:0];
    if (self.topIdList.count > 0) {
        [conversationArr enumerateObjectsUsingBlock:^(JMSGConversation * conversation, NSUInteger idx, BOOL * _Nonnull stop) {
            JMSGUser * user = conversation.target;
            for (NSString * imId in self.topIdList) {
                if ([user.username isEqualToString:imId]) {
                    conversation.isTop = YES;
                    [conversationList removeObject:conversation];
                    [topListArr addObject:conversation];
                }
            }
        }];
    }
    //2.剩余的会话进行排序
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"latestMessage.timestamp" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    
    NSArray *sortedArray = [conversationList sortedArrayUsingDescriptors:sortDescriptors];
    
    NSMutableArray * resultArr = [NSMutableArray arrayWithArray:sortedArray];
    
    //3.将置顶的会话插入到最前方
    NSRange range = NSMakeRange(0, topListArr.count);
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [resultArr insertObjects:topListArr atIndexes:indexSet];
    WHLog(@"%@",resultArr);
    return resultArr;

//    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
//    return [NSMutableArray arrayWithArray:sortResultArr];
}


@end
