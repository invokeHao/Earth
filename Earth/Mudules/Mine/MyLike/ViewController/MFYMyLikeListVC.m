//
//  MFYMyLikeListVC.m
//  Earth
//
//  Created by colr on 2020/2/22.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMyLikeListVC.h"
#import "MFYMyLikeVM.h"
#import "MFYMyLikeDisplayView.h"

@interface MFYMyLikeListVC ()

@property (nonatomic, strong)MFYMyLikeVM * viewModel;

@property (nonatomic, strong)MFYMyLikeDisplayView * displayView;

@property (nonatomic, strong) UIButton * professBtn;

@end

@implementation MFYMyLikeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
    [self bindData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startPlayVideo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopVideoPlay];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"我喜欢的";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.view.backgroundColor = wh_colorWithHexString(@"#FFFFFF");
    self.viewModel = [[MFYMyLikeVM alloc]init];
    
    [self.view addSubview:self.displayView];
    [self.view addSubview:self.professBtn];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.displayView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + 55, VERTICAL_SCREEN_WIDTH, H_SCALE(368))];
    [self.professBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(53);
    }];
}


- (void)bindEvents {
    [[self.professBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        WHLog(@"表白");
    }];
}

- (void)bindData {
    @weakify(self)
    RACSignal * dataObserve = RACObserve(self, viewModel.dataList);
    
    [[[dataObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.viewModel.dataList.count > 0;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.displayView reloadDataWithArray:self.viewModel.dataList];
    }];
    
}

- (void)startPlayVideo {
    [self.displayView playTheMedia];
}

- (void)stopVideoPlay {
    [self.displayView stopTheMedia];
}

- (MFYMyLikeDisplayView *)displayView {
    if (!_displayView) {
        _displayView = [[MFYMyLikeDisplayView alloc]init];
    }
    return _displayView;
}

- (UIButton *)professBtn {
    if (!_professBtn) {
        _professBtn = UIButton.button.WH_titleLabel_font(WHFont(18));
        _professBtn.WH_setTitle_forState(@"表白",UIControlStateNormal);
        _professBtn.WH_setTitleColor_forState(wh_colorWithHexString(@"FFFFFF"),UIControlStateNormal);
        _professBtn.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    }
    return _professBtn;
}


@end
