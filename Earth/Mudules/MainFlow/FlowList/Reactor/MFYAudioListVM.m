//
//  MFYAudioListVM.m
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAudioListVM.h"

@interface MFYAudioListVM()

@property (nonatomic, strong) NSArray<MFYArticle *> * dataList;

@property (nonatomic, assign) NSInteger NewDataCount;

@property (nonatomic, strong) NSString * topicId;

@end

@implementation MFYAudioListVM

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
    [MFYCoreflowService getTheAudioCardWithTopicId:self.topicId completion:^(NSArray<MFYArticle *> * _Nonnull articleList, NSError * _Nonnull error) {
        @strongify(self)
        self.NewDataCount = articleList.count;
         if (articleList.count > 0) {
             if (self.dataList.count > 0) {
                self.dataList = [self.dataList arrayByAddingObjectsFromArray:articleList];
             }else {
                 self.dataList = [articleList copy];
             }
         }else{
             [WHHud hideActivityView];
         }
    }];
}


@end
