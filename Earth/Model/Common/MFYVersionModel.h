//
//  MFYVersionModel.h
//  Earth
//
//  Created by colr on 2020/4/13.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYVersionModel : NSObject

@property (nonatomic, assign) BOOL required;
@property (nonatomic, assign) BOOL update;
@property (nonatomic, strong) NSString * updateDesc;
@property (nonatomic, strong) NSString * updateUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
