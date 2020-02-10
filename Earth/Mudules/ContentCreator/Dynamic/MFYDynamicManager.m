//
//  MFYDynamicManager.m
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYDynamicManager.h"
#import "MFYQiniuSystemService.h"

@implementation MFYDynamicManager

+ (instancetype)sharedManager {
    static MFYDynamicManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MFYDynamicManager alloc] init];
    });
    return instance;
}

+ (void)getQiniuUploadTockenSuccess:(MFYSuccessAction)success failure:(MFYErrorAction)failure {
    
    [MFYQiniuSystemService getQiniuUploadTockenSuccess:^(id  _Nonnull model) {
        
    } failure:^{
        
    }];
}




@end
