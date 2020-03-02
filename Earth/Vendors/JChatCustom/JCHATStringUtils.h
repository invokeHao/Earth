//
//  JCHATStringUtils.h
//  Earth
//
//  Created by colr on 2020/2/29.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCHATStringUtils : NSObject

+ (NSString*)errorAlert:(NSError *)error;

+ (NSString *)dictionary2String:(NSDictionary *)dictionary;

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval;

+ (NSString *)getFriendlyDateString:(NSTimeInterval)timeInterval
                    forConversation:(BOOL)isShort;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

+ (NSString *)conversationIdWithConversation:(JMSGConversation *)conversation;

+ (CGSize)stringSizeWithWidthString:(NSString *)string withWidthLimit:(CGFloat)width withFont:(UIFont *)font;


@end

NS_ASSUME_NONNULL_END
