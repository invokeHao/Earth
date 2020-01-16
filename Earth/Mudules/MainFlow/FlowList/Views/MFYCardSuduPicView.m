//
//  MFYCardSuduPicView.m
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYCardSuduPicView.h"

@implementation MFYCardSuduPicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    for (int index = 0; index < 3; index++) {
        CGFloat itemW = W_SCALE(233);
        CGFloat itemH = H_SCALE(325);
        CGFloat itemMW = VERTICAL_SCREEN_WIDTH - 24 - itemW - 2;
        CGFloat itemMH = (itemH - 2) / 2;
        CGRect itemRect = CGRectZero;
        if (index == 0) {
            itemRect = CGRectMake(0, 0, itemW, itemH);
        }else if (index == 1) {
            itemRect = CGRectMake(itemW + 2, 0, itemMW, itemMH);
        }else{
            itemRect = CGRectMake(itemW + 2, itemMH + 2, itemMW, itemMH);
        }

        MFYPicItemView *picItem = [[MFYPicItemView alloc]init];
        [self.imageVArr addObject:picItem];
        [picItem setFrame:itemRect];
        [self addSubview:picItem];
        picItem.tag = index;
        @weakify(self);
        [picItem setSelectedBlock:^(NSInteger index) {
            @strongify(self);
//            [self showTheFullScreenImageWithIndex:index];
        }];
    }
}

- (void)bindEvents {
    
}


@end



@interface MFYPicItemView ()

@end

@implementation MFYPicItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.picImageV];
    
    [self.picImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)bindEvents {
    
}


- (YYAnimatedImageView *)picImageV {
    if (!_picImageV) {
        _picImageV = [[YYAnimatedImageView alloc]init];
        _picImageV.contentMode = UIViewContentModeScaleAspectFill;
        _picImageV.clipsToBounds = YES;
        _picImageV.autoPlayAnimatedImage = NO;
        _picImageV.backgroundColor = MFYefaultImageColor;
        _picImageV.userInteractionEnabled = YES;
    }
    return _picImageV;
}


@end

