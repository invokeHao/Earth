//
//  MFYGender.m
//  Earth
//
//  Created by colr on 2020/1/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYGender.h"

NSString *const kMFYGenderChecked = @"checked";
NSString *const kMFYGenderCode = @"code";
NSString *const kMFYGenderName = @"name";
NSString *const kMFYGenderNo = @"no";


@implementation MFYGender

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYGenderChecked] isKindOfClass:[NSNull class]]){
        self.checked = [dictionary[kMFYGenderChecked] boolValue];
    }

    if(![dictionary[kMFYGenderCode] isKindOfClass:[NSNull class]]){
        self.code = dictionary[kMFYGenderCode];
    }
    if(![dictionary[kMFYGenderName] isKindOfClass:[NSNull class]]){
        self.name = dictionary[kMFYGenderName];
    }
    if(![dictionary[kMFYGenderNo] isKindOfClass:[NSNull class]]){
        self.no = [dictionary[kMFYGenderNo] integerValue];
    }

    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kMFYGenderChecked] = @(self.checked);
    if(self.code != nil){
        dictionary[kMFYGenderCode] = self.code;
    }
    if(self.name != nil){
        dictionary[kMFYGenderName] = self.name;
    }
    dictionary[kMFYGenderNo] = @(self.no);
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
    [aCoder encodeObject:@(self.checked) forKey:kMFYGenderChecked];    if(self.code != nil){
        [aCoder encodeObject:self.code forKey:kMFYGenderCode];
    }
    if(self.name != nil){
        [aCoder encodeObject:self.name forKey:kMFYGenderName];
    }
    [aCoder encodeObject:@(self.no) forKey:kMFYGenderNo];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.checked = [[aDecoder decodeObjectForKey:kMFYGenderChecked] boolValue];
    self.code = [aDecoder decodeObjectForKey:kMFYGenderCode];
    self.name = [aDecoder decodeObjectForKey:kMFYGenderName];
    self.no = [[aDecoder decodeObjectForKey:kMFYGenderNo] integerValue];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYGender *copy = [MFYGender new];

    copy.checked = self.checked;
    copy.code = [self.code copy];
    copy.name = [self.name copy];
    copy.no = self.no;

    return copy;
}

@end
