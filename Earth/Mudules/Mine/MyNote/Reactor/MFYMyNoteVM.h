//
//  MFYMyNoteVM.h
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MFYArticle;
@interface MFYMyNoteVM : NSObject

@property (nonatomic, strong,readonly) NSMutableArray<MFYArticle *> * dataList;

@property (nonatomic, strong,readonly) NSMutableArray * tagList;

@property (nonatomic, assign, readonly) NSInteger NewDataCount;

-(void)refreshData;

- (void)refreshTheTag;


@end

NS_ASSUME_NONNULL_END
