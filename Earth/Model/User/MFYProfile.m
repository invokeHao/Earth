//
//  MFYProfile.m
//  Earth
//
//  Created by colr on 2020/1/17.
//  Copyright © 2020 fuYin. All rights reserved.
//


#import "MFYProfile.h"

NSString *const kMFYProfileAge = @"age";
NSString *const kMFYProfileAllowSearch = @"allowSearch";
NSString *const kMFYProfileCreateDate = @"createDate";
NSString *const kMFYProfileGender = @"gender";
NSString *const kMFYProfileHeadIconUrl = @"headIconUrl";
NSString *const kMFYProfileImId = @"imId";
NSString *const kMFYProfileNickname = @"nickname";
NSString *const kMFYProfileProfileDomainItems = @"profileDomainItems";
NSString *const kMFYProfileProfileUpdated = @"profileUpdated";
NSString *const kMFYProfileTags = @"tags";
NSString *const kMFYProfileUserId = @"userId";

@interface MFYProfile ()
@end
@implementation MFYProfile




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYProfileAge] isKindOfClass:[NSNull class]]){
        self.age = [dictionary[kMFYProfileAge] integerValue];
    }

    if(![dictionary[kMFYProfileAllowSearch] isKindOfClass:[NSNull class]]){
        self.allowSearch = [dictionary[kMFYProfileAllowSearch] boolValue];
    }

    if(![dictionary[kMFYProfileCreateDate] isKindOfClass:[NSNull class]]){
        self.createDate = [dictionary[kMFYProfileCreateDate] integerValue];
    }

    if(![dictionary[kMFYProfileGender] isKindOfClass:[NSNull class]]){
        self.gender = [[MFYGender alloc] initWithDictionary:dictionary[kMFYProfileGender]];
    }

    if(![dictionary[kMFYProfileHeadIconUrl] isKindOfClass:[NSNull class]]){
        self.headIconUrl = dictionary[kMFYProfileHeadIconUrl];
    }
    if(![dictionary[kMFYProfileImId] isKindOfClass:[NSNull class]]){
        self.imId = dictionary[kMFYProfileImId];
    }
    if(![dictionary[kMFYProfileNickname] isKindOfClass:[NSNull class]]){
        self.nickname = dictionary[kMFYProfileNickname];
    }
    if(dictionary[kMFYProfileProfileDomainItems] != nil && [dictionary[kMFYProfileProfileDomainItems] isKindOfClass:[NSArray class]]){
        NSArray * profileDomainItemsDictionaries = dictionary[kMFYProfileProfileDomainItems];
        NSMutableArray * profileDomainItemsItems = [NSMutableArray array];
        for(NSDictionary * profileDomainItemsDictionary in profileDomainItemsDictionaries){
            MFYGender * profileDomainItemsItem = [[MFYGender alloc] initWithDictionary:profileDomainItemsDictionary];
            [profileDomainItemsItems addObject:profileDomainItemsItem];
        }
        self.profileDomainItems = profileDomainItemsItems;
    }
    if(![dictionary[kMFYProfileProfileUpdated] isKindOfClass:[NSNull class]]){
        self.profileUpdated = [dictionary[kMFYProfileProfileUpdated] boolValue];
    }

    if(![dictionary[kMFYProfileTags] isKindOfClass:[NSNull class]]){
        self.tags = dictionary[kMFYProfileTags];
    }
    if(![dictionary[kMFYProfileUserId] isKindOfClass:[NSNull class]]){
        self.userId = dictionary[kMFYProfileUserId];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kMFYProfileAge] = @(self.age);
    dictionary[kMFYProfileAllowSearch] = @(self.allowSearch);
    dictionary[kMFYProfileCreateDate] = @(self.createDate);
    if(self.gender != nil){
        dictionary[kMFYProfileGender] = [self.gender toDictionary];
    }
    if(self.headIconUrl != nil){
        dictionary[kMFYProfileHeadIconUrl] = self.headIconUrl;
    }
    if(self.imId != nil){
        dictionary[kMFYProfileImId] = self.imId;
    }
    if(self.nickname != nil){
        dictionary[kMFYProfileNickname] = self.nickname;
    }
    if(self.profileDomainItems != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(MFYGender * profileDomainItemsElement in self.profileDomainItems){
            [dictionaryElements addObject:[profileDomainItemsElement toDictionary]];
        }
        dictionary[kMFYProfileProfileDomainItems] = dictionaryElements;
    }
    dictionary[kMFYProfileProfileUpdated] = @(self.profileUpdated);
    if(self.tags != nil){
        dictionary[kMFYProfileTags] = self.tags;
    }
    if(self.userId != nil){
        dictionary[kMFYProfileUserId] = self.userId;
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
    [aCoder encodeObject:@(self.age) forKey:kMFYProfileAge];    [aCoder encodeObject:@(self.allowSearch) forKey:kMFYProfileAllowSearch];    [aCoder encodeObject:@(self.createDate) forKey:kMFYProfileCreateDate];    if(self.gender != nil){
        [aCoder encodeObject:self.gender forKey:kMFYProfileGender];
    }
    if(self.headIconUrl != nil){
        [aCoder encodeObject:self.headIconUrl forKey:kMFYProfileHeadIconUrl];
    }
    if(self.imId != nil){
        [aCoder encodeObject:self.imId forKey:kMFYProfileImId];
    }
    if(self.nickname != nil){
        [aCoder encodeObject:self.nickname forKey:kMFYProfileNickname];
    }
    if(self.profileDomainItems != nil){
        [aCoder encodeObject:self.profileDomainItems forKey:kMFYProfileProfileDomainItems];
    }
    [aCoder encodeObject:@(self.profileUpdated) forKey:kMFYProfileProfileUpdated];    if(self.tags != nil){
        [aCoder encodeObject:self.tags forKey:kMFYProfileTags];
    }
    if(self.userId != nil){
        [aCoder encodeObject:self.userId forKey:kMFYProfileUserId];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.age = [[aDecoder decodeObjectForKey:kMFYProfileAge] integerValue];
    self.allowSearch = [[aDecoder decodeObjectForKey:kMFYProfileAllowSearch] boolValue];
    self.createDate = [[aDecoder decodeObjectForKey:kMFYProfileCreateDate] integerValue];
    self.gender = [aDecoder decodeObjectForKey:kMFYProfileGender];
    self.headIconUrl = [aDecoder decodeObjectForKey:kMFYProfileHeadIconUrl];
    self.imId = [aDecoder decodeObjectForKey:kMFYProfileImId];
    self.nickname = [aDecoder decodeObjectForKey:kMFYProfileNickname];
    self.profileDomainItems = [aDecoder decodeObjectForKey:kMFYProfileProfileDomainItems];
    self.profileUpdated = [[aDecoder decodeObjectForKey:kMFYProfileProfileUpdated] boolValue];
    self.tags = [aDecoder decodeObjectForKey:kMFYProfileTags];
    self.userId = [aDecoder decodeObjectForKey:kMFYProfileUserId];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYProfile *copy = [MFYProfile new];

    copy.age = self.age;
    copy.allowSearch = self.allowSearch;
    copy.createDate = self.createDate;
    copy.gender = [self.gender copy];
    copy.headIconUrl = [self.headIconUrl copy];
    copy.imId = [self.imId copy];
    copy.nickname = [self.nickname copy];
    copy.profileDomainItems = [self.profileDomainItems copy];
    copy.profileUpdated = self.profileUpdated;
    copy.tags = [self.tags copy];
    copy.userId = [self.userId copy];

    return copy;
}
@end
