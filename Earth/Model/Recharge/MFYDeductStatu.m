//
//  MFYDeductStatu.m
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYDeductStatu.h"

NSString *const kMFYDeductStatuChecked = @"checked";
NSString *const kMFYDeductStatuCode = @"code";
NSString *const kMFYDeductStatuName = @"name";
NSString *const kMFYDeductStatuNo = @"no";

@interface MFYDeductStatu ()
@end
@implementation MFYDeductStatu




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYDeductStatuChecked] isKindOfClass:[NSNull class]]){
        self.checked = [dictionary[kMFYDeductStatuChecked] boolValue];
    }

    if(![dictionary[kMFYDeductStatuCode] isKindOfClass:[NSNull class]]){
        self.code = dictionary[kMFYDeductStatuCode];
    }
    if(![dictionary[kMFYDeductStatuName] isKindOfClass:[NSNull class]]){
        self.name = dictionary[kMFYDeductStatuName];
    }
    if(![dictionary[kMFYDeductStatuNo] isKindOfClass:[NSNull class]]){
        self.no = [dictionary[kMFYDeductStatuNo] integerValue];
    }

    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kMFYDeductStatuChecked] = @(self.checked);
    if(self.code != nil){
        dictionary[kMFYDeductStatuCode] = self.code;
    }
    if(self.name != nil){
        dictionary[kMFYDeductStatuName] = self.name;
    }
    dictionary[kMFYDeductStatuNo] = @(self.no);
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
    [aCoder encodeObject:@(self.checked) forKey:kMFYDeductStatuChecked];    if(self.code != nil){
        [aCoder encodeObject:self.code forKey:kMFYDeductStatuCode];
    }
    if(self.name != nil){
        [aCoder encodeObject:self.name forKey:kMFYDeductStatuName];
    }
    [aCoder encodeObject:@(self.no) forKey:kMFYDeductStatuNo];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.checked = [[aDecoder decodeObjectForKey:kMFYDeductStatuChecked] boolValue];
    self.code = [aDecoder decodeObjectForKey:kMFYDeductStatuCode];
    self.name = [aDecoder decodeObjectForKey:kMFYDeductStatuName];
    self.no = [[aDecoder decodeObjectForKey:kMFYDeductStatuNo] integerValue];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYDeductStatu *copy = [MFYDeductStatu new];

    copy.checked = self.checked;
    copy.code = [self.code copy];
    copy.name = [self.name copy];
    copy.no = self.no;

    return copy;
}
@end
