//
//  JCHATFileManager.h
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    FILE_IMAGE=1,
    FILE_AUDIO,
    FILE_VIDIO,
    FILE_UNKNOWN
} FILE_TYPE;

@interface JCHATFileManager : NSObject
 + (BOOL)initWithFilePath;
// +(NSString*)saveChatBackgroundImageWithConversationID:(NSString*)conID andData:(NSData *)imgData;
                                
 + (NSString *)generatePathWithConversationID:(NSString *)conID withMessageType:(FILE_TYPE)type withFileType:(NSString *)fileType;
 + (BOOL)saveToPath:(NSString *)path withData:(NSData *)data;

 + (NSString*)saveImageWithConversationID:(NSString*)conID andData:(NSData *)imgData;
 + (NSString *)copyFile:(NSString *)sourepath withType:(FILE_TYPE)type From:(NSString *)sourceID to:(NSString *)destinationID;
 + (BOOL)deleteFile:(NSString *)path;
 + (NSString*)saveGlobalBackGround:(NSData *)imgData;

//清空单个会话相关文件
 + (void)deletAllFilesByConversationID:(NSString *)conversationID;
//清空所有会话相关文件
 + (void)deletAllFiles;
 + (void)deletAllFilesAtDocument;
@end
NS_ASSUME_NONNULL_END
