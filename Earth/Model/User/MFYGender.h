//
//  MFYGender.h
//  Earth
//
//  Created by colr on 2020/1/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYGender : NSObject

@property (nonatomic, assign) BOOL checked;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger no;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;


@end

NS_ASSUME_NONNULL_END
