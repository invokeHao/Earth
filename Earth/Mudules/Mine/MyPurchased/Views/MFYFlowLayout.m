//
//  MFYFlowLayout.m
//  Earth
//
//  Created by colr on 2020/3/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYFlowLayout.h"

@implementation MFYFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configTheLayout];
    }
    return self;
}

- (void)configTheLayout {
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat itemWith = (VERTICAL_SCREEN_WIDTH - 30) / 2;
    CGFloat itemHeight = itemWith * 1.38;
    self.itemSize = CGSizeMake(itemWith, itemHeight);
}

@end
