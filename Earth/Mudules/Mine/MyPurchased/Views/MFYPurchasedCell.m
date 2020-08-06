//
//  MFYPurchasedCell.m
//  Earth
//
//  Created by colr on 2020/3/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPurchasedCell.h"

@interface MFYPurchasedCell()

@property (nonatomic, strong)YYAnimatedImageView * coverImageView;

@property (nonatomic, strong)UIImageView * playView;

@end

@implementation MFYPurchasedCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.layer.cornerRadius = 6;
    self.contentView.clipsToBounds = YES;
    [self.contentView addSubview:self.coverImageView];
    [self.contentView addSubview:self.playView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(34, 40));
    }];

}

- (void)setArticle:(MFYItem *)article {
    if (article) {
        _article = article;
        self.playView.hidden = article.media.mediaType < 3 ;
        if (article.media.mediaUrl.length > 1) {
            NSURL * coverImageURL = [NSURL URLWithString:article.media.mediaUrl];
            if (article.media.mediaType > 2) {
               coverImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?vframe/jpg/offset/0.2", article.media.mediaUrl]];
           }
            [self.coverImageView yy_setImageWithURL:coverImageURL options:YYWebImageOptionProgressive];
        }
    }
}

- (YYAnimatedImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[YYAnimatedImageView alloc]init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.backgroundColor = wh_colorWithHexString(@"#B2B2B2");
    }
    return _coverImageView;
}

- (UIImageView *)playView {
    if (!_playView) {
        _playView = [[UIImageView alloc]initWithImage:WHImageNamed(@"video_tag")];
        _playView.hidden = YES;
    }
    return _playView;
}


@end
