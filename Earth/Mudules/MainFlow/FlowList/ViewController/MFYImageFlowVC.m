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

@interface MFYImageFlowVC ()<YHDragCardDelegate,YHDragCardDataSource,JXCategoryViewDelegate>

@property (nonatomic, assign) YHDragCardDirectionType awayDirection;
@property (nonatomic, strong) YHDragCardContainer *card;
@property (nonatomic, strong) MFYFlowListVM * viewModel;
@property (nonatomic, strong) MFYCFToolView * toolView;
@property (nonatomic, strong) MFYFlowCardView * currentCard;
@property (nonatomic, strong) MFYCategoryTitleView * myCategoryView;


@end

@implementation MFYImageFlowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindData];
    [self bindEvents];
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
    [self.view addSubview:self.card];
    [self.view addSubview:self.toolView];
    
    [self.view addSubview:self.myCategoryView];

    NSMutableArray * titleArr = [NSMutableArray array];
    for (MFYCoreflowTag * tag in self.imageTagArray) {
        [titleArr addObject:tag.value];
    }
    self.myCategoryView.titles = titleArr;
    MFYIndicatorBackgroundView *lineView = [[MFYIndicatorBackgroundView alloc] init];
    self.myCategoryView.indicators = @[lineView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.myCategoryView setFrame:CGRectMake(0, 10, VERTICAL_SCREEN_WIDTH, 50)];
}

- (void)bindData {
    @weakify(self)
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheArticleList:) name:MFYNotificationPublishImageSuccess object:nil];
}

- (void)bindEvents {
    @weakify(self)
    [self.toolView setTapLikeBlock:^(BOOL like) {
        @strongify(self)
        NSString * articleId = self.currentCard.model.articleId;
        [MFYArticleService postLikeArticle:articleId isLike:like Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            if (error) {
                [WHHud showString:error.descriptionFromServer];
            }
        }];
        YHDragCardDirectionType direction = like ? YHDragCardDirectionTypeRight : YHDragCardDirectionTypeLeft;
        [self.card nextCard:direction];
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

}

- (void)dragCard:(YHDragCardContainer *)dragCard currentCard:(UIView *)card withIndex:(int)index currentCardDirection:(YHDragCardDirection *)direction canRemove:(BOOL)canRemove{
    if (direction.horizontal > 0) {
        self.awayDirection = direction.horizontal;
    }
    CGFloat ratio = ABS(direction.horizontalRatio) * 0.3 + 1.0;
    //左滑不喜欢，右滑喜欢
    if (self.awayDirection == YHDragCardDirectionTypeLeft) {
        self.toolView.dislikeBtn.transform = CGAffineTransformMakeScale(ratio, ratio);
    }
    if (self.awayDirection == YHDragCardDirectionTypeRight) {
        self.toolView.likeBtn.transform = CGAffineTransformMakeScale(ratio, ratio);
    }
//    WHLog(@"%ld", self.awayDirection);
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

    WHLog(@"%d",index);
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
        _card.infiniteLoop = YES;
    }
    return _card;
}

- (MFYCFToolView *)toolView {
    if (!_toolView) {
        _toolView = [[MFYCFToolView alloc]initWithFrame:CGRectMake(18, self.card.wh_bottom + 30, VERTICAL_SCREEN_WIDTH - 36, 60)];
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



@end
