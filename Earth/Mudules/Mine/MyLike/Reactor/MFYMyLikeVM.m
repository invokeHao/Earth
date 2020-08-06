//
//  MFYMyLikeVM.m
//  Earth
//
//  Created by colr on 2020/2/22.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMyLikeVM.h"
#import "MFYCoreflowService.h"

@interface MFYMyLikeVM()

@property (nonatomic, strong) NSArray<MFYArticle *> * dataList;

@property (nonatomic, assign) NSInteger NewDataCount;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation MFYMyLikeVM

-(instancetype)init {
    self = [super init];
    if (self) {
        self.currentPage = 1;
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
    [MFYCoreflowService getMyLikeCardListWithPage:self.currentPage completion:^(NSArray<MFYArticle *> * _Nonnull aritlceList, NSError * _Nonnull error) {
        @strongify(self)
        self.NewDataCount = aritlceList.count;
         if (aritlceList.count > 0) {
             self.dataList = [aritlceList copy];
         }
    }];
}

-(void)loadMoreData {
    @weakify(self)
    NSInteger page = self.currentPage + 1;
    [MFYCoreflowService getMyLikeCardListWithPage:page completion:^(NSArray<MFYArticle *> * _Nonnull aritlceList, NSError * _Nonnull error) {
        if (!error) {
            @strongify(self)
            self.NewDataCount = aritlceList.count;
            if (aritlceList.count > 0) {
                self.currentPage = page;
                self.dataList = [self.dataList arrayByAddingObjectsFromArray:aritlceList];
            }
        }
    }];
}

@end
