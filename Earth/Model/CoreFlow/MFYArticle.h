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
#import "MFYItem.h"

typedef NS_ENUM(NSUInteger, MFYArticleType) {
    MFYArticleTypeImage = 1,
    MFYArticleTypeAudio,
    MFYArticleTypeVideo,
};

NS_ASSUME_NONNULL_BEGIN

@interface MFYArticle : NSObject

@property (nonatomic, strong) NSString * articleId;
@property (nonatomic, strong) NSString * bodyText;
@property (nonatomic, assign) NSInteger commentTimes;
@property (nonatomic, strong) NSString * createDate;
@property (nonatomic, strong) NSArray<MFYItem *> * embeddedArticles;
@property (nonatomic, assign) NSInteger formatType;
@property (nonatomic, assign) NSInteger functionType;
@property (nonatomic, assign) NSInteger likeTimes;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, strong) MFYMedia * media;
@property (nonatomic, assign) NSInteger postType;
@property (nonatomic, assign) NSInteger priceAmount;
@property (nonatomic, strong) MFYProfile * profile;
@property (nonatomic, assign) BOOL purchased;
@property (nonatomic, assign) BOOL complained;
@property (nonatomic, strong) NSString * subtitle;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) BOOL unliked;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

-(MFYArticleType)MFYmediaType;

@end

NS_ASSUME_NONNULL_END
