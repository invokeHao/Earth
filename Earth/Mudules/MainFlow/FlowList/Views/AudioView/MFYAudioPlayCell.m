//
//  MFYAudioPlayCell.m
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAudioPlayCell.h"
#import "MFYTagDisplayView.h"
#import "MFYTagDisplayLayout.h"
#import "WHTimeUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "MFYArticleService.h"
#import "MFYShareView.h"
#import "MFYProfessView.h"
#import "MFYAudioPublishView.h"


@interface MFYAudioPlayCell ()<AVAudioPlayerDelegate>

{
    CGFloat _backTop;
    CGFloat _headerTop;
    CGFloat _nameHeight;
}

@property (strong, nonatomic)YYAnimatedImageView * headIcon;

@property (strong, nonatomic)UILabel * nameLabel;

@property (strong, nonatomic)YYAnimatedImageView * audioBack;

@property (strong, nonatomic)UILabel * timeLabel;

@property (strong, nonatomic)MFYTagDisplayView * tagView;

@property (strong, nonatomic)UIView * centerBackView;

@property (strong, nonatomic)YYAnimatedImageView * playView;

@property (strong, nonatomic)UIImageView * stopView;

@property (strong, nonatomic)UIButton * likeBtn;

@property (strong, nonatomic)UILabel * likeLabel;

@property (strong, nonatomic)UIButton * replyBtn;//回复

@property (strong, nonatomic)UILabel * replayLabel;

@property (strong, nonatomic)UIButton * reportBtn;

@property (strong, nonatomic)UIButton * shareBtn;

@property (nonatomic, strong)AVAudioPlayer *audioPlayer;

@property (nonatomic, assign)CGFloat tagViewHeight;

@end

@implementation MFYAudioPlayCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self bindEvents];
        [self configTheTagViewHeight];
    }
    return self;
}

- (void)setupViews {
    
    _headerTop = 0;
    _backTop = 30;
    _nameHeight = 17;
    
    [self.contentView addSubview:self.audioBack];
    [self.contentView addSubview:self.headIcon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.tagView];
    
    [self.audioBack addSubview:self.timeLabel];
    [self.audioBack addSubview:self.centerBackView];
    [self.audioBack addSubview:self.playView];
    [self.audioBack addSubview:self.stopView];
    [self.audioBack addSubview:self.likeBtn];
    [self.audioBack addSubview:self.likeLabel];
    [self.audioBack addSubview:self.replyBtn];
    [self.audioBack addSubview:self.replayLabel];
    [self.audioBack addSubview:self.reportBtn];
    [self.audioBack addSubview:self.shareBtn];
}

- (void)setupCardView {
    _headerTop = 10;
    _backTop = 0;
    _nameHeight = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(_headerTop);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headIcon);
        make.top.mas_equalTo(self.headIcon.mas_bottom).offset(10);
        make.height.mas_equalTo(_nameHeight);
    }];
    
    [self.audioBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backTop);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(13);
        make.height.mas_equalTo(15);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
        make.height.mas_equalTo(self.tagViewHeight);
    }];
    
    [self.centerBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.audioBack);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(96), W_SCALE(96)));
    }];
    
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.audioBack);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(96), W_SCALE(96)));
    }];
    
    [self.stopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.audioBack);
        make.size.mas_equalTo(CGSizeMake(W_SCALE(29), W_SCALE(35)));
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(W_SCALE(48));
        make.bottom.mas_equalTo(H_SCALE(-70));
        make.size.mas_equalTo(CGSizeMake(31, 29));
    }];
    
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.likeBtn);
        make.top.mas_equalTo(self.likeBtn.mas_bottom).offset(12);
        make.height.mas_equalTo(15);
    }];
    
    [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(W_SCALE(-48));
        make.bottom.mas_equalTo(self.likeBtn);
        make.size.mas_equalTo(CGSizeMake(33, 29));
    }];
    
    [self.replayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.replyBtn);
        make.top.mas_equalTo(self.likeLabel);
        make.height.mas_equalTo(15);
    }];
    
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.bottom.mas_equalTo(-9);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-11);
        make.bottom.mas_equalTo(self.reportBtn);
        make.size.mas_equalTo(CGSizeMake(19, 20));
    }];
}


- (void)configTheTagViewHeight {
    CGFloat tagViewH = (H_SCALE(440)/2 - (H_SCALE(97)/2) - 110);
    CGFloat H = 0;
    for (int i = 1; i < 10; i++) {
        H = i * 22 + (i - 1) * 10;
        if (H < tagViewH) {
            continue;
        }else {
            break;
        }
    }
    self.tagViewHeight = H - 32;
}

