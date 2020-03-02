//
//  JCHATSendMsgManager.h
//  Earth
//
//  Created by colr on 2020/2/29.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCHATSendMsgManager : NSObject
@property(strong, nonatomic)NSMutableDictionary *sendMsgListDic;//发送缓存的消息字典，暂时只有在是发送图片会用到
@property(strong, nonatomic)NSMutableDictionary *textDraftDic;//未发送 的草稿文字
- (void)addMessage:(JMSGMessage *)imgMsg withConversation:(JMSGConversation *)conversation;

- (void)updateConversation:(JMSGConversation *)conversation withDraft:(NSString *)draftString;
- (NSString *)draftStringWithConversation:(JMSGConversation *)conversation;
+ (JCHATSendMsgManager *)ins;


NS_ASSUME_NONNULL_END
@end

