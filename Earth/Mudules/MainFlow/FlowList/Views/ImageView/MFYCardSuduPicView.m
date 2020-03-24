//
//  MFYCardSuduPicView.m
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYCardSuduPicView.h"
#import "MFYImageDetailVC.h"
#import "MFYHTTPCacheService.h"
#import <JPVideoPlayer/UIView+WebVideoCache.h>
#import "MFYVideoDetailVC.h"
#import "WHTimeUtil.h"
#import "MFYShareView.h"
#import "MFYArticleService.h"

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
            [self.bigItem setFrame:itemRect];
            [self addSubview:self.bigItem];
        }else if (index == 1) {
            itemRect = CGRectMake(itemW + 2, 0, itemMW, itemMH);
            [self.smallTopItem setFrame:itemRect];
            [self addSubview:self.smallTopItem];
        }else{
            itemRect = CGRectMake(itemW + 2, itemMH + 2, itemMW, itemMH);
            [self.smallBottomItem setFrame:itemRect];
            [self addSubview:self.smallBottomItem];
        }
        [self.imageVArr removeAllObjects];
        [self.imageVArr addObjectsFromArray:@[self.bigItem,self.smallTopItem,self.smallBottomItem]];
    }
}

- (void)bindEvents {
    
}

- (void)stopPlay {
    if (self.bigItem) {
        [self.bigItem stopTheVideo];
    }
}

- (void)startPlay {
    if (self.bigItem) {
        [self.bigItem startPlayTheVideo];
    }
}

- (void)pause {
    if (self.bigItem) {
        [self.bigItem pauseTheVideo];
    }
}

- (void)setArticle:(MFYArticle *)article {
    if (article) {
        _article = article;
        @weakify(self)
        [article.embeddedArticles enumerateObjectsUsingBlock:^(MFYItem * item, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            if (idx == 0) {
                item.isbig = YES;
            }
            MFYPicItemView * picItem = [self.imageVArr objectAtIndex:idx];
            [picItem setItemModel:item];
            [picItem setArticle:article];
#pragma mark- 马赛克逻辑
            if (item.media.mediaUrl.length > 1) {
                NSURL * coverImageURL = [NSURL URLWithString:item.media.mediaUrl];
                if (item.media.mediaType > 2) {
                    coverImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?vframe/jpg/offset/0.2", item.media.mediaUrl]];
                }
                [picItem.picImageV yy_setImageWithURL:coverImageURL placeholder:nil options:YYWebImageOptionProgressive completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    if (image && item.priceAmount > 0 && idx > 0 && !item.purchased) {
                       UIImage * mosaicImage = [UIImage mosaicImage:image mosaicLevel:80];
                       [picItem.mosaciView setImage:mosaicImage];
                    }
                }];
            }
        }];
    }
}

- (NSMutableArray *)imageVArr {
    if (!_imageVArr) {
        _imageVArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageVArr;
}

- (MFYPicItemView *)bigItem {
    if (!_bigItem) {
        _bigItem = [[MFYPicItemView alloc]initWithItemType:MFYPicItemBigType];
        _bigItem.itemType = MFYPicItemBigType;
    }
    return _bigItem;
}

- (MFYPicItemView *)smallTopItem {
    if (!_smallTopItem) {
        _smallTopItem = [[MFYPicItemView alloc]initWithItemType:MFYPicItemSmallTopType];
        _smallTopItem.itemType = MFYPicItemSmallTopType;
    }
    return _smallTopItem;
}

- (MFYPicItemView *)smallBottomItem {
    if (!_smallBottomItem) {
        _smallBottomItem = [[MFYPicItemView alloc]initWithItemType:MFYPicItemSmallBottomType];
        _smallBottomItem.itemType = MFYPicItemSmallBottomType;
    }
    return _smallBottomItem;
}

@end



@interface MFYPicItemView ()

@property (strong, nonatomic)UIView * tipView;

@property (strong, nonatomic)UILabel * tipLabel;

@property (strong, nonatomic)UIImageView * playView;

@property (strong, nonatomic)UIButton * reportBtn;

@property (strong, nonatomic)UIButton * shareBtn;

@property (strong, nonatomic)UILabel * timeLabel;


@end

@implementation MFYPicItemView

- (instancetype)initWithItemType:(MFYPicItemType)itemType {
    self = [super init];
    if (self) {
        _itemType = itemType;
        [self setupViews];
        [self bindEvents];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.picImageV];
    [self addSubview:self.mosaciView];
    [self addSubview:self.tipView];
    [self addSubview:self.playView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.reportBtn];
    [self addSubview:self.shareBtn];
    
    
    [self.tipView addSubview:self.tipLabel];
    
    [self.picImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.mosaciView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(34, 40));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(14);
    }];
    
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(-4);
        make.size.mas_equalTo(CGSizeMake(22, 23));
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-2);
        make.bottom.mas_equalTo(-2);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
}

