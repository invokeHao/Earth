//
//  JCHATSendMsgManager.m
//  Earth
//
//  Created by colr on 2020/2/29.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "JCHATSendMsgManager.h"
#import "JCHATSendMsgController.h"
#import "JCHATStringUtils.h"

@implementation JCHATSendMsgManager

+ (JCHATSendMsgManager *)ins {
  static JCHATSendMsgManager *sendMsgManage = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sendMsgManage = [[JCHATSendMsgManager alloc] init];
  });
  return sendMsgManage;
}

- (id)init {
  self = [super init];
  if (self) {
    _sendMsgListDic  = @{}.mutableCopy;
    _textDraftDic = @{}.mutableCopy;
  }
  return self;
}

- (void)addMessage:(JMSGMessage *)imgMsg withConversation:(JMSGConversation *)conversation {
  NSString *key = nil;
  if (conversation.conversationType == kJMSGConversationTypeSingle) {
    key = ((JMSGUser *)conversation.target).username;
  } else {
    key = ((JMSGGroup *)conversation.target).gid;
  }
  
  if (_sendMsgListDic[key] == nil) {
    JCHATSendMsgController *sendMsgCtl = [[JCHATSendMsgController alloc] init];
    sendMsgCtl.msgConversation = conversation;
    [sendMsgCtl addDelegateForConversation:conversation];
    [sendMsgCtl prepareImageMessage:imgMsg];
    _sendMsgListDic[key] = sendMsgCtl;
  } else {
    JCHATSendMsgController *sendMsgCtl = _sendMsgListDic[key];
    [sendMsgCtl prepareImageMessage:imgMsg];
  }
}

- (void)updateConversation:(JMSGConversation *)conversation withDraft:(NSString *)draftString {
  NSString *key = nil;
  key = [JCHATStringUtils conversationIdWithConversation:conversation];
  _textDraftDic[key] = draftString;
}

- (NSString *)draftStringWithConversation:(JMSGConversation *)conversation {
  NSString *key = nil;
  key = [JCHATStringUtils conversationIdWithConversation:conversation];
  return _textDraftDic[key] ? _textDraftDic[key] : @"";
}

+ (void)sendMessage:(NSString *)messageStr withConversation:(JMSGConversation *)conversation {
    
    [[JCHATSendMsgManager ins] updateConversation:conversation withDraft:@""];
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:messageStr];
    JMSGMessage * message = [conversation createMessageWithContent:textContent];
    [conversation sendMessage:message];
}

+ (void)sendMessageWithVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration withConversation:(JMSGConversation *)conversation {
    if ([voiceDuration integerValue]<0.5 || [voiceDuration integerValue]>60) {
      if ([voiceDuration integerValue]<0.5) {
          [WHHud showString:@"录音时长小于 0.5s"];
      } else {
          [WHHud showString:@"录音时长大于 60s"];
      }
      return;
    }
    
    JMSGMessage *voiceMessage = nil;
    JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath]
                                                                   voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
    
    voiceMessage = [conversation createMessageWithContent:voiceContent];
    [conversation sendMessage:voiceMessage];
    [JCHATFileManager deleteFile:voicePath];
}

@end
