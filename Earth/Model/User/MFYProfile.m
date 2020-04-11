//
//    MFYProfile.m
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport




#import "MFYProfile.h"

NSString *const kMFYProfileAdmin = @"admin";
NSString *const kMFYProfileAge = @"age";
NSString *const kMFYProfileAllowSearch = @"allowSearch";
NSString *const kMFYProfileAuthValue = @"authValue";
NSString *const kMFYProfileBanned = @"banned";
NSString *const kMFYProfileCreateDate = @"createDate";
NSString *const kMFYProfileGender = @"gender";
NSString *const kMFYProfileHeadIconUrl = @"headIconUrl";
NSString *const kMFYProfileHeadIconId = @"headIconId";
NSString *const kMFYProfileImId = @"imId";
NSString *const kMFYProfileImPwd = @"imPwd";
NSString *const kMFYProfileInRelationDestChatAmount = @"inRelationDestChatAmount";
NSString *const kMFYProfileInRelationSrcChatAmount = @"inRelationSrcChatAmount";
NSString *const kMFYProfileNickname = @"nickname";
NSString *const kMFYProfileProfileDomainItems = @"profileDomainItems";
NSString *const kMFYProfileProfileDesc = @"profileDesc";
NSString *const kMFYProfileProfileUpdated = @"profileUpdated";
NSString *const kMFYProfileSuperAdmin = @"superAdmin";
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
    if(![dictionary[kMFYProfileAdmin] isKindOfClass:[NSNull class]]){
        self.admin = [dictionary[kMFYProfileAdmin] boolValue];
    }

    if(![dictionary[kMFYProfileAge] isKindOfClass:[NSNull class]]){
        self.age = [dictionary[kMFYProfileAge] integerValue];
    }

    if(![dictionary[kMFYProfileAllowSearch] isKindOfClass:[NSNull class]]){
        self.allowSearch = [dictionary[kMFYProfileAllowSearch] boolValue];
    }

    if(![dictionary[kMFYProfileAuthValue] isKindOfClass:[NSNull class]]){
        self.authValue = dictionary[kMFYProfileAuthValue];
    }
    if(![dictionary[kMFYProfileBanned] isKindOfClass:[NSNull class]]){
        self.banned = [dictionary[kMFYProfileBanned] boolValue];
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
    if(![dictionary[kMFYProfileHeadIconId] isKindOfClass:[NSNull class]]){
        self.headIconId = dictionary[kMFYProfileHeadIconId];
    }

    if(![dictionary[kMFYProfileImId] isKindOfClass:[NSNull class]]){
        self.imId = dictionary[kMFYProfileImId];
    }
    
    if(![dictionary[kMFYProfileImPwd] isKindOfClass:[NSNull class]]){
        self.imPwd = dictionary[kMFYProfileImPwd];
    }

    if(![dictionary[kMFYProfileInRelationDestChatAmount] isKindOfClass:[NSNull class]]){
        self.inRelationDestChatAmount = [dictionary[kMFYProfileInRelationDestChatAmount] integerValue];
    }

    if(![dictionary[kMFYProfileInRelationSrcChatAmount] isKindOfClass:[NSNull class]]){
        self.inRelationSrcChatAmount = [dictionary[kMFYProfileInRelationSrcChatAmount] integerValue];
    }

    if(![dictionary[kMFYProfileNickname] isKindOfClass:[NSNull class]]){
        self.nickname = dictionary[kMFYProfileNickname];
    }
        
    if(![dictionary[kMFYProfileProfileDesc] isKindOfClass:[NSNull class]]){
        self.profileDesc = dictionary[kMFYProfileProfileDesc];
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

    if(![dictionary[kMFYProfileSuperAdmin] isKindOfClass:[NSNull class]]){
        self.superAdmin = [dictionary[kMFYProfileSuperAdmin] boolValue];
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
    dictionary[kMFYProfileAdmin] = @(self.admin);
    dictionary[kMFYProfileAge] = @(self.age);
    dictionary[kMFYProfileAllowSearch] = @(self.allowSearch);
    if(self.authValue != nil){
        dictionary[kMFYProfileAuthValue] = self.authValue;
    }
    dictionary[kMFYProfileBanned] = @(self.banned);
    dictionary[kMFYProfileCreateDate] = @(self.createDate);
    if(self.gender != nil){
        dictionary[kMFYProfileGender] = [self.gender toDictionary];
    }
    if(self.headIconId != nil){
        dictionary[kMFYProfileHeadIconId] = self.headIconId;
    }

    if(self.headIconUrl != nil){
        dictionary[kMFYProfileHeadIconUrl] = self.headIconUrl;
    }
    if(self.imId != nil){
        dictionary[kMFYProfileImId] = self.imId;
    }
    if(self.imPwd != nil){
        dictionary[kMFYProfileImPwd] = self.imPwd;
    }

    dictionary[kMFYProfileInRelationDestChatAmount] = @(self.inRelationDestChatAmount);
    dictionary[kMFYProfileInRelationSrcChatAmount] = @(self.inRelationSrcChatAmount);
    if(self.nickname != nil){
        dictionary[kMFYProfileNickname] = self.nickname;
    }
    if(self.profileDesc != nil){
        dictionary[kMFYProfileProfileDesc] = self.profileDesc;
    }

    if(self.profileDomainItems != nil){
        NSMutableArray * dictionaryElements = [NSMutableArray array];
        for(MFYGender * profileDomainItemsElement in self.profileDomainItems){
            [dictionaryElements addObject:[profileDomainItemsElement toDictionary]];
        }
        dictionary[kMFYProfileProfileDomainItems] = dictionaryElements;
    }
    dictionary[kMFYProfileProfileUpdated] = @(self.profileUpdated);
    dictionary[kMFYProfileSuperAdmin] = @(self.superAdmin);
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
    [aCoder encodeObject:@(self.admin) forKey:kMFYProfileAdmin];    [aCoder encodeObject:@(self.age) forKey:kMFYProfileAge];    [aCoder encodeObject:@(self.allowSearch) forKey:kMFYProfileAllowSearch];    if(self.authValue != nil){
        [aCoder encodeObject:self.authValue forKey:kMFYProfileAuthValue];
    }
    [aCoder encodeObject:@(self.banned) forKey:kMFYProfileBanned];    [aCoder encodeObject:@(self.createDate) forKey:kMFYProfileCreateDate];    if(self.gender != nil){
        [aCoder encodeObject:self.gender forKey:kMFYProfileGender];
    }
    if(self.headIconId != nil){
        [aCoder encodeObject:self.headIconId forKey:kMFYProfileHeadIconId];
    }

    if(self.headIconUrl != nil){
        [aCoder encodeObject:self.headIconUrl forKey:kMFYProfileHeadIconUrl];
    }
    if(self.imId != nil){
        [aCoder encodeObject:self.imId forKey:kMFYProfileImId];
    }
    if(self.imPwd != nil){
        [aCoder encodeObject:self.imPwd forKey:kMFYProfileImPwd];
    }

    [aCoder encodeObject:@(self.inRelationDestChatAmount) forKey:kMFYProfileInRelationDestChatAmount];    [aCoder encodeObject:@(self.inRelationSrcChatAmount) forKey:kMFYProfileInRelationSrcChatAmount];    if(self.nickname != nil){
        [aCoder encodeObject:self.nickname forKey:kMFYProfileNickname];
    }
    if(self.profileDesc != nil){
        [aCoder encodeObject:self.profileDesc forKey:kMFYProfileProfileDesc];
    }
    if(self.profileDomainItems != nil){
        [aCoder encodeObject:self.profileDomainItems forKey:kMFYProfileProfileDomainItems];
    }
    [aCoder encodeObject:@(self.profileUpdated) forKey:kMFYProfileProfileUpdated];    [aCoder encodeObject:@(self.superAdmin) forKey:kMFYProfileSuperAdmin];    if(self.tags != nil){
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
    self.admin = [[aDecoder decodeObjectForKey:kMFYProfileAdmin] boolValue];
    self.age = [[aDecoder decodeObjectForKey:kMFYProfileAge] integerValue];
    self.allowSearch = [[aDecoder decodeObjectForKey:kMFYProfileAllowSearch] boolValue];
    self.authValue = [aDecoder decodeObjectForKey:kMFYProfileAuthValue];
    self.banned = [[aDecoder decodeObjectForKey:kMFYProfileBanned] boolValue];
    self.createDate = [[aDecoder decodeObjectForKey:kMFYProfileCreateDate] integerValue];
    self.gender = [aDecoder decodeObjectForKey:kMFYProfileGender];
    self.headIconId = [aDecoder decodeObjectForKey:kMFYProfileHeadIconId];
    self.headIconUrl = [aDecoder decodeObjectForKey:kMFYProfileHeadIconUrl];
    self.imId = [aDecoder decodeObjectForKey:kMFYProfileImId];
    self.imPwd = [aDecoder decodeObjectForKey:kMFYProfileImPwd];
    self.inRelationDestChatAmount = [[aDecoder decodeObjectForKey:kMFYProfileInRelationDestChatAmount] integerValue];
    self.inRelationSrcChatAmount = [[aDecoder decodeObjectForKey:kMFYProfileInRelationSrcChatAmount] integerValue];
    self.nickname = [aDecoder decodeObjectForKey:kMFYProfileNickname];
    self.profileDesc = [aDecoder decodeObjectForKey:kMFYProfileProfileDesc];
    self.profileDomainItems = [aDecoder decodeObjectForKey:kMFYProfileProfileDomainItems];
    self.profileUpdated = [[aDecoder decodeObjectForKey:kMFYProfileProfileUpdated] boolValue];
    self.superAdmin = [[aDecoder decodeObjectForKey:kMFYProfileSuperAdmin] boolValue];
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

    copy.admin = self.admin;
    copy.age = self.age;
    copy.allowSearch = self.allowSearch;
    copy.authValue = [self.authValue copy];
    copy.banned = self.banned;
    copy.createDate = self.createDate;
    copy.gender = [self.gender copy];
    copy.headIconId = [self.headIconId copy];
    copy.headIconUrl = [self.headIconUrl copy];
    copy.imId = [self.imId copy];
    copy.imPwd = [self.imPwd copy];
    copy.inRelationDestChatAmount = self.inRelationDestChatAmount;
    copy.inRelationSrcChatAmount = self.inRelationSrcChatAmount;
    copy.nickname = [self.nickname copy];
    copy.profileDesc = [self.profileDesc copy];
    copy.profileDomainItems = [self.profileDomainItems copy];
    copy.profileUpdated = self.profileUpdated;
    copy.superAdmin = self.superAdmin;
    copy.tags = [self.tags copy];
    copy.userId = [self.userId copy];

    return copy;
}
@end
