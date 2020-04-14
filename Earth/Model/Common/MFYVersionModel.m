//
//  MFYVersionModel.m
//  Earth
//
//  Created by colr on 2020/4/13.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYVersionModel.h"

NSString *const kMFYVersionModelRequired = @"required";
NSString *const kMFYVersionModelUpdate = @"update";
NSString *const kMFYVersionModelUpdateDesc = @"updateDesc";
NSString *const kMFYVersionModelUpdateUrl = @"updateUrl";

@interface MFYVersionModel ()
@end
@implementation MFYVersionModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYVersionModelRequired] isKindOfClass:[NSNull class]]){
        self.required = [dictionary[kMFYVersionModelRequired] boolValue];
    }

    if(![dictionary[kMFYVersionModelUpdate] isKindOfClass:[NSNull class]]){
        self.update = [dictionary[kMFYVersionModelUpdate] boolValue];
    }

    if(![dictionary[kMFYVersionModelUpdateDesc] isKindOfClass:[NSNull class]]){
        self.updateDesc = dictionary[kMFYVersionModelUpdateDesc];
    }
    if(![dictionary[kMFYVersionModelUpdateUrl] isKindOfClass:[NSNull class]]){
        self.updateUrl = dictionary[kMFYVersionModelUpdateUrl];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kMFYVersionModelRequired] = @(self.required);
    dictionary[kMFYVersionModelUpdate] = @(self.update);
    if(self.updateDesc != nil){
        dictionary[kMFYVersionModelUpdateDesc] = self.updateDesc;
    }
    if(self.updateUrl != nil){
        dictionary[kMFYVersionModelUpdateUrl] = self.updateUrl;
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
    [aCoder encodeObject:@(self.required) forKey:kMFYVersionModelRequired];    [aCoder encodeObject:@(self.update) forKey:kMFYVersionModelUpdate];    if(self.updateDesc != nil){
        [aCoder encodeObject:self.updateDesc forKey:kMFYVersionModelUpdateDesc];
    }
    if(self.updateUrl != nil){
        [aCoder encodeObject:self.updateUrl forKey:kMFYVersionModelUpdateUrl];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.required = [[aDecoder decodeObjectForKey:kMFYVersionModelRequired] boolValue];
    self.update = [[aDecoder decodeObjectForKey:kMFYVersionModelUpdate] boolValue];
    self.updateDesc = [aDecoder decodeObjectForKey:kMFYVersionModelUpdateDesc];
    self.updateUrl = [aDecoder decodeObjectForKey:kMFYVersionModelUpdateUrl];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYVersionModel *copy = [MFYVersionModel new];

    copy.required = self.required;
    copy.update = self.update;
    copy.updateDesc = [self.updateDesc copy];
    copy.updateUrl = [self.updateUrl copy];

    return copy;
}
@end
