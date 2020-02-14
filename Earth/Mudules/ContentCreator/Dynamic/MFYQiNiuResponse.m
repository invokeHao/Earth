//
//  MFYQiNiuResponse.m
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYQiNiuResponse.h"

@implementation MFYQiNiuResponse

- (instancetype)initWithDictionary:(NSDictionary* )dic {
    self = [super init];
    if (self && dic) {
        self.bucket = dic[@"bucket"];
        self.endUser = dic[@"endUser"];
        self.fsize = [dic[@"fsize"] integerValue];
        self.qiniuHash = dic[@"hash"];
        self.mimeType = dic[@"mimeType"];
        self.storeId = dic[@"storeId"];
    }
    return self;
}

@end
