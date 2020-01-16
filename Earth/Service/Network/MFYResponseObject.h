//
//  MFYResponseObject.h
//  Earth
//
//  Created by colr on 2020/1/15.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYResponseObject : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString * errorDesc;
@property (nonatomic, assign) NSInteger errorId;
@property (nonatomic, strong) id result;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
