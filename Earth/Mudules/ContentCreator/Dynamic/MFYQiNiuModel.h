//
//  MFYQiNiuModel.h
//  Earth
//
//  Created by colr on 2020/2/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYQiNiuModel : NSObject

@property (nonatomic, copy) NSString *uploadUrl;
@property (nonatomic, copy) NSString *uploadToken;
@property (nonatomic, copy) NSString *expireDate;
@property (nonatomic, assign) uint64_t fileLimit;
@property (nonatomic, copy) NSString *viewUrlPrefix;

@end

NS_ASSUME_NONNULL_END
