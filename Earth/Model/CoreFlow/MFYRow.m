//
//  MFYRow.m
//  Earth
//
//  Created by colr on 2019/12/27.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYRow.h"

@implementation MFYRow

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.imageUrl = dic[@"imageUrl"];
        self.title = dic[@"title"];
    }
    return self;
}


@end
