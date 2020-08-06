//
//  MFYHTTPCacheService.m
//  Earth
//
//  Created by colr on 2020/2/14.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYHTTPCacheService.h"

@implementation MFYHTTPCacheService

+ (void)setupHTTPCache {
    [KTVHTTPCache logSetConsoleLogEnable:NO];
    NSString *logFilePath = [KTVHTTPCache logRecordLogFilePath];
    NSLog(@"===> logFilePath : %@", logFilePath);
    NSError * error;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
        NSLog(@"Proxy Start Failure, %@", error);
    } else {
        NSLog(@"Proxy Start Success");
    }
}

+ (NSURL *)proxyURLWithOriginalUrl:(NSString *)URLString {
    return [KTVHTTPCache proxyURLWithOriginalURL:[NSURL URLWithString:URLString]];
}

+ (NSString *)proxyURLStringWithOriginalURLString:(NSString *)URLString {
    return [KTVHTTPCache proxyURLStringWithOriginalURLString:URLString];
}


@end
