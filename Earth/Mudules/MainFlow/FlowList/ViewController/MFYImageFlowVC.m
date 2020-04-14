//
//  MFYCategoryListVC.m
//  Earth
//
//  Created by colr on 2019/12/26.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYImageFlowVC.h"
#import "MFYFlowListVM.h"
#import "MFYFlowCardView.h"
#import "MFYCFToolView.h"
#import "MFYCoreflowTag.h"
#import "MFYCategoryTitleView.h"
#import "MFYIndicatorBackgroundView.h"
#import "MFYArticleService.h"
#import "MFYSingleChatVC.h"
#import "MFYPayCardView.h"
#import "MFYCategroyFlowTopView.h"
#import "MFYCoreFlowCategroyVC.h"
#import "MFYProfessView.h"
#import "MFYEmptyView.h"

@interface MFYImageFlowVC ()<YHDragCardDelegate,YHDragCardDataSource,JXCategoryViewDelegate>

@property (nonatomic, assign) YHDragCardDirectionType awayDirection;
@property (nonatomic, strong) YHDragCardContainer *card;
@property (nonatomic, strong) MFYFlowListVM * viewModel;
@property (nonatomic, strong) MFYCFToolView * toolView;
@property (nonatomic, strong) MFYFlowCardView * currentCard;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) MFYCategoryTitleView * myCategoryView;
@property (nonatomic, strong) MFYCategroyFlowTopView * topView;

@property (nonatomic, assign) MFYImageFlowType type;

@end

@implementation MFYImageFlowVC

- (instancetype)initWithType:(MFYImageFlowType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindData];
    [self bindEvents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startPlayVideo];
    [self.myCategoryView selectItemAtIndex:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopVideoPlay];
}

- (void)setupViews {
    [self.view addSubview:self.card];
    [self.view addSubview:self.toolView];
    
    [self.view addSubview:self.myCategoryView];
    [self.view addSubview:self.topView];

    NSMutableArray * titleArr = [NSMutableArray array];
    for (MFYCoreflowTag * tag in self.imageTagArray) {
        [titleArr addObject:tag.value];
    }
    self.myCategoryView.titles = titleArr;
    MFYIndicatorBackgroundView *lineView = [[MFYIndicatorBackgroundView alloc] init];
    self.myCategoryView.indicators = @[lineView];
    
    self.topView.hidden = self.type == MFYImageFlowMainType;
    self.myCategoryView.hidden = self.type != MFYImageFlowMainType;
    [self.topView setFlowTag:[self.imageTagArray firstObject]];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.myCategoryView setFrame:CGRectMake(0, 10, VERTICAL_SCREEN_WIDTH, 50)];
    [self.topView setFrame:CGRectMake(0, 10, VERTICAL_SCREEN_WIDTH, 50)];
}

- (void)bindData {
    @weakify(self)
    self.currentCard = 0;
    RACSignal * tagObserve = RACObserve(self, imageTagArray);
    [[tagObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.imageTagArray.count > 0;
    }] subscribeNext:^(id x) {
        @strongify(self)
        MFYCoreflowTag * tag = [self.imageTagArray firstObject];
        self.viewModel = [[MFYFlowListVM alloc]initWithTopicId:tag.idField];
        [self setupViews];
    }];
    
    RACSignal * dataObserve = RACObserve(self, viewModel.dataList);
    
    [[[dataObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.viewModel.dataList.count > 0;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.card reloadData:NO];
    }];
    
    RACSignal * emptyObserve = RACObserve(self, viewModel.NewDataCount);
    [[[emptyObserve skipUntilBlock:^BOOL(id x) {
        @strongify(self)
        return self.viewModel.NewDataCount == 0;
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [MFYEmptyView showInView:self.view refreshBlock:^{
            @strongify(self)
            [self.viewModel refreshData];
            [WHHud showActivityView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [WHHud hideActivityView];
            });
        }];
    }];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheArticleList:) name:MFYNotificationPublishImageSuccess object:nil];
}

- (void)bindEvents {
    @weakify(self)
    [self.toolView setTapLikeBlock:^(BOOL like) {
        @strongify(self)
        NSString * articleId = self.currentCard.model.articleId;
        if (!articleId) {
            [WHHud showString:@"动态审核中.."];
            return;
        }
        [MFYArticleService postLikeArticle:articleId isLike:like Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            if (error) {
                [WHHud showString:error.descriptionFromServer];
            }
        }];
        YHDragCardDirectionType direction = like ? YHDragCardDirectionTypeRight : YHDragCardDirectionTypeLeft;
        [self.card nextCard:direction];
    }];
    
    [self.toolView setTapMessageBlock:^(BOOL tap) {
        @strongify(self)
        MFYArticle * article = self.currentCard.model;
        if (!article.articleId) {
            [WHHud showString:@"动态审核中.."];
            return;
        }
        [WHHud showActivityView];
        [MFYRechargeService getTheProfessStatusCompletion:^(CGFloat price, NSError * _Nonnull error) {
            [WHHud hideActivityView];
            if (!error) {
                if (price < 0) {
                    [WHHud showString:@"系统错误"];
                    return;
                }
                [MFYProfessView showTheProfessView:article Price:price Completion:^(BOOL success) {
                }];
            }else{
               [WHHud showString:error.descriptionFromServer];
            }
        }];
    }];
    
    [self.toolView setTapBeforeBlock:^(BOOL tap) {
       @strongify(self)
        //先判断用户可以重读次数
        NSInteger index = self.currentIndex - 1;
        if (index < 0) {
            [WHHud showString:@"目前是第一张"];
            return;
        }
        MFYArticle * article = self.viewModel.dataList[index];
        if (!article.articleId) {
            [WHHud showString:@"动态审核中.."];
            return;
        }
        [WHHud showActivityView];
        [MFYArticleService rereadArticle:article.articleId Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            [WHHud hideActivityView];
            @strongify(self)
            if (!error) {
                if (isSuccess) {
                    //重读上一张
                    [self revokeCard];
                }else {
                    //充值弹窗
                    [MFYPayCardView showTheBeforeCard:article Completion:^(BOOL payed) {
                        @strongify(self)
                        [self revokeCard];
                    }];
                }
            }else {
                [WHHud showString:error.descriptionFromServer];
            }
        }];
    }];

}

