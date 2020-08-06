//
//  MFYPublishItemModel.m
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPublishItemModel.h"

@implementation MFYPublishItemModel

-(NSDictionary *)toDictionary {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.fileDesc.length > 0) {
        [dic setValue:self.fileDesc forKey:@"fileDesc"];
    }
    if (self.fileId.length > 0) {
        [dic setValue:self.fileId forKey:@"fileId"];
    }
    dic[@"fileType"] = @(self.fileType);
    dic[@"priceAmount"] = @(self.priceAmount);
    return dic;
    
}

+(NSInteger)qiNiuMimeTypeChangeMfy:(NSString *)mimeType {
    if ([mimeType containsString:@"image"]) {
        return 1;
    }else if([mimeType containsString:@"video"]) {
        return 3;
    }else if([mimeType containsString:@"audio"]) {
        return 2;
    }else {
        return 1;
    }
}

@end
