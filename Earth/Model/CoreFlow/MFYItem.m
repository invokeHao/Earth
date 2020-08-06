//
//  MFYItem.m
//  Earth
//
//  Created by colr on 2020/2/11.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYItem.h"

NSString *const kMFYItemArticleId = @"articleId";
NSString *const kMFYItemBodyText = @"bodyText";
NSString *const kMFYItemCommentTimes = @"commentTimes";
NSString *const kMFYItemComplained = @"complained";
NSString *const kMFYItemCreateDate = @"createDate";
NSString *const kMFYItemEmbeddedArticles = @"embeddedArticles";
NSString *const kMFYItemFormatType = @"formatType";
NSString *const kMFYItemFunctionType = @"functionType";
NSString *const kMFYItemLikeTimes = @"likeTimes";
NSString *const kMFYItemLiked = @"liked";
NSString *const kMFYItemMedia = @"media";
NSString *const kMFYItemPostType = @"postType";
NSString *const kMFYItemPriceAmount = @"priceAmount";
NSString *const kMFYItemPurchased = @"purchased";
NSString *const kMFYItemUnliked = @"unliked";

@interface MFYItem ()
@end
@implementation MFYItem




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYItemArticleId] isKindOfClass:[NSNull class]]){
        self.articleId = dictionary[kMFYItemArticleId];
    }
    if(![dictionary[kMFYItemBodyText] isKindOfClass:[NSNull class]]){
        self.bodyText = dictionary[kMFYItemBodyText];
    }
    if(![dictionary[kMFYItemCommentTimes] isKindOfClass:[NSNull class]]){
        self.commentTimes = [dictionary[kMFYItemCommentTimes] integerValue];
    }

    if(![dictionary[kMFYItemComplained] isKindOfClass:[NSNull class]]){
        self.complained = [dictionary[kMFYItemComplained] boolValue];
    }

    if(![dictionary[kMFYItemCreateDate] isKindOfClass:[NSNull class]]){
        self.createDate = [dictionary[kMFYItemCreateDate] integerValue];
    }

    if(![dictionary[kMFYItemEmbeddedArticles] isKindOfClass:[NSNull class]]){
        self.embeddedArticles = dictionary[kMFYItemEmbeddedArticles];
    }
    if(![dictionary[kMFYItemFormatType] isKindOfClass:[NSNull class]]){
        self.formatType = [dictionary[kMFYItemFormatType] integerValue];
    }

    if(![dictionary[kMFYItemFunctionType] isKindOfClass:[NSNull class]]){
        self.functionType = [dictionary[kMFYItemFunctionType] integerValue];
    }

    if(![dictionary[kMFYItemLikeTimes] isKindOfClass:[NSNull class]]){
        self.likeTimes = [dictionary[kMFYItemLikeTimes] integerValue];
    }

    if(![dictionary[kMFYItemLiked] isKindOfClass:[NSNull class]]){
        self.liked = [dictionary[kMFYItemLiked] boolValue];
    }

    if(![dictionary[kMFYItemMedia] isKindOfClass:[NSNull class]]){
        self.media = [[MFYMedia alloc] initWithDictionary:dictionary[kMFYItemMedia]];
    }

    if(![dictionary[kMFYItemPostType] isKindOfClass:[NSNull class]]){
        self.postType = [dictionary[kMFYItemPostType] integerValue];
    }

    if(![dictionary[kMFYItemPriceAmount] isKindOfClass:[NSNull class]]){
        self.priceAmount = [dictionary[kMFYItemPriceAmount] integerValue];
    }

    if(![dictionary[kMFYItemPurchased] isKindOfClass:[NSNull class]]){
        self.purchased = [dictionary[kMFYItemPurchased] boolValue];
    }

    if(![dictionary[kMFYItemUnliked] isKindOfClass:[NSNull class]]){
        self.unliked = [dictionary[kMFYItemUnliked] boolValue];
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
        dictionary[kMFYItemArticleId] = self.articleId;
    }
    if(self.bodyText != nil){
        dictionary[kMFYItemBodyText] = self.bodyText;
    }
    dictionary[kMFYItemCommentTimes] = @(self.commentTimes);
    dictionary[kMFYItemComplained] = @(self.complained);
    dictionary[kMFYItemCreateDate] = @(self.createDate);
    if(self.embeddedArticles != nil){
        dictionary[kMFYItemEmbeddedArticles] = self.embeddedArticles;
    }
    dictionary[kMFYItemFormatType] = @(self.formatType);
    dictionary[kMFYItemFunctionType] = @(self.functionType);
    dictionary[kMFYItemLikeTimes] = @(self.likeTimes);
    dictionary[kMFYItemLiked] = @(self.liked);
    if(self.media != nil){
        dictionary[kMFYItemMedia] = [self.media toDictionary];
    }
    dictionary[kMFYItemPostType] = @(self.postType);
    dictionary[kMFYItemPriceAmount] = @(self.priceAmount);
    dictionary[kMFYItemPurchased] = @(self.purchased);
    dictionary[kMFYItemUnliked] = @(self.unliked);
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
        [aCoder encodeObject:self.articleId forKey:kMFYItemArticleId];
    }
    if(self.bodyText != nil){
        [aCoder encodeObject:self.bodyText forKey:kMFYItemBodyText];
    }
    [aCoder encodeObject:@(self.commentTimes) forKey:kMFYItemCommentTimes];    [aCoder encodeObject:@(self.complained) forKey:kMFYItemComplained];    [aCoder encodeObject:@(self.createDate) forKey:kMFYItemCreateDate];    if(self.embeddedArticles != nil){
        [aCoder encodeObject:self.embeddedArticles forKey:kMFYItemEmbeddedArticles];
    }
    [aCoder encodeObject:@(self.formatType) forKey:kMFYItemFormatType];    [aCoder encodeObject:@(self.functionType) forKey:kMFYItemFunctionType];    [aCoder encodeObject:@(self.likeTimes) forKey:kMFYItemLikeTimes];    [aCoder encodeObject:@(self.liked) forKey:kMFYItemLiked];    if(self.media != nil){
        [aCoder encodeObject:self.media forKey:kMFYItemMedia];
    }
    [aCoder encodeObject:@(self.postType) forKey:kMFYItemPostType];    [aCoder encodeObject:@(self.priceAmount) forKey:kMFYItemPriceAmount];    [aCoder encodeObject:@(self.purchased) forKey:kMFYItemPurchased];    [aCoder encodeObject:@(self.unliked) forKey:kMFYItemUnliked];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.articleId = [aDecoder decodeObjectForKey:kMFYItemArticleId];
    self.bodyText = [aDecoder decodeObjectForKey:kMFYItemBodyText];
    self.commentTimes = [[aDecoder decodeObjectForKey:kMFYItemCommentTimes] integerValue];
    self.complained = [[aDecoder decodeObjectForKey:kMFYItemComplained] boolValue];
    self.createDate = [[aDecoder decodeObjectForKey:kMFYItemCreateDate] integerValue];
    self.embeddedArticles = [aDecoder decodeObjectForKey:kMFYItemEmbeddedArticles];
    self.formatType = [[aDecoder decodeObjectForKey:kMFYItemFormatType] integerValue];
    self.functionType = [[aDecoder decodeObjectForKey:kMFYItemFunctionType] integerValue];
    self.likeTimes = [[aDecoder decodeObjectForKey:kMFYItemLikeTimes] integerValue];
    self.liked = [[aDecoder decodeObjectForKey:kMFYItemLiked] boolValue];
    self.media = [aDecoder decodeObjectForKey:kMFYItemMedia];
    self.postType = [[aDecoder decodeObjectForKey:kMFYItemPostType] integerValue];
    self.priceAmount = [[aDecoder decodeObjectForKey:kMFYItemPriceAmount] integerValue];
    self.purchased = [[aDecoder decodeObjectForKey:kMFYItemPurchased] boolValue];
    self.unliked = [[aDecoder decodeObjectForKey:kMFYItemUnliked] boolValue];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYItem *copy = [MFYItem new];

    copy.articleId = [self.articleId copy];
    copy.bodyText = [self.bodyText copy];
    copy.commentTimes = self.commentTimes;
    copy.complained = self.complained;
    copy.createDate = self.createDate;
    copy.embeddedArticles = [self.embeddedArticles copy];
    copy.formatType = self.formatType;
    copy.functionType = self.functionType;
    copy.likeTimes = self.likeTimes;
    copy.liked = self.liked;
    copy.media = [self.media copy];
    copy.postType = self.postType;
    copy.priceAmount = self.priceAmount;
    copy.purchased = self.purchased;
    copy.unliked = self.unliked;

    return copy;
}

- (MFYMediaType)mediaType {
    if (self.media != nil) {
        return self.media.mediaType;
    }
    return MFYMediaPictureType;
}
@end

