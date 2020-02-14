//
//  MFYHTTPCacheService.h
//  Earth
//
//  Created by colr on 2020/2/14.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KTVHTTPCache/KTVHTTPCache.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYHTTPCacheService : NSObject

+ (void)setupHTTPCache;

+ (NSURL *)proxyURLWithOriginalUrl:(NSString *)URLString;

+ (NSString *)proxyURLStringWithOriginalURLString:(NSString *)URLString;


@end

NS_ASSUME_NONNULL_END
