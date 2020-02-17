//
//  MFYCoreFlowVC.m
//  Earth
//
//  Created by colr on 2019/12/23.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYCoreFlowVC.h"
#import "MFYImageFlowVC.h"
#import "MFYAudioFLowVC.h"
#import "MFYIndicatorBackgroundView.h"
#import "MFYCategoryTitleView.h"
#import "MFYNavCategoryTitleView.h"
#import "MFYTopicTagService.h"

@interface MFYCoreFlowVC ()<JXCategoryListContainerViewDelegate>
{
    BOOL _disableDrag;
}

@property (nonatomic, strong) YHDragCardContainer * cardView;
@property (nonatomic, assign) YHDragCardDirectionType awayDirection;
@property (nonatomic, strong) MFYNavCategoryTitleView * navCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView * listContainerView;
@property (nonatomic, strong) NSArray * tagImageArray;
@property (nonatomic, strong) NSArray * tagAudioArray;
@property (nonatomic, strong) UIButton * MineBtn;
@property (nonatomic, strong) UIButton * messageBtn;

@end

@implementation MFYCoreFlowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self bindEvents];
}

- (void)setupViews {
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.navBar.leftButton = self.MineBtn;
    self.navBar.rightButton = self.messageBtn;
    [self.navBar addSubview:self.navCategoryView];
    
    self.navCategoryView.listContainer = self.listContainerView;
    [self.view addSubview:self.listContainerView];
    self.navCategoryView.titles = @[@"颜控",@"声控"];

}

- (void)bindEvents {
    RACSignal * tagObserve = RACObserve(self, tagImageArray);
    @weakify(self)
     [[tagObserve skipUntilBlock:^BOOL(id x) {
         @strongify(self)
         return self.tagImageArray.count > 0 && self.tagAudioArray.count > 0;
     }] subscribeNext:^(id x) {
         @strongify(self)
         [self setupViews];
     }];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.listContainerView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT - 50)];
    [self.navCategoryView setFrame:CGRectMake((VERTICAL_SCREEN_WIDTH - 180) / 2, STATUS_BAR_HEIGHT + 8, 180, 30)];
}



#pragma mark- JXCategoryListContentViewDelegate
 - (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index{
     if (index == 0) {
         MFYImageFlowVC * vc = [[MFYImageFlowVC alloc]init];
         vc.imageTagArray = self.tagImageArray;
         return vc;
     }else {
         MFYAudioFLowVC * vc = [[MFYAudioFLowVC alloc]init];
         vc.audioTagArray = self.tagAudioArray;
         return vc;
     }
}

-(NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 2;
}

#pragma mark- 获取标签

- (void)setupData {
    @weakify(self)
    [MFYTopicTagService getTheImageTopicTagsCompletion:^(NSArray<MFYCoreflowTag *> * _Nonnull array, NSError * _Nonnull error) {
        @strongify(self)
        if (!error) {
            self.tagImageArray = array;
            [self setupViews];
        }else{
            [WHHud showString:error.descriptionFromServer];
        }
    }];
    
    [MFYTopicTagService getTheaudioTopicTagsCompletion:^(NSArray<MFYCoreflowTag *> * _Nonnull array, NSError * _Nonnull error) {
        if (!error) {
            self.tagAudioArray = array;
        }else{
            [WHHud showString:error.descriptionFromServer];
        }
    }];
}

-(JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc]initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.scrollView.scrollEnabled = NO;
    }
    return _listContainerView;
}

- (UIButton *)MineBtn {
    if (!_MineBtn) {
        _MineBtn = UIButton.button;
        [_MineBtn setImage:WHImageNamed(@"core_mine") forState:UIControlStateNormal];
    }
    return _MineBtn;
}

- (UIButton *)messageBtn {
    if (!_messageBtn) {
        _messageBtn = UIButton.button;
        [_messageBtn setImage:WHImageNamed(@"core_notification") forState:UIControlStateNormal];
    }
    return _messageBtn;
}

- (MFYNavCategoryTitleView *)navCategoryView {
    if (!_navCategoryView) {
        _navCategoryView = [[MFYNavCategoryTitleView alloc]init];
    }
    return  _navCategoryView;
}


@end
