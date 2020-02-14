//
//  MFYArticle.m
//  Earth
//
//  Created by colr on 2020/1/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYArticle.h"

NSString *const kMFYArticleArticleId = @"articleId";
NSString *const kMFYArticleBodyText = @"bodyText";
NSString *const kMFYArticleCreateDate = @"createDate";
NSString *const kMFYArticleEmbeddedArticles = @"embeddedArticles";
NSString *const kMFYArticleFormatType = @"formatType";
NSString *const kMFYArticleFunctionType = @"functionType";
NSString *const kMFYArticleMedia = @"media";
NSString *const kMFYArticlePostType = @"postType";
NSString *const kMFYArticlePriceAmount = @"priceAmount";
NSString *const kMFYArticleProfile = @"profile";
NSString *const kMFYArticleSubtitle = @"subtitle";
NSString *const kMFYArticleTitle = @"title";


@implementation MFYArticle

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYArticleArticleId] isKindOfClass:[NSNull class]]){
        self.articleId = dictionary[kMFYArticleArticleId];
    }
    if(![dictionary[kMFYArticleBodyText] isKindOfClass:[NSNull class]]){
        self.bodyText = dictionary[kMFYArticleBodyText];
    }
    if(![dictionary[kMFYArticleCreateDate] isKindOfClass:[NSNull class]]){
        self.createDate = dictionary[kMFYArticleCreateDate];
    }
    
    if(dictionary[kMFYArticleEmbeddedArticles] != nil && [dictionary[kMFYArticleEmbeddedArticles] isKindOfClass:[NSArray class]]){
        NSArray * EmbeddedArticlesDictionaries = dictionary[kMFYArticleEmbeddedArticles];
        NSMutableArray * EmbeddedArticlesItems = [NSMutableArray array];
        for(NSDictionary * EmbeddedArticlesDictionary in EmbeddedArticlesDictionaries){
            MFYItem * EmbeddedArticlesItem = [[MFYItem alloc] initWithDictionary:EmbeddedArticlesDictionary];
            [EmbeddedArticlesItems addObject:EmbeddedArticlesItem];
        }
        self.embeddedArticles = EmbeddedArticlesItems;
    }

    if(![dictionary[kMFYArticleEmbeddedArticles] isKindOfClass:[NSNull class]]){
        self.embeddedArticles = dictionary[kMFYArticleEmbeddedArticles];
        
    }
    if(![dictionary[kMFYArticleFormatType] isKindOfClass:[NSNull class]]){
        self.formatType = [dictionary[kMFYArticleFormatType] integerValue];
    }

    if(![dictionary[kMFYArticleFunctionType] isKindOfClass:[NSNull class]]){
        self.functionType = [dictionary[kMFYArticleFunctionType] integerValue];
    }

    if(![dictionary[kMFYArticleMedia] isKindOfClass:[NSNull class]]){
        self.media = [[MFYMedia alloc] initWithDictionary:dictionary[kMFYArticleMedia]];
    }

    if(![dictionary[kMFYArticlePostType] isKindOfClass:[NSNull class]]){
        self.postType = [dictionary[kMFYArticlePostType] integerValue];
    }

    if(![dictionary[kMFYArticlePriceAmount] isKindOfClass:[NSNull class]]){
        self.priceAmount = [dictionary[kMFYArticlePriceAmount] floatValue];
    }

    if(![dictionary[kMFYArticleProfile] isKindOfClass:[NSNull class]]){
        self.profile = [[MFYProfile alloc] initWithDictionary:dictionary[kMFYArticleProfile]];
    }

    if(![dictionary[kMFYArticleSubtitle] isKindOfClass:[NSNull class]]){
        self.subtitle = dictionary[kMFYArticleSubtitle];
    }
    if(![dictionary[kMFYArticleTitle] isKindOfClass:[NSNull class]]){
        self.title = dictionary[kMFYArticleTitle];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.articleId != nil){
        dictionary[kMFYArticleArticleId] = self.articleId;
    }
    if(self.bodyText != nil){
        dictionary[kMFYArticleBodyText] = self.bodyText;
    }
    if(self.createDate != nil){
        dictionary[kMFYArticleCreateDate] = self.createDate;
    }
    if(self.embeddedArticles != nil){
        dictionary[kMFYArticleEmbeddedArticles] = self.embeddedArticles;
    }
    dictionary[kMFYArticleFormatType] = @(self.formatType);
    dictionary[kMFYArticleFunctionType] = @(self.functionType);
    if(self.media != nil){
        dictionary[kMFYArticleMedia] = [self.media toDictionary];
    }
    dictionary[kMFYArticlePostType] = @(self.postType);
    dictionary[kMFYArticlePriceAmount] = @(self.priceAmount);
    if(self.profile != nil){
        dictionary[kMFYArticleProfile] = [self.profile toDictionary];
    }
    if(self.subtitle != nil){
        dictionary[kMFYArticleSubtitle] = self.subtitle;
    }
    if(self.title != nil){
        dictionary[kMFYArticleTitle] = self.title;
    }
    return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if(self.articleId != nil){
        [aCoder encodeObject:self.articleId forKey:kMFYArticleArticleId];
    }
    if(self.bodyText != nil){
        [aCoder encodeObject:self.bodyText forKey:kMFYArticleBodyText];
    }
    if(self.createDate != nil){
        [aCoder encodeObject:self.createDate forKey:kMFYArticleCreateDate];
    }
    if(self.embeddedArticles != nil){
        [aCoder encodeObject:self.embeddedArticles forKey:kMFYArticleEmbeddedArticles];
    }
    [aCoder encodeObject:@(self.formatType) forKey:kMFYArticleFormatType];    [aCoder encodeObject:@(self.functionType) forKey:kMFYArticleFunctionType];    if(self.media != nil){
        [aCoder encodeObject:self.media forKey:kMFYArticleMedia];
    }
    [aCoder encodeObject:@(self.postType) forKey:kMFYArticlePostType];    [aCoder encodeObject:@(self.priceAmount) forKey:kMFYArticlePriceAmount];    if(self.profile != nil){
        [aCoder encodeObject:self.profile forKey:kMFYArticleProfile];
    }
    if(self.subtitle != nil){
        [aCoder encodeObject:self.subtitle forKey:kMFYArticleSubtitle];
    }
    if(self.title != nil){
        [aCoder encodeObject:self.title forKey:kMFYArticleTitle];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.articleId = [aDecoder decodeObjectForKey:kMFYArticleArticleId];
    self.bodyText = [aDecoder decodeObjectForKey:kMFYArticleBodyText];
    self.createDate = [aDecoder decodeObjectForKey:kMFYArticleCreateDate];
    self.embeddedArticles = [aDecoder decodeObjectForKey:kMFYArticleEmbeddedArticles];
    self.formatType = [[aDecoder decodeObjectForKey:kMFYArticleFormatType] integerValue];
    self.functionType = [[aDecoder decodeObjectForKey:kMFYArticleFunctionType] integerValue];
    self.media = [aDecoder decodeObjectForKey:kMFYArticleMedia];
    self.postType = [[aDecoder decodeObjectForKey:kMFYArticlePostType] integerValue];
    self.priceAmount = [[aDecoder decodeObjectForKey:kMFYArticlePriceAmount] floatValue];
    self.profile = [aDecoder decodeObjectForKey:kMFYArticleProfile];
    self.subtitle = [aDecoder decodeObjectForKey:kMFYArticleSubtitle];
    self.title = [aDecoder decodeObjectForKey:kMFYArticleTitle];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYArticle *copy = [MFYArticle new];

    copy.articleId = [self.articleId copy];
    copy.bodyText = [self.bodyText copy];
    copy.createDate = [self.createDate copy];
    copy.embeddedArticles = [self.embeddedArticles copy];
    copy.formatType = self.formatType;
    copy.functionType = self.functionType;
    copy.media = [self.media copy];
    copy.postType = self.postType;
    copy.priceAmount = self.priceAmount;
    copy.profile = [self.profile copy];
    copy.subtitle = [self.subtitle copy];
    copy.title = [self.title copy];

    return copy;
}

@end
