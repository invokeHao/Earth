//
//  MFYCoreFlowCategroyVC.m
//  Earth
//
//  Created by colr on 2020/3/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYCoreFlowCategroyVC.h"
#import "MFYImageFlowVC.h"
#import "MFYAudioFLowVC.h"
#import "MFYIndicatorBackgroundView.h"
#import "MFYCategoryTitleView.h"
#import "MFYNavCategoryTitleView.h"
#import "MFYTopicTagService.h"
#import "MFYMineHomePageVC.h"
#import "MFYChatListVC.h"


@interface MFYCoreFlowCategroyVC ()<JXCategoryListContainerViewDelegate>

{
    BOOL _disableDrag;
}

@property (nonatomic, strong) MFYNavCategoryTitleView * navCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView * listContainerView;

@property (nonatomic, strong) UIButton * messageBtn;

@end

@implementation MFYCoreFlowCategroyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindEvents];
}

- (void)setupViews {
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
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
        
    [[self.messageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        MFYChatListVC * chatListVC = [[MFYChatListVC alloc]init];
        [self.navigationController pushViewController:chatListVC animated:YES];
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
         MFYImageFlowVC * vc = [[MFYImageFlowVC alloc]initWithType:MFYImageFlowCategroyType];
         vc.imageTagArray = self.tagImageArray;
         return vc;
     }else {
         MFYAudioFLowVC * vc = [[MFYAudioFLowVC alloc]initWithType:MFYAudioFlowCategroyType];
         vc.audioTagArray = self.tagAudioArray;
         return vc;
     }
}

-(NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 2;
}


-(JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc]initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _listContainerView.scrollView.scrollEnabled = NO;
    }
    return _listContainerView;
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
