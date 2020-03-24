//
//  MFYMyPurchasedVC.m
//  Earth
//
//  Created by colr on 2020/3/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMyPurchasedVC.h"
#import "MFYBaseCollectionView.h"
#import "MFYFlowLayout.h"
#import "MFYPurchasedCell.h"
#import "MFYPurchasedVM.h"
#import "MFYImageDetailVC.h"
#import "MFYVideoDetailVC.h"

@interface MFYMyPurchasedVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic)MFYBaseCollectionView * MainCollection;

@property (strong, nonatomic)MFYPurchasedVM * viewModel;

@end

@implementation MFYMyPurchasedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindEvents];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.MainCollection setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, VERTICAL_SCREEN_WIDTH, VERTICAL_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT)];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"我购买的";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.view.backgroundColor = wh_colorWithHexString(@"#FFFFFF");
    [self.view addSubview:self.MainCollection];
}

- (void)bindEvents {
    
}

- (void)bindingData {
    self.viewModel = [[MFYPurchasedVM alloc]init];
    @weakify(self)
    RACSignal * dataObserve = RACObserve(self, viewModel.dataList);
    
    [[[dataObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.viewModel.dataList.count > 0;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.MainCollection reloadData];
    }];

}

- (MFYBaseCollectionView *)MainCollection {
    if (!_MainCollection) {
        MFYFlowLayout * layout = [[MFYFlowLayout alloc]init];
        _MainCollection = [[MFYBaseCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _MainCollection.backgroundColor = UIColor.whiteColor;
        _MainCollection.showsHorizontalScrollIndicator = NO;
        _MainCollection.showsVerticalScrollIndicator = NO;
        _MainCollection.delegate = self;
        _MainCollection.dataSource = self;
        [_MainCollection registerClass:[MFYPurchasedCell class] forCellWithReuseIdentifier:[MFYPurchasedCell reuseID]];
    }
    return _MainCollection;
}

#pragma mark- UICollection delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.dataList.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MFYPurchasedCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MFYPurchasedCell reuseID] forIndexPath:indexPath];
    MFYArticle * article = self.viewModel.dataList[indexPath.item];
    [cell setArticle:article];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //点击图片到图片详情
    MFYArticle * article = self.viewModel.dataList[indexPath.item];
    if ([article MFYmediaType] == MFYMediaPictureType) {
        MFYImageDetailVC * detailVC = [[MFYImageDetailVC alloc]init];
        detailVC.itemModel = (MFYItem *)article;
        [[WHAlertTool WHTopViewController].navigationController pushViewController:detailVC animated:YES];
    }
    //点击视频到视频详情
    if ([article MFYmediaType] == MFYMediavideoType) {
        MFYVideoDetailVC * videoVC = [[MFYVideoDetailVC alloc]init];
        videoVC.itemModel = (MFYItem *)article;
        [[WHAlertTool WHTopViewController].navigationController pushViewController:videoVC animated:YES];
    }

}



@end
