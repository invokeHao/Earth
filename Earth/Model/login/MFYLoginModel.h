//
//  MFYLoginModel.h
//  Earth
//
//  Created by colr on 2020/1/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYLoginModel : NSObject

@property (nonatomic, strong) NSString * expireDate;
@property (nonatomic, assign) BOOL profileUpdated;
@property (nonatomic, strong) NSString * token;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
