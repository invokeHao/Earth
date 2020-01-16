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

@interface MFYCoreFlowVC ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
{
    BOOL _disableDrag;
}

@property (nonatomic, strong) YHDragCardContainer * cardView;
@property (nonatomic, assign) YHDragCardDirectionType awayDirection;
@property (nonatomic, strong) MFYCategoryTitleView * myCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView * listContainerView;


@end

@implementation MFYCoreFlowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.view.backgroundColor = [UIColor whiteColor];
    self.myCategoryView.listContainer = self.listContainerView;
    self.myCategoryView.delegate = self;
    [self.view addSubview:self.myCategoryView];
    [self.view addSubview:self.listContainerView];
    NSArray * array = @[@"全部", @"颜控", @"人气", @"活跃", @"朋友"];
    self.myCategoryView.titles = array;
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
    WHLogSuccess(@"%@",vc);
    return vc;
}

-(NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 5;
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
    }
    return _listContainerView;
}


@end
