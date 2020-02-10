//
//  MOPhotoLibraryManager.m
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/8.
//  Copyright © 2018年 colr. All rights reserved.
//

#import "MOPhotoLibraryManager.h"

@interface MOPhotoLibraryManager()

@property (nonatomic, assign) NSInteger maxSelectedCount;

@end

@implementation MOPhotoLibraryManager

+ (instancetype)sharedManager {
    static MOPhotoLibraryManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MOPhotoLibraryManager alloc] init];
        instance.selectedList = [NSMutableArray array];
        instance.maxSelectedCount = 1;
    });
    return instance;
}

- (void)loadMaxSelectedCount:(NSInteger)maxSelectedCount {
    self.maxSelectedCount = maxSelectedCount;
}

- (void)reset {
    [self.selectedList removeAllObjects];
    self.maxSelectedCount = 1;
}

- (BOOL)canSelected {
    return self.maxSelectedCount > self.selectedCount ? YES : NO;
}

- (NSInteger)selectedCount {
    return self.selectedList.count;
}



@end









