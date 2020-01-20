//
//  MFYProfile.h
//  Earth
//
//  Created by colr on 2020/1/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYGender.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYProfile : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString * createDate;
@property (nonatomic, strong) MFYGender * gender;
@property (nonatomic, strong) NSString * headIconId;
@property (nonatomic, strong) NSString * headIconUrl;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * profileDesc;
@property (nonatomic, strong) NSArray * profileDomainItems;
@property (nonatomic, assign) BOOL profileUpdated;
@property (nonatomic, strong) NSString * userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
