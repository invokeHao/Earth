//
//  MFYCoreflowTag.h
//  Earth
//
//  Created by colr on 2020/2/12.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYCoreflowTag : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * value;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