- (void)setItemModel:(MFYItem *)itemModel {
    if (itemModel) {
        _itemModel = itemModel;
        self.playView.hidden = itemModel.media.mediaType < 3 ;
        
#pragma mark- 视频缓存
        if (itemModel.media.mediaType > 2) {
            self.playUrl = [MFYHTTPCacheService proxyURLWithOriginalUrl:itemModel.media.mediaUrl];
        }
        if (self.itemType == MFYPicItemBigType) {
            NSString * timeStr = [WHTimeUtil articleCardDateStringByTimeStamp:itemModel.createDate];
            NSShadow *shadow = [[NSShadow alloc] init];
            shadow.shadowBlurRadius = 2;
            shadow.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
            shadow.shadowOffset = CGSizeMake(0,1);

            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:timeStr attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14.0],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}];

            self.timeLabel.attributedText = string;
        }
        [self layoutTheTip:itemModel.bodyText]; //配置帖子说明
    }
}

- (void)bindEvents {
    @weakify(self)
    self.reportBtn.hidden = self.itemType != MFYPicItemBigType;
    self.timeLabel.hidden = self.reportBtn.hidden;
    self.shareBtn.hidden = self.itemType != MFYPicItemSmallBottomType;
    
    if (self.itemType == MFYPicItemBigType) {
        UITapGestureRecognizer * tapBig = [[UITapGestureRecognizer alloc]init];
        
        [[tapBig rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self)
            if ([self.itemModel mediaType] == MFYMediavideoType) {
                [self startPlayTheVideo];
            }
            if ([self.itemModel mediaType] == MFYMediaPictureType) {
                MFYImageDetailVC * detailVC = [[MFYImageDetailVC alloc]init];
                detailVC.itemModel = self.itemModel;
                [[WHAlertTool WHTopViewController].navigationController pushViewController:detailVC animated:YES];
            }
        }];
        [self addGestureRecognizer:tapBig];
    }
    if ((self.itemType == MFYPicItemSmallTopType) | (self.itemType == MFYPicItemSmallBottomType) ) {
        UITapGestureRecognizer * tapSmall = [[UITapGestureRecognizer alloc]init];
        [[tapSmall rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self)
            if ([self.itemModel mediaType] == MFYMediavideoType) {
                MFYVideoDetailVC * videoVC = [[MFYVideoDetailVC alloc]init];
                videoVC.itemModel = self.itemModel;
                [[WHAlertTool WHTopViewController].navigationController pushViewController:videoVC animated:YES];
            }
            if ([self.itemModel mediaType] == MFYMediaPictureType) {
                MFYImageDetailVC * detailVC = [[MFYImageDetailVC alloc]init];
                detailVC.itemModel = self.itemModel;
                [[WHAlertTool WHTopViewController].navigationController pushViewController:detailVC animated:YES];
            }
        }];
        [self addGestureRecognizer:tapSmall];
    }
    //分享与举报
    [[self.reportBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.article.complained) {
            [WHHud showString:@"您已举报过该帖子"];
            return;
        }
        [MFYArticleService reportArticle:self.article.articleId Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            if (isSuccess) {
                [WHHud showString:@"举报成功"];
                self.article.complained = YES;
            }else {
                [WHHud showString:error.descriptionFromServer];
            }
        }];
    }];
    
    [[self.shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [MFYShareView showInViewWithArticle:self.article];
    }];
    
}

