//
//  MFYAudioTopic.m
//  Earth
//
//  Created by colr on 2020/3/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAudioTopic.h"


NSString *const kMFYAudioTopicIdField = @"id";
NSString *const kMFYAudioTopicValue = @"value";

@interface MFYAudioTopic ()
@end
@implementation MFYAudioTopic




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYAudioTopicIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kMFYAudioTopicIdField];
    }
    if(![dictionary[kMFYAudioTopicValue] isKindOfClass:[NSNull class]]){
        self.value = dictionary[kMFYAudioTopicValue];
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
        dictionary[kMFYAudioTopicIdField] = self.idField;
    }
    if(self.value != nil){
        dictionary[kMFYAudioTopicValue] = self.value;
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
        [aCoder encodeObject:self.idField forKey:kMFYAudioTopicIdField];
    }
    if(self.value != nil){
        [aCoder encodeObject:self.value forKey:kMFYAudioTopicValue];
    }

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.idField = [aDecoder decodeObjectForKey:kMFYAudioTopicIdField];
    self.value = [aDecoder decodeObjectForKey:kMFYAudioTopicValue];
    return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYAudioTopic *copy = [MFYAudioTopic new];

    copy.idField = [self.idField copy];
    copy.value = [self.value copy];

    return copy;
}
@end
