//
//  MFYPublishModel.m
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPublishModel.h"

@implementation MFYPublishModel

- (BOOL)unVerify {
    if (self.bigitem.fileId.length < 1 && self.smallTopItem.fileId.length < 1 && self.smallBottomItem.fileId.length < 1) {
        return YES;
    }else {
        return NO;
    }
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary * publishDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.desc != nil) {
        publishDic[@"desc"] = self.desc;
    }
    if (self.topicId != nil) {
        publishDic[@"topicId"] = self.topicId;
    }
    if (self.title) {
        publishDic[@"title"] = self.title;
    }
    NSMutableArray * dictionaryElements = [NSMutableArray array];
    if (self.bigitem != nil) {
        [dictionaryElements addObject:[self.bigitem toDictionary]];
    }
    if (self.smallTopItem != nil) {
        [dictionaryElements addObject:[self.smallTopItem toDictionary]];
    }
    if (self.smallBottomItem != nil) {
        [dictionaryElements addObject:[self.smallBottomItem toDictionary]];
    }
    publishDic[@"extraMedias"] = dictionaryElements;
    return publishDic;
}

@end
