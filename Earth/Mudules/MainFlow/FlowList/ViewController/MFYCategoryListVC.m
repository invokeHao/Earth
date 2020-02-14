//
//  MFYCategoryListVC.m
//  Earth
//
//  Created by colr on 2019/12/26.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYCategoryListVC.h"
#import "MFYFlowListVM.h"
#import "MFYFlowCardView.h"
#import "MFYCFToolView.h"

@interface MFYCategoryListVC ()<YHDragCardDelegate,YHDragCardDataSource>

@property (nonatomic, assign) YHDragCardDirectionType awayDirection;
@property (nonatomic, strong) YHDragCardContainer *card;
@property (nonatomic, strong) MFYFlowListVM * viewModel;
@property (nonatomic, strong) MFYCFToolView * toolView;
@property (nonatomic, strong) MFYFlowCardView * currentCard;

@end

@implementation MFYCategoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupViews];
    [self startPlayVideo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopVideoPlay];
}

- (void)setupViews {
    [self.view addSubview:self.card];
    [self.view addSubview:self.toolView];
}

- (void)bindData {
    self.viewModel = [[MFYFlowListVM alloc]initWithTopicId:self.topicId];
    
    RACSignal * dataObserve = RACObserve(self, viewModel.dataList);
    @weakify(self)
    [[[dataObserve skipUntilBlock:^BOOL(id x) {
        return [x isKindOfClass:[NSArray class]];
    }] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        [self.card reloadData:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheArticleList:) name:MFYNotificationPublishSuccess object:nil];

}

-(void)refreshTheArticleList:(NSNotification *)notification {
    if ([notification.name isEqualToString:MFYNotificationPublishSuccess]) {
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
//    WHLog(@"最后一张卡片滑出去了");

}

- (void)dragCard:(YHDragCardContainer *)dragCard currentCard:(UIView *)card withIndex:(int)index currentCardDirection:(YHDragCardDirection *)direction canRemove:(BOOL)canRemove{
//    CGFloat ratio = ABS(direction.horizontalRatio) * 0.2 + 1.0;
//    self.stateView.transform = CGAffineTransformMakeScale(ratio, ratio);
//    if (direction.horizontal > 0) {
//        self.awayDirection = direction.horizontal;
//    }
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

#pragma mark Getter
- (YHDragCardContainer *)card{
    if (!_card) {
        _card = [[YHDragCardContainer alloc] initWithFrame:CGRectMake(12, 20, VERTICAL_SCREEN_WIDTH -24, H_SCALE(400))];
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



@end
