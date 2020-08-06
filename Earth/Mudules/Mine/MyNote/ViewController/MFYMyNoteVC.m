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
#import "MFYMineService.h"
#import "MFYAddTagView.h"

@interface MFYMyNoteVC ()

@property (nonatomic, strong)MFYMyNoteVM * viewModel;

@property (nonatomic, strong)MFYMyLikeDisplayView * displayView;

@property (nonatomic, strong)MFYTagDisplayView * tagView;

@property (nonatomic, strong)MFYTimeLineView * timelineView;

@property (nonatomic, strong)UIView * lineView;

@property (nonatomic, strong)UILabel * idLabel;

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
    [self.view addSubview:self.idLabel];
        
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
    
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timelineView.mas_bottom).offset(35);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
}

- (void)bindEvents {
    @weakify(self)
    [self.timelineView setItemBlock:^(NSInteger index) {
        @strongify(self)
        [self.displayView mfy_scrollToItem:index];
    }];
    
    [self.displayView setScrollBlock:^(NSInteger index) {
       @strongify(self)
        WHLog(@"滑到的下标%ld",index);
        [self.timelineView mfy_didScrollToItem:index];
    }];
    
    [self.tagView setAddTagBlock:^{
       @strongify(self)
        [self mfy_addTag];
    }];
    
    [self.tagView setDeleteTagBlock:^(NSString * _Nonnull tagStr) {
        @strongify(self)
        [self mfy_deleteTag:tagStr];
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
       @strongify(self)
        [self copyTheIDNum];
    }];
    [self.idLabel addGestureRecognizer:tap];
}

- (void)bindData {
    @weakify(self)
    RACSignal * dataObserve = RACObserve(self, viewModel.dataList);
    
    [[[dataObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.viewModel.dataList.count > 0;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        self.displayView.requesting = NO;
        [self.displayView reloadDataWithArray:self.viewModel.dataList];
        [self.timelineView setArticleArr:self.viewModel.dataList];
    }];
    
    RACSignal * tagObserve = RACObserve(self, viewModel.tagList);
    
    [[[tagObserve skipUntilBlock:^BOOL(id x) {
        return YES;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        NSMutableArray * arr = [NSMutableArray arrayWithArray:self.viewModel.tagList];
        [arr addObject:MFYTagAddSingal];
        [self.tagView setTags:[arr copy]];
    }];
    
    [self.displayView setOnFooterRefresh:^{
       @strongify(self)
        [self.viewModel loadMoreData];
    }];
}

- (void)startPlayVideo {
    [self.displayView playTheMedia];
}

- (void)stopVideoPlay {
    [self.displayView stopTheMedia];
}

- (void)mfy_addTag {
    @weakify(self)
    [MFYAddTagView showWithCompletion:^(BOOL needRefreshTag) {
        if (needRefreshTag) {
            @strongify(self)
            [self.viewModel refreshTheTag];
        }
    }];
}

- (void)mfy_deleteTag:(NSString *)tagStr {
    @weakify(self)
    [[WHAlertTool shareInstance] showAlterViewDeleteWithTitle:@"提示" message:FORMAT(@"是否删除标签“%@”",tagStr) deleteBlock:^(UIAlertAction * _Nonnull action) {
        [MFYMineService postModifyTag:tagStr isremove:YES Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            if (isSuccess) {
                @strongify(self)
                [self.viewModel refreshTheTag];
            }else {
                [WHHud showString:error.descriptionFromServer];
            }
        }];
    }];
}

#pragma mark- 复制id
- (void)copyTheIDNum {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.profile.userId;
    [WHHud showString:@"朋友ID复制成功"];
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

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = UILabel.label.WH_font(WHFont(14)).WH_textColor(wh_colorWithHexString(@"#939399"));
        _idLabel.numberOfLines = 0;
        _idLabel.userInteractionEnabled = YES;
        _idLabel.WH_text(FORMAT(@"朋友ID：%@",self.profile.userId));
    }
    return _idLabel;;
}


@end
