//
//  MODownloadCacheModel.m
//  cosmos
//
//  Created by colr on 2018/6/14.
//  Copyright © 2018年 Shell&Colr. All rights reserved.
//

#import "MODownloadCacheModel.h"

@implementation MODownloadCacheModel


- (BOOL)isEqual:(MODownloadCacheModel *)object {
    return [self.identifier isEqualToString:object.identifier];
}

@end
