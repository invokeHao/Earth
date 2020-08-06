//
//  MFYImageCardCell.m
//  Earth
//
//  Created by colr on 2020/2/24.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYImageCardCell.h"
#import "MFYFlowCardView.h"

@interface MFYImageCardCell()

@property (nonatomic, strong)MFYFlowCardView * cardView;

@end

@implementation MFYImageCardCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    [self.contentView addSubview:self.cardView];
}

- (void)bindEvents {
    @weakify(self)
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]init];
    
    [[longPress rac_gestureSignal] subscribeNext:^(UILongPressGestureRecognizer * longPress) {
        @strongify(self)
        if (self.longPressBlock) {
            self.longPressBlock();
        }
    }];
    [self.cardView addGestureRecognizer:longPress];
}

- (void)mfy_startPlay {
    [self.cardView mfy_startPlay];
}

- (void)mfy_stopPlay {
    [self.cardView mfy_stopPlay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setArticle:(MFYArticle *)article {
    if (article != nil) {
        _article = article;
        [self.cardView setModel:article];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.cardView.suduView.bigItem resetVideo];
}

- (MFYFlowCardView *)cardView {
    if (!_cardView) {
        _cardView = [[MFYFlowCardView alloc]init];
        [_cardView setCardType:MFYFlowCardViewTypeSmall];
    }
    return _cardView;
}



@end
