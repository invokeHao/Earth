//
//  JCHATSendMsgController.h
//  Earth
//
//  Created by colr on 2020/2/29.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCHATSendMsgController : NSObject<JMessageDelegate>

@property(strong, nonatomic)JMSGConversation *msgConversation;
@property(strong, nonatomic)NSMutableArray *draftImageMessageArr;

- (void)prepareImageMessage:(JMSGMessage *)imgMsg;
- (void)removeDelegate;
- (void)addDelegateForConversation:(JMSGConversation *)conversation;

@end

NS_ASSUME_NONNULL_END
