//
//  MFYLoginModel.m
//  Earth
//
//  Created by colr on 2020/1/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

NSString *const kResultExpireDate = @"expireDate";
NSString *const kResultProfileUpdated = @"profileUpdated";
NSString *const kResultToken = @"token";


#import "MFYLoginModel.h"

@implementation MFYLoginModel


/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kResultExpireDate] isKindOfClass:[NSNull class]]){
        self.expireDate = dictionary[kResultExpireDate];
    }
    if(![dictionary[kResultProfileUpdated] isKindOfClass:[NSNull class]]){
        self.profileUpdated = [dictionary[kResultProfileUpdated] boolValue];
    }

    if(![dictionary[kResultToken] isKindOfClass:[NSNull class]]){
        self.token = dictionary[kResultToken];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.expireDate != nil){
        dictionary[kResultExpireDate] = self.expireDate;
    }
    dictionary[kResultProfileUpdated] = @(self.profileUpdated);
    if(self.token != nil){
        dictionary[kResultToken] = self.token;
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
    if(self.expireDate != nil){
        [aCoder encodeObject:self.expireDate forKey:kResultExpireDate];
    }
    [aCoder encodeObject:@(self.profileUpdated) forKey:kResultProfileUpdated];    if(self.token != nil){
        [aCoder encodeObject:self.token forKey:kResultToken];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.expireDate = [aDecoder decodeObjectForKey:kResultExpireDate];
    self.profileUpdated = [[aDecoder decodeObjectForKey:kResultProfileUpdated] boolValue];
    self.token = [aDecoder decodeObjectForKey:kResultToken];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYLoginModel *copy = [MFYLoginModel new];

    copy.expireDate = [self.expireDate copy];
    copy.profileUpdated = self.profileUpdated;
    copy.token = [self.token copy];

    return copy;
}

@end