- (void)layoutTheTip:(NSString *)tip {
    self.tipView.hidden = tip == nil;
    if (tip) {
        self.tipView.backgroundColor =wh_colorWithHexAndAlpha(@"#000000", 0.4);
        self.tipLabel.text = tip;
        CGFloat width = (tip.length * 15) + 20 > self.width - 40 ? self.width - 40 : (tip.length * 15) + 20 ;
        CGFloat height = tip.length > 4 ? 50 : 20;
        
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(4);
            make.bottom.mas_equalTo(-4);
        }];
        
        [self layoutIfNeeded];
        [self.tipView roundCorner:UIRectCornerTopLeft|UIRectCornerBottomRight radius:10];
    }
}

#pragma mark- 视频相关

- (void)startPlayTheVideo {
    if (!self.playUrl) {
        return;
    }
    self.playView.hidden = YES;
    if (self.picImageV.jp_playerStatus == JPVideoPlayerStatusPlaying) {
        return;
    }
    [self.picImageV jp_playVideoWithURL:self.playUrl options:JPVideoPlayerLayerVideoGravityResize configuration:^(UIView * _Nonnull view, JPVideoPlayerModel * _Nonnull playerModel) {
    }];
}

- (void)pauseTheVideo {
    if (!self.playUrl) {
        return;
    }
    self.playView.hidden = NO;
    [self.picImageV jp_pause];
}

- (void)stopTheVideo {
    if (!self.playUrl) {
        return;
    }
    self.playView.hidden = NO;
    [self.picImageV jp_stopPlay];
}

- (void)resetVideo {
    if (self.playUrl) {
        self.playUrl = nil;
        [self.picImageV jp_stopPlay];
    }
}


#pragma mark - Privates

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}


#pragma mark- JPDelegate

- (BOOL)shouldShowBlackBackgroundWhenPlaybackStart {
    return NO;
}

- (BOOL)shouldShowBlackBackgroundBeforePlaybackStart {
    return NO;
}

- (BOOL)videoPlayerManager:(JPVideoPlayerManager *)videoPlayerManager shouldAutoReplayForURL:(NSURL *)videoURL {
    return YES;
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

- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [[UIView alloc]init];
        _tipView.hidden = YES;
    }
    return _tipView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = UILabel.label;
        _tipLabel.WH_font(WHFont(14)).WH_textColor(wh_colorWithHexString(@"#FFFFFF"));
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIImageView *)mosaciView {
    if (!_mosaciView) {
        _mosaciView = [[UIImageView alloc]init];
    }
    return _mosaciView;
}

- (UIImageView *)playView {
    if (!_playView) {
        _playView = [[UIImageView alloc]initWithImage:WHImageNamed(@"video_tag")];
        _playView.hidden = YES;
    }
    return _playView;
}

- (UIButton *)reportBtn {
    if (!_reportBtn) {
        _reportBtn = UIButton.button.WH_setImage_forState(WHImageNamed(@"article_report"),UIControlStateNormal);
        _reportBtn.hidden = YES;
    }
    return _reportBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = UIButton.button.WH_setImage_forState(WHImageNamed(@"share_icon"),UIControlStateNormal);
        _shareBtn.hidden = YES;
    }
    return _shareBtn;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.label;
        _timeLabel.WH_font(WHFont(13)).WH_textColor([UIColor whiteColor]);
    }
    return _timeLabel;
}

@end

