//
//  MFYCoreFlowVC.m
//  Earth
//
//  Created by colr on 2019/12/23.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYCoreFlowVC.h"
#import "MFYCategoryListVC.h"
#import "MFYIndicatorBackgroundView.h"
#import "MFYCategoryTitleView.h"
#import "MFYTopicTagService.h"

@interface MFYCoreFlowVC ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
{
    BOOL _disableDrag;
}

@property (nonatomic, strong) YHDragCardContainer * cardView;
@property (nonatomic, assign) YHDragCardDirectionType awayDirection;
@property (nonatomic, strong) MFYCategoryTitleView * myCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView * listContainerView;
@property (nonatomic, strong) NSArray * tagArray;
@property (nonatomic, strong) UIButton * MineBtn;
@property (nonatomic, strong) UIButton * messageBtn;

@end

@implementation MFYCoreFlowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
}

- (void)setupViews {
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.navBar.leftButton = self.MineBtn;
    self.navBar.rightButton = self.messageBtn;
    self.myCategoryView.listContainer = self.listContainerView;
    self.myCategoryView.delegate = self;
    [self.view addSubview:self.myCategoryView];
    [self.view addSubview:self.listContainerView];
    NSMutableArray * titleArr = [NSMutableArray array];
    for (MFYCoreflowTag * tag in self.tagArray) {
        [titleArr addObject:tag.value];
    }
    self.myCategoryView.titles = titleArr;
    MFYIndicatorBackgroundView *lineView = [[MFYIndicatorBackgroundView alloc] init];
    self.myCategoryView.indicators = @[lineView];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.myCategoryView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+10, VERTICAL_SCREEN_WIDTH, 50)];
    [self.listContainerView setFrame:CGRectMake(0, CGRectGetMaxY(self.myCategoryView.frame), VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT - 50)];
}


#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {

    WHLog(@"%ld",index);
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark- JXCategoryListContentViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index{
    MFYCategoryListVC * vc = [[MFYCategoryListVC alloc]init];
    MFYCoreflowTag * tag =self.tagArray[index];
    vc.topicId = tag.idField;
    return vc;
}

-(NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 5;
}

#pragma mark- 获取标签

- (void)setupData {
    @weakify(self)
    [MFYTopicTagService getTheImageTopicTagsCompletion:^(NSArray<MFYCoreflowTag *> * _Nonnull array, NSError * _Nonnull error) {
        @strongify(self)
        if (!error) {
            self.tagArray = array;
            [self setupViews];
        }else{
            [WHHud showString:error.descriptionFromServer];
        }
    }];
}


-(JXCategoryTitleView *)myCategoryView {
    if (!_myCategoryView) {
        _myCategoryView = [[MFYCategoryTitleView alloc]init];
    }
    return _myCategoryView;
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


@end
