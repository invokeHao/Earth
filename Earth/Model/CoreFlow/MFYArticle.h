//
//  MFYArticle.h
//  Earth
//
//  Created by colr on 2020/1/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFYMedia.h"
#import "MFYProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYArticle : NSObject

@property (nonatomic, strong) NSString * articleId;
@property (nonatomic, strong) NSString * bodyText;
@property (nonatomic, strong) NSString * createDate;
@property (nonatomic, strong) NSArray * embeddedArticles;
@property (nonatomic, assign) NSInteger formatType;
@property (nonatomic, assign) NSInteger functionType;
@property (nonatomic, strong) MFYMedia * media;
@property (nonatomic, assign) NSInteger postType;
@property (nonatomic, assign) NSInteger priceAmount;
@property (nonatomic, strong) MFYProfile * profile;
@property (nonatomic, strong) NSString * subtitle;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
