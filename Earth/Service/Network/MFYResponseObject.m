//
//  MFYResponseObject.m
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYResponseObject.h"

NSString *const kMFYResponseObjectCode = @"code";
NSString *const kMFYResponseObjectErrorDesc = @"errorDesc";
NSString *const kMFYResponseObjectErrorId = @"errorId";
NSString *const kMFYResponseObjectResult = @"result";

@implementation MFYResponseObject


-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kMFYResponseObjectCode] isKindOfClass:[NSNull class]]){
        self.code = [dictionary[kMFYResponseObjectCode] integerValue];
    }
    if(![dictionary[kMFYResponseObjectErrorDesc] isKindOfClass:[NSNull class]]){
        self.errorDesc = dictionary[kMFYResponseObjectErrorDesc];
    }
    if(![dictionary[kMFYResponseObjectErrorId] isKindOfClass:[NSNull class]]){
        self.errorId = [dictionary[kMFYResponseObjectErrorId] integerValue];
    }
    if(![dictionary[kMFYResponseObjectResult] isKindOfClass:[NSNull class]]){
        self.result = dictionary[kMFYResponseObjectResult];
    }
    return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    dictionary[kMFYResponseObjectCode] = @(self.code);
    if(self.errorDesc != nil){
        dictionary[kMFYResponseObjectErrorDesc] = self.errorDesc;
    }
    dictionary[kMFYResponseObjectErrorId] = @(self.errorId);
    if(self.result != nil){
        dictionary[kMFYResponseObjectResult] = self.result;
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
    [aCoder encodeObject:@(self.code) forKey:kMFYResponseObjectCode];
    [aCoder encodeObject:@(self.errorId) forKey:kMFYResponseObjectErrorId];
    if(self.errorDesc != nil){
        [aCoder encodeObject:self.errorDesc forKey:kMFYResponseObjectErrorDesc];
    }
    if(self.result != nil){
        [aCoder encodeObject:self.result forKey:kMFYResponseObjectResult];
    }
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.code = [[aDecoder decodeObjectForKey:kMFYResponseObjectCode] integerValue];
    self.errorId = [[aDecoder decodeObjectForKey:kMFYResponseObjectErrorId] integerValue];
    self.errorDesc = [aDecoder decodeObjectForKey:kMFYResponseObjectErrorDesc];
    self.result = [aDecoder decodeObjectForKey:kMFYResponseObjectResult];
    return self;
    
}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
    MFYResponseObject *copy = [MFYResponseObject new];
    
    copy.code = self.code;
    copy.errorId = self.errorId;
    copy.errorDesc = [self.errorDesc copy];
    copy.result = [self.result copy];
    
    return copy;
}


@end
