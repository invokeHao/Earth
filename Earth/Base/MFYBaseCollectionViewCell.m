//
//  MFYBaseCollectionViewCell.m
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseCollectionViewCell.h"

@implementation MFYBaseCollectionViewCell

- (void)renderWithModel:(id)element args:(NSDictionary *)args {
    self.element = element;
    NSAssert(NO, @"重写me");
}

+ (CGSize)cellSizeWithModel:(id)element args:(NSDictionary *)args {
    NSAssert(NO, @"重写me");
    return CGSizeMake(44, 44);
}

+ (NSString *)reuseID {
    return NSStringFromClass([self class]);
}
    
+ (NSString *)identifer {
    return NSStringFromClass([self class]);
}


@end
