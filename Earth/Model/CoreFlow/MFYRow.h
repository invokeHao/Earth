//
//  MFYRow.h
//  Earth
//
//  Created by colr on 2019/12/27.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYRow : NSObject

@property (nonatomic, strong)NSString * imageUrl;

@property (nonatomic, strong)NSString * title;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
