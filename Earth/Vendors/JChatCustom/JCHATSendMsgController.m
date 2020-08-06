//
//  JCHATSendMsgController.m
//  Earth
//
//  Created by colr on 2020/2/29.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "JCHATSendMsgController.h"

@implementation JCHATSendMsgController

- (id)init {
  self = [super init];
  if (self) {
    _draftImageMessageArr  = @[].mutableCopy;
  }
  return self;
}

- (void)addDelegateForConversation:(JMSGConversation *)conversation {
  [JMessage addDelegate:self withConversation:conversation];
}

- (void)removeDelegate {
  [JMessage removeDelegate:self withConversation:_msgConversation];
  
}

#pragma mark JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error {
  if (message.contentType != kJMSGContentTypeImage) {
    return;
  }
  if (![_msgConversation isMessageForThisConversation:message]) {
    return;
  }
  [_draftImageMessageArr removeObjectAtIndex:0];
  if ([_draftImageMessageArr count] > 0) {
    [self sendStart];
  }
}

- (void)prepareImageMessage:(JMSGMessage *)imgMsg {
  [_draftImageMessageArr addObject:imgMsg];
  if ([_draftImageMessageArr count] == 1) {
    [self sendStart];
  }
}

- (void)sendStart {
  [_msgConversation sendMessage: _draftImageMessageArr[0]];

}

@end
