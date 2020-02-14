//
//  MFYCoreflowTag.m
//  Earth
//
//  Created by colr on 2020/2/12.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYCoreflowTag.h"

NSString *const kMFYCoreflowTagIdField = @"id";
NSString *const kMFYCoreflowTagValue = @"value";

@interface MFYCoreflowTag ()
@end
@implementation MFYCoreflowTag




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYCoreflowTagIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kMFYCoreflowTagIdField];
    }
    if(![dictionary[kMFYCoreflowTagValue] isKindOfClass:[NSNull class]]){
        self.value = dictionary[kMFYCoreflowTagValue];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if(self.idField != nil){
        dictionary[kMFYCoreflowTagIdField] = self.idField;
    }
    if(self.value != nil){
        dictionary[kMFYCoreflowTagValue] = self.value;
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
    if(self.idField != nil){
        [aCoder encodeObject:self.idField forKey:kMFYCoreflowTagIdField];
    }
    if(self.value != nil){
        [aCoder encodeObject:self.value forKey:kMFYCoreflowTagValue];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.idField = [aDecoder decodeObjectForKey:kMFYCoreflowTagIdField];
    self.value = [aDecoder decodeObjectForKey:kMFYCoreflowTagValue];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYCoreflowTag *copy = [MFYCoreflowTag new];

    copy.idField = [self.idField copy];
    copy.value = [self.value copy];

    return copy;
}
@end
