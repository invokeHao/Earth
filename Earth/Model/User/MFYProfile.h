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

@property (nonatomic, assign) BOOL admin;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL allowSearch;
@property (nonatomic, assign) NSInteger balance;
@property (nonatomic, assign) BOOL banned;
@property (nonatomic, assign) NSInteger createDate;
@property (nonatomic, strong) MFYGender * gender;
@property (nonatomic, strong) NSString * headIconId;
@property (nonatomic, strong) NSString * headIconUrl;
@property (nonatomic, strong) NSString * imId;
@property (nonatomic, strong) NSString * imPwd;
@property (nonatomic, assign) NSInteger inRelationDestChatAmount;
@property (nonatomic, assign) NSInteger inRelationSrcChatAmount;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, assign) BOOL onTop;
@property (nonatomic, assign) BOOL online;
@property (nonatomic, strong) NSArray * profileDomainItems;
@property (nonatomic, assign) BOOL profileUpdated;
@property (nonatomic, assign) BOOL superAdmin;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, assign) BOOL withdrawAlipayEnable;
@property (nonatomic, assign) BOOL withdrawWeixinEnable;
@property (nonatomic, strong) NSString * withdrawWeixinId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end
NS_ASSUME_NONNULL_END