-(void)refreshTheArticleList:(NSNotification *)notification {
    if ([notification.name isEqualToString:MFYNotificationPublishImageSuccess]) {
        [self.viewModel refreshData];
    }
}

- (UIView *)listView {
    return self.view;
}

#pragma mark- YHDDataSource

-(int)numberOfCountInDragCard:(YHDragCardContainer *)dragCard {
    return (int)self.viewModel.dataList.count;
}

- (UIView *)dragCard:(YHDragCardContainer *)dragCard indexOfCard:(int)index {
    MFYFlowCardView * cardView = [[MFYFlowCardView alloc]initWithFrame:dragCard.bounds];
    MFYArticle * article = self.viewModel.dataList[index];
    [cardView setModel:article];
    return cardView;
}

#pragma mark YHDragCardDelegate
- (void)dragCard:(YHDragCardContainer *)dragCard didDisplayCard:(UIView *)card withIndex:(int)index{
    WHLog(@"索引为%d的卡片正在展示", index);
    self.currentIndex = index;
    MFYFlowCardView * cardView = (MFYFlowCardView*)card;
    self.currentCard = cardView;
    MFYArticle * article = self.viewModel.dataList[index];
    if (self.currentCard && article) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.currentCard mfy_startPlay];
        });
    }
}

- (void)dragCard:(YHDragCardContainer *)dragCard didSlectCard:(UIView *)card withIndex:(int)index{
//    WHLog(@"点击卡片索引:%d", index);
}

- (void)dragCard:(YHDragCardContainer *)dragCard didRemoveCard:(UIView *)card withIndex:(int)index{
    WHLog(@"索引为%d的卡片滑出去了", index);
    if (self.currentCard) {
        [self.currentCard mfy_stopPlay];
    }
}

- (void)dragCard:(YHDragCardContainer *)dragCard didFinishRemoveLastCard:(UIView *)card{
    WHLog(@"最后一张卡片滑出去了");
    [WHHud showString:@"新的一波内容正在路上..."];
    [self.viewModel refreshData];
}

- (void)dragCard:(YHDragCardContainer *)dragCard currentCard:(UIView *)card withIndex:(int)index currentCardDirection:(YHDragCardDirection *)direction canRemove:(BOOL)canRemove{
    if (direction.horizontal > 0) {
        self.awayDirection = direction.horizontal;
    }
    CGFloat ratio = ABS(direction.horizontalRatio) * 0.3 + 1.0;
    CGFloat alphaRatio = ABS(direction.horizontalRatio);
    //左滑不喜欢，右滑喜欢
    if (self.awayDirection == YHDragCardDirectionTypeLeft) {
        self.toolView.dislikeBtn.transform = CGAffineTransformMakeScale(ratio, ratio);
        self.currentCard.dislikeIcon.alpha = alphaRatio;
    }
    if (self.awayDirection == YHDragCardDirectionTypeRight) {
        self.toolView.likeBtn.transform = CGAffineTransformMakeScale(ratio, ratio);
        self.currentCard.likeIcon.alpha = alphaRatio;
    }
//    WHLog(@"%ld", self.awayDirection);
}

- (void)revokeCard {
    [self.card revoke:self.awayDirection];
}

#pragma mark- 视频控制

- (void)stopVideoPlay {
    if (self.currentCard != nil) {
        [self.currentCard mfy_stopPlay];
    }
}

- (void)startPlayVideo {
    if (self.currentCard != nil) {
        [self.currentCard mfy_startPlay];
    }
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (index == 0) {
        return;
    }
    MFYCoreflowTag * flowTag = self.imageTagArray[index];
    MFYCoreFlowCategroyVC * flowVC = [[MFYCoreFlowCategroyVC alloc]init];
    flowVC.tagImageArray = @[flowTag];
    flowVC.tagAudioArray = @[flowTag];
    flowVC.selectIndex = 0;
    [self.navigationController pushViewController:flowVC animated:YES];
    
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


#pragma mark Getter
- (YHDragCardContainer *)card{
    if (!_card) {
        _card = [[YHDragCardContainer alloc] initWithFrame:CGRectMake(12, 70, VERTICAL_SCREEN_WIDTH -24, H_SCALE(400))];
        _card.minScale = 0.9;
        _card.delegate = self;
        _card.dataSource = self;
        _card.removeDirection = YHDragCardRemoveDirectionHorizontal;
        _card.infiniteLoop = NO;
    }
    return _card;
}

- (MFYCFToolView *)toolView {
    if (!_toolView) {
        _toolView = [[MFYCFToolView alloc]initWithFrame:CGRectMake(W_SCALE(8), self.card.wh_bottom + 30, VERTICAL_SCREEN_WIDTH - W_SCALE(16), 85)];
    }
    return _toolView;
}

-(JXCategoryTitleView *)myCategoryView {
    if (!_myCategoryView) {
        _myCategoryView = [[MFYCategoryTitleView alloc]init];
        _myCategoryView.delegate = self;
    }
    return _myCategoryView;
}

- (MFYCategroyFlowTopView *)topView {
    if (!_topView) {
        _topView = [[MFYCategroyFlowTopView alloc]init];
    }
    return _topView;
}

@end
