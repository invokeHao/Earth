//
//  MFYMyNoteVC.m
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMyNoteVC.h"
#import "MFYMyNoteVM.h"
#import "MFYMyLikeDisplayView.h"
#import "MFYTagDisplayView.h"
#import "MFYTimeLineView.h"
#import "MFYTagDisplayLayout.h"

@interface MFYMyNoteVC ()

@property (nonatomic, strong)MFYMyNoteVM * viewModel;

@property (nonatomic, strong)MFYMyLikeDisplayView * displayView;

@property (nonatomic, strong)MFYTagDisplayView * tagView;

@property (nonatomic, strong)MFYTimeLineView * timelineView;

@property (nonatomic, strong)UIView * lineView;

@end

@implementation MFYMyNoteVC

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
    self.navBar.titleLabel.text = @"我的日记";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.view.backgroundColor = wh_colorWithHexString(@"#FFFFFF");
    
    [self.view addSubview:self.tagView];
    [self.view addSubview:self.displayView];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.timelineView];
        
    self.viewModel = [[MFYMyNoteVM alloc]init];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.displayView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + 55, VERTICAL_SCREEN_WIDTH, H_SCALE(368))];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 + NAVIGATION_BAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(28);
    }];
    
    [self.timelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.displayView.mas_bottom).offset(35);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timelineView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(1);
    }];

}

- (void)bindEvents {
    NSArray * tagArr = @[@"美女",@"条纹控",@"喜欢怪蜀黍",@"爱吃红烧肉",@"skr",@"00后黄金一代"];
    [self.tagView setTags:tagArr];
    
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
        [self.timelineView setArticleArr:self.viewModel.dataList];
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

- (MFYTimeLineView *)timelineView {
    if (!_timelineView) {
        MFYTagDisplayLayout *layout = [[MFYTagDisplayLayout alloc] initWthType:AlignWithLeft];
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _timelineView = [[MFYTimeLineView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _timelineView.bounces = NO;
    }
    return _timelineView;
}

- (MFYTagDisplayView *)tagView {
    if (!_tagView) {
        MFYTagDisplayLayout *layout = [[MFYTagDisplayLayout alloc] initWthType:AlignWithLeft];
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _tagView = [[MFYTagDisplayView alloc] initWithFrame:CGRectZero
                                        collectionViewLayout:layout];
        _tagView.tagColor = wh_colorWithHexString(@"#FF3F70");
        _tagView.backgroundColor = [UIColor clearColor];
        _tagView.bounces = NO;
        @weakify(self);
        [_tagView setShouldUpdateHeight:^(CGFloat width){
            @strongify(self);
            if (width > 28) {
                width = 28;
            }
            [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {

            }];
        }];
    }
    return _tagView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = wh_colorWithHexString(@"#DCDCE6");
    }
    return _lineView;
}


@end
