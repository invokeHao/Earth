//
//  MFYFlowListVM.m
//  Earth
//
//  Created by colr on 2019/12/27.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYFlowListVM.h"

@interface MFYFlowListVM()

@property (nonatomic, strong) NSMutableArray<MFYArticle *> * dataList;

@property (nonatomic, assign) NSInteger NewDataCount;

@end

@implementation MFYFlowListVM

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}

-(void)setupData {
    [MFYCoreflowService getTheImageCardWithFlowType:MFYCoreflowImageAllType completion:^(NSArray<MFYArticle *> * _Nonnull articleList, NSError * _Nonnull error) {
        WHLog(@"%@",[articleList firstObject]);
        self.NewDataCount = articleList.count;
        if (articleList.count > 0) {
            self.dataList = [articleList copy];
        }
    }];
}

- (NSMutableArray<MFYArticle *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataList;
}

@end
