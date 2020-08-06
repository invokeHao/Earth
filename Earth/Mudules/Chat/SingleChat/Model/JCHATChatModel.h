//
//  JCHATChatModel.h
//  Earth
//
//  Created by colr on 2020/2/29.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCHATChatModel : NSObject

@property (nonatomic, strong) JMSGMessage * message;

@property (nonatomic, strong) NSNumber *messageTime;
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, assign) float contentHeight;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSString *timeId;
@property (nonatomic, assign) BOOL isTime;

@property (nonatomic, assign) BOOL isDefaultAvatar;
@property (nonatomic, assign) NSUInteger avatarDataLength;
@property (nonatomic, assign) NSUInteger messageMediaDataLength;

@property (nonatomic, assign) BOOL isErrorMessage;
@property (nonatomic, strong) NSError *messageError;
- (float)getTextHeight;
- (void)setupImageSize;

- (void)setChatModelWith:(JMSGMessage *)message conversationType:(JMSGConversation *)conversation;
- (void)setErrorMessageChatModelWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
