//
//  MFYQiNiuResponse.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYQiNiuResponse : NSObject

@property (nonatomic, strong) NSString * bucket;
@property (nonatomic, strong) NSString * endUser;
@property (nonatomic ,assign) NSInteger fsize;
@property (nonatomic, strong) NSString * qiniuHash;
@property (nonatomic, strong) NSString * mimeType;
@property (nonatomic, strong) NSString * storeId;

- (instancetype)initWithDictionary:(NSDictionary* )dic;

@end

NS_ASSUME_NONNULL_END
