//
//  MFYFlowListVM.m
//  Earth
//
//  Created by colr on 2019/12/27.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYFlowListVM.h"

@interface MFYFlowListVM()

@property (nonatomic, strong) NSArray<MFYArticle *> * dataList;

@property (nonatomic, assign) NSInteger NewDataCount;

@property (nonatomic, strong) NSString * topicId;

@end

@implementation MFYFlowListVM

-(instancetype)initWithTopicId:(NSString *)topicId {
    self = [super init];
    if (self) {
        _topicId = topicId;
        [self setupData];
        [self bindData];
    }
    return self;
}

- (void)bindData {
    
}

- (void)refreshData {
    [self setupData];
}


-(void)setupData {
    @weakify(self)
    [MFYCoreflowService getTheImageCardWithTopicId:self.topicId completion:^(NSArray<MFYArticle *> * _Nonnull articleList, NSError * _Nonnull error) {
        @strongify(self)
        self.NewDataCount = articleList.count;
         if (articleList.count > 0) {
             self.dataList = [articleList copy];
         }
    }];
}

@end
