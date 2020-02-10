//
//  MOPhotoLibraryManager.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/8.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOAssetModel.h"

@interface MOPhotoLibraryManager : NSObject

@property (nonatomic, strong) NSMutableArray <MOAssetModel *> *selectedList;
@property (nonatomic, assign, readonly) NSInteger selectedCount;
@property (nonatomic, assign, readonly) NSInteger maxSelectedCount;

+ (instancetype)sharedManager;
- (void)reset;

- (void)loadMaxSelectedCount:(NSInteger)maxSelectedCount;
- (BOOL)canSelected;



@end