- (void)bindEvents {
    @weakify(self)
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        if (self.audioPlayer.isPlaying) {
            [self pauseTheAudio];
        }else {
            [self mfy_startPlay];
        }
    }];
    [self.playView addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tapPlay = [[UITapGestureRecognizer alloc]init];
    [[tapPlay rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self)
        if (self.audioPlayer.isPlaying) {
            [self pauseTheAudio];
        }else {
            [self mfy_startPlay];
        }
    }];
    [self.stopView addGestureRecognizer:tapPlay];

    
    [[self.likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * btn) {
       @strongify(self)
        BOOL like = !btn.selected;
        [MFYArticleService postLikeArticle:self.model.articleId isLike:like Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            if (!error) {
                [btn setSelected:like];
                if (like) {
                    self.model.likeTimes += 1;
                }else {
                    self.model.likeTimes -= 1;
                }
                self.likeLabel.text = self.model.likeTimes > 0 ? FORMAT(@"%ld人喜欢",(long)self.model.likeTimes) : @"喜欢";
            }
        }];
    }];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]init];
    
    [[longPress rac_gestureSignal] subscribeNext:^(UILongPressGestureRecognizer * longPress) {
        @strongify(self)
        if (self.longPressBlock) {
            self.longPressBlock();
        }
    }];
    [self addGestureRecognizer:longPress];
    
    //分享与举报
    [[self.reportBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.model.complained) {
            [WHHud showString:@"您已举报过该帖子"];
            return;
        }
        [MFYArticleService reportArticle:self.model.articleId Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
            if (isSuccess) {
                [WHHud showString:@"举报成功"];
            }else {
                [WHHud showString:error.descriptionFromServer];
            }
        }];
    }];
    
    [[self.shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [MFYShareView showInViewWithArticle:self.model];
    }];
    
    [[self.replyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       @strongify(self)
        [WHHud showActivityView];
        [MFYRechargeService getTheProfessStatusCompletion:^(CGFloat price, NSError * _Nonnull error) {
            [WHHud hideActivityView];
            if (!error) {
                if (price < 0) {
                    [WHHud showString:@"系统错误"];
                    return;
                }
                MFYArticle * article = self.model;
                [MFYAudioPublishView professToSB:article];
            }else{
               [WHHud showString:error.descriptionFromServer];
            }
        }];
    }];
}

- (void)setModel:(MFYArticle *)model {
    if (model != nil) {
        _model = model;
        MFYProfile * profile = model.profile;
        [self.audioBack setImage:WHImageNamed(FORMAT(@"audioBG_%ld",model.bgName))];
        [self.headIcon yy_setImageWithURL:[NSURL URLWithString:profile.headIconUrl] placeholder:WHImageNamed(@"default_user")];
        [self.nameLabel setText:profile.nickname];
        [self.tagView setTags: profile.tags];
        [self.timeLabel setText:[WHTimeUtil articleCardDateStringByTimeStamp:[model.createDate integerValue]]];
        self.likeBtn.selected = model.liked;
        self.likeLabel.text = model.likeTimes > 0 ? FORMAT(@"%ld人喜欢",(long)model.likeTimes) : @"喜欢";
        self.replayLabel.text = model.commentTimes > 0 ? FORMAT(@"%ld条回复",(long)model.commentTimes) : @"回复";
        [self configTheAudio];
    }
}

- (void)configTheAudio {
    MFYMedia * media = self.model.media;
    if (media.mediaType == 2 & media.mediaUrl.length > 0 ) {
        NSData *voiceData = [NSData dataWithContentsOfURL:[NSURL URLWithString:media.mediaUrl]];
        self.audioPlayer = [[AVAudioPlayer alloc]initWithData:voiceData error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer prepareToPlay];
    }
}

- (void)mfy_startPlay {
    if (self.audioPlayer == nil) {
        [self configTheAudio];
    }
    [self.audioPlayer play];
    [self.playView startAnimating];
    [self.playView setHidden:NO];
    [self.stopView setHidden:YES];

}

- (void)pauseTheAudio {
    [self.audioPlayer pause];
    [self.playView stopAnimating];
    [self.playView setHidden:YES];
    [self.stopView setHidden:NO];
}

- (void)mfy_stopPlay {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    [self.playView stopAnimating];
    [self.playView setHidden:YES];
    [self.stopView setHidden:NO];

}

#pragma mark- audioDeleagate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self mfy_stopPlay];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.audioPlayer = nil;
}


