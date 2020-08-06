//
//  MFYPurchasedVM.m
//  Earth
//
//  Created by colr on 2020/3/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPurchasedVM.h"
#import "MFYCoreflowService.h"

@interface MFYPurchasedVM ()

@property (nonatomic, strong) NSArray<MFYItem *> * dataList;

@property (nonatomic, assign) NSInteger NewDataCount;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation MFYPurchasedVM

-(instancetype)init {
    self = [super init];
    if (self) {
        _currentPage = 1;
        [self setupData];
    }
    return self;
}

- (void)refreshData {
    [self setupData];
}

-(void)setupData {
    @weakify(self)
    [WHHud showActivityView];
    [MFYCoreflowService getMyPurchasedCardListWithPage:self.currentPage completion:^(NSArray<MFYItem *> * _Nonnull aritlceList, NSError * _Nonnull error) {
        [WHHud hideActivityView];
        @strongify(self)
        if (!error) {
            self.NewDataCount = aritlceList.count;
             if (aritlceList.count > 0) {
                 self.dataList = [aritlceList copy];
             }
        }
    }];
}

-(void)loadMoreData {
    @weakify(self)
    NSInteger page = self.currentPage + 1;
    [MFYCoreflowService getMyPurchasedCardListWithPage:page completion:^(NSArray<MFYItem *> * _Nonnull aritlceList, NSError * _Nonnull error) {
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
