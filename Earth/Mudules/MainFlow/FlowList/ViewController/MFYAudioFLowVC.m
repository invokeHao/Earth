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
#import "MFYAudioPublishView.h"

@interface MFYAudioFLowVC ()<JXCategoryViewDelegate>

@property (nonatomic, strong) MFYCategoryTitleView * myCategoryView;

@property (nonatomic, strong) MFYAudioDisplayView * displayView;

@property (nonatomic, strong) MFYAudioListVM * viewModel;

@property (nonatomic, strong) UIButton * publishBtn;

@property (nonatomic, strong) MFYAudioPublishView * publishView;

@end

@implementation MFYAudioFLowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.displayView playTheAudio];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.displayView stopTheAudio];
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
    
    
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-(HOME_INDICATOR_HEIGHT + 10 ));
        make.size.mas_equalTo(CGSizeMake(W_SCALE(90), W_SCALE(90)));
    }];
}

- (void)setupTitleView {
    NSMutableArray * titleArr = [NSMutableArray array];
    for (MFYCoreflowTag * tag in self.audioTagArray) {
        [titleArr addObject:tag.value];
    }
    self.myCategoryView.titles = titleArr;
    MFYIndicatorBackgroundView *lineView = [[MFYIndicatorBackgroundView alloc] init];
    self.myCategoryView.indicators = @[lineView];
}

- (UIView *)listView {
    return self.view;
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
        [self setupTitleView];
    }];
    
    RACSignal * dataObserve = RACObserve(self, viewModel.dataList);
    
    [[[[dataObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.viewModel.dataList.count > 0;
    }] deliverOnMainThread] delay:0.2] subscribeNext:^(id x) {
        @strongify(self)
        [self.displayView reloadDataWithArray:self.viewModel.dataList];
    }];
    
    [[self.publishBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        [self.publishView showInView];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheArticleList:) name:MFYNotificationPublishAudioSuccess object:nil];
}

-(void)refreshTheArticleList:(NSNotification *)notification {
    if ([notification.name isEqualToString:MFYNotificationPublishAudioSuccess]) {
        [self.viewModel refreshData];
    }
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

- (MFYAudioPublishView *)publishView {
    if (!_publishView) {
        _publishView = [[MFYAudioPublishView alloc]initWithFrame:CGRectMake(0, 0, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT)];
    }
    return _publishView;
}
@end
