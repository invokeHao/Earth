//
//  MFYMyLikeListVC.m
//  Earth
//
//  Created by colr on 2020/2/22.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMyLikeListVC.h"
#import "MFYMyLikeVM.h"

@interface MFYMyLikeListVC ()

@property (nonatomic, strong)MFYMyLikeVM * viewModel;


@end

@implementation MFYMyLikeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
    [self bindData];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"我喜欢的";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.view.backgroundColor = wh_colorWithHexString(@"#FFFFFF");
    self.viewModel = [[MFYMyLikeVM alloc]init];
}

- (void)bindEvents {
    
}

- (void)bindData {
    @weakify(self)
    RACSignal * dataObserve = RACObserve(self, viewModel.dataList);
    
    [[[dataObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.viewModel.dataList.count > 0;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        WHLog(@"%@",self.viewModel.dataList);
    }];
}

@end
