//
//  MFYMedia.h
//  Earth
//
//  Created by colr on 2020/1/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYMedia : NSObject

@property (nonatomic, strong) NSString * mediaId;
@property (nonatomic, assign) NSInteger mediaType;
@property (nonatomic, strong) NSString * mediaUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
