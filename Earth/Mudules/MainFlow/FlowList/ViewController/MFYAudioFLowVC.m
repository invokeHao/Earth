//
//  MFYAudioFLowVC.m
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAudioFLowVC.h"
#import "MFYCategoryTitleView.h"
#import "MFYCoreflowTag.h"
#import "MFYIndicatorBackgroundView.h"
#import "MFYCoreflowTag.h"
#import "MFYAudioDisplayView.h"
#import "MFYAudioListVM.h"

@interface MFYAudioFLowVC ()<JXCategoryViewDelegate>

@property (nonatomic, strong) MFYCategoryTitleView * myCategoryView;

@property (nonatomic, strong) MFYAudioDisplayView * displayView;

@property (nonatomic, strong) MFYAudioListVM * viewModel;

@property (nonatomic, strong) UIButton * publishBtn;

@end

@implementation MFYAudioFLowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindEvents];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.myCategoryView setFrame:CGRectMake(0, 10, VERTICAL_SCREEN_WIDTH, 50)];
    [self.displayView setFrame:CGRectMake(0, 60, VERTICAL_SCREEN_WIDTH, H_SCALE(440))];
}

- (void)setupViews {
    self.view.backgroundColor = wh_colorWithHexString(@"#F0F0F0");
    [self.view addSubview:self.myCategoryView];
    [self.view addSubview:self.displayView];
    [self.view addSubview:self.publishBtn];
    
    NSMutableArray * titleArr = [NSMutableArray array];
    for (MFYCoreflowTag * tag in self.audioTagArray) {
        [titleArr addObject:tag.value];
    }
    self.myCategoryView.titles = titleArr;
    MFYIndicatorBackgroundView *lineView = [[MFYIndicatorBackgroundView alloc] init];
    self.myCategoryView.indicators = @[lineView];
    
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-(HOME_INDICATOR_HEIGHT + 10 ));
        make.size.mas_equalTo(CGSizeMake(W_SCALE(90), W_SCALE(90)));
    }];
}

- (void)bindEvents {
    @weakify(self)
    RACSignal * tagObserve = RACObserve(self, audioTagArray);
    [[tagObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.audioTagArray.count > 0;
    }] subscribeNext:^(id x) {
        @strongify(self)
        MFYCoreflowTag * tag = [self.audioTagArray firstObject];
        self.viewModel = [[MFYAudioListVM alloc]initWithTopicId:tag.idField];
        [self setupViews];
    }];
    
    RACSignal * dataObserve = RACObserve(self, viewModel.dataList);
    
    [[[dataObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.viewModel.dataList.count > 0;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.displayView reloadDataWithArray:self.viewModel.dataList];
    }];
}

- (UIView *)listView {
    return self.view;
}


#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {

    WHLog(@"%d",index);
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


-(JXCategoryTitleView *)myCategoryView {
    if (!_myCategoryView) {
        _myCategoryView = [[MFYCategoryTitleView alloc]init];
        _myCategoryView.delegate = self;
    }
    return _myCategoryView;
}

- (MFYAudioDisplayView *)displayView {
    if (!_displayView) {
        _displayView = [[MFYAudioDisplayView alloc]init];
    }
    return _displayView;
}

- (UIButton *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = UIButton.button;
        [_publishBtn setImage:WHImageNamed(@"audio_publish") forState:UIControlStateNormal];
    }
    return _publishBtn;
}
@end