- (YYAnimatedImageView *)audioBack {
    if (!_audioBack) {
        _audioBack = [[YYAnimatedImageView alloc]init];
        [_audioBack setImage:WHImageNamed(@"audio_back")];
        _audioBack.userInteractionEnabled = YES;
    }
    return _audioBack;
}

- (YYAnimatedImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[YYAnimatedImageView alloc]init];
        _headIcon.backgroundColor = wh_colorWithHexString(@"E5E5E5");
        _headIcon.layer.cornerRadius = 30;
        _headIcon.clipsToBounds = YES;
    }
    return _headIcon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.label;
        _nameLabel.WH_textAlignment(NSTextAlignmentCenter).WH_font(WHFont(16)).WH_textColor([UIColor whiteColor]);
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.label;
        _timeLabel.WH_font(WHFont(13)).WH_textColor([UIColor whiteColor]);
    }
    return _timeLabel;
}

- (MFYTagDisplayView *)tagView {
    if (!_tagView) {
        MFYTagDisplayLayout *layout = [[MFYTagDisplayLayout alloc] initWthType:AlignWithLeft];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 2);
        _tagView = [[MFYTagDisplayView alloc] initWithFrame:CGRectZero
                                        collectionViewLayout:layout];
        _tagView.backgroundColor = [UIColor clearColor];
        _tagView.bounces = NO;
//        @weakify(self);
//        [_tagView setShouldUpdateHeight:^(CGFloat height){
//            @strongify(self);
//            WHLog(@"height== %f",height);
//            WHLog(@"tagMax== %f", self.tagViewHeight);
//            if (height > TagMaxHeight) {
//                height = TagMaxHeight;
//            }
//            [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(height);
//            }];
//        }];
    }
    return _tagView;
}

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = UIButton.button;
        _likeBtn.WH_setImage_forState(WHImageNamed(@"audio_dislike"),UIControlStateNormal);
        _likeBtn.WH_setImage_forState(WHImageNamed(@"audio_like"),UIControlStateSelected);
    }
    return _likeBtn;
}

- (UILabel *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = UILabel.label;
        _likeLabel.WH_font(WHFont(14)).WH_textColor([UIColor whiteColor]).WH_textAlignment(NSTextAlignmentCenter).WH_text(@"喜欢");
    }
    return _likeLabel;
}


- (UIButton *)replyBtn {
    if (!_replyBtn) {
        _replyBtn = UIButton.button;
        _replyBtn.WH_setImage_forState(WHImageNamed(@"audio_reply"),UIControlStateNormal);
    }
    return _replyBtn;
}

- (UILabel *)replayLabel {
    if (!_replayLabel) {
        _replayLabel = UILabel.label;
        _replayLabel.WH_font(WHFont(14)).WH_textColor([UIColor whiteColor]).WH_textAlignment(NSTextAlignmentCenter).WH_text(@"回复");
    }
    return _replayLabel;
}

- (UIButton *)reportBtn {
    if (!_reportBtn) {
        _reportBtn = UIButton.button;
        _reportBtn.WH_setImage_forState(WHImageNamed(@"audio_report"),UIControlStateNormal);
    }
    return _reportBtn;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = UIButton.button;
        _shareBtn.WH_setImage_forState(WHImageNamed(@"audio_share"),UIControlStateNormal);
    }
    return _shareBtn;
}

- (UIView *)centerBackView {
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc]init];
        _centerBackView.backgroundColor = wh_colorWithHexString(@"#000507");
        _centerBackView.alpha = 0.4;
        _centerBackView.layer.cornerRadius = 48;
        _centerBackView.clipsToBounds = YES;
    }
    return _centerBackView;;
}

- (YYAnimatedImageView *)playView {
    if (!_playView) {
        YYImage * image = [YYImage imageNamed:@"audio_playing.gif"];
        image.preloadAllAnimatedImageFrames = YES;
        _playView = [[YYAnimatedImageView alloc]initWithImage:image];
        _playView.contentMode = UIViewContentModeScaleAspectFill;
        _playView.autoPlayAnimatedImage = NO;
        _playView.userInteractionEnabled = YES;
    }
    return _playView;
}


- (UIImageView *)stopView {
    if (!_stopView) {
        _stopView = UIImageView.imageView.WH_image(WHImageNamed(@"audioCell_stop"));
        _stopView.contentMode = UIViewContentModeCenter;
        _stopView.hidden = YES;
        _stopView.userInteractionEnabled = YES;
    }
    return _stopView;;
}

@end
