//
//  MFYMedia.m
//  Earth
//
//  Created by colr on 2020/1/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMedia.h"

NSString *const kMFYMediaMediaId = @"mediaId";
NSString *const kMFYMediaMediaType = @"mediaType";
NSString *const kMFYMediaMediaUrl = @"mediaUrl";

@implementation MFYMedia

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYMediaMediaId] isKindOfClass:[NSNull class]]){
        self.mediaId = dictionary[kMFYMediaMediaId];
    }
    if(![dictionary[kMFYMediaMediaType] isKindOfClass:[NSNull class]]){
        self.mediaType = [dictionary[kMFYMediaMediaType] integerValue];
    }

    if(![dictionary[kMFYMediaMediaUrl] isKindOfClass:[NSNull class]]){
        self.mediaUrl = dictionary[kMFYMediaMediaUrl];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.mediaId != nil){
        dictionary[kMFYMediaMediaId] = self.mediaId;
    }
    dictionary[kMFYMediaMediaType] = @(self.mediaType);
    if(self.mediaUrl != nil){
        dictionary[kMFYMediaMediaUrl] = self.mediaUrl;
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
    if(self.mediaId != nil){
        [aCoder encodeObject:self.mediaId forKey:kMFYMediaMediaId];
    }
    [aCoder encodeObject:@(self.mediaType) forKey:kMFYMediaMediaType];    if(self.mediaUrl != nil){
        [aCoder encodeObject:self.mediaUrl forKey:kMFYMediaMediaUrl];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.mediaId = [aDecoder decodeObjectForKey:kMFYMediaMediaId];
    self.mediaType = [[aDecoder decodeObjectForKey:kMFYMediaMediaType] integerValue];
    self.mediaUrl = [aDecoder decodeObjectForKey:kMFYMediaMediaUrl];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYMedia *copy = [MFYMedia new];

    copy.mediaId = [self.mediaId copy];
    copy.mediaType = self.mediaType;
    copy.mediaUrl = [self.mediaUrl copy];

    return copy;
}

@end
