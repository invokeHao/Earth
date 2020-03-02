//
//  JCHATMessageContentView.h
//  Earth
//
//  Created by colr on 2020/2/29.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatImageBubble.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCHATMessageContentView : UIImageView

@property(assign, nonatomic)BOOL isReceivedSide;

@property(strong, nonatomic)UILabel *textContent;
@property(strong, nonatomic)UIImageView *voiceConent;
@property(strong, nonatomic)JMSGMessage *message;
- (void)setMessageContentWith:(JMSGMessage *)message;

- (void)setMessageContentWith:(JMSGMessage *)message handler:(void(^)(NSUInteger messageMediaDataLength))block;

@end

NS_ASSUME_NONNULL_END
