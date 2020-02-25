//
//  MFYMyNoteVM.m
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMyNoteVM.h"
#import "MFYArticle.h"
#import "MFYCoreflowService.h"

@interface MFYMyNoteVM ()

@property (nonatomic, strong) NSMutableArray<MFYArticle *> * dataList;

@property (nonatomic, assign) NSInteger NewDataCount;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation MFYMyNoteVM

-(instancetype)init {
    self = [super init];
    if (self) {
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
    [MFYCoreflowService getMyPostCardListWithPage:self.currentPage completion:^(NSArray<MFYArticle *> * _Nonnull aritlceList, NSError * _Nonnull error) {
        @strongify(self)
        self.NewDataCount = aritlceList.count;
         if (aritlceList.count > 0) {
             self.dataList = [aritlceList copy];
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
