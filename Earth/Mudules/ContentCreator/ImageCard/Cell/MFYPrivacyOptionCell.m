//
//  MFYPrivacyOptionCell.m
//  Earth
//
//  Created by colr on 2020/1/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPrivacyOptionCell.h"

@interface MFYPrivacyOptionCell()

@property (assign, nonatomic)MFYPrivacyOptionType type;

@property (strong, nonatomic)UIView * imageAndVideoView;

@property (strong, nonatomic)UILabel * leftLabel;

@end

@implementation MFYPrivacyOptionCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(MFYPrivacyOptionType)type {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _type = type;
        [self setupViews];
        [self bindEvent];
    }
    return self;
}

+ (MFYPrivacyOptionCell *)mfy_cellWithTableView:(MFYBaseTableView *)tableView type:(MFYPrivacyOptionType)type{
    
    MFYPrivacyOptionCell * cell = [[MFYPrivacyOptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MFYPrivacyOptionCell reuseID] type:type];
    return cell;
}

- (void)bindEvent {
    @weakify(self);
    [[self.checkBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        WHLog(@"selectedTheCheckBtn");
        self.checkBtnBlock();
    }];
    [self.videoView setTapAddBlock:^{
        @strongify(self)
        self.addPhotoBlock();
    }];
}

- (void)setupViews {
    [super setupViews];
    switch (self.type) {
        case MFYPrivacyOptionTextType:
            [self setupTitleTypeUI];
            break;
            case MFYPrivacyOptionCheckType:
            [self setupButtonTypeUI];
            break;
            case MFYPrivacyOptionRedEnvelopeType:
            [self setupRedEnvelopeTypeUI];
            break;
            case MFYPrivacyOptionTitleType:
            [self setupTitleFieldTypeUI];
            break;
            case MFYPrivacyOptionImageType:
            [self setupImageTypeUI];
            break;
        default:
            break;
    }
}

- (void)setupTitleTypeUI {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18);
    }];
}

- (void)setupButtonTypeUI {
    [self.contentView addSubview:self.checkBtn];
    [self.contentView addSubview:self.titleLabel];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18);
    }];
}

- (void)setupRedEnvelopeTypeUI {
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.redField];
    [self.contentView addSubview:self.tipsLabel];
    
    self.leftLabel.text = @"红包";
    self.tipsLabel.text = @"元";
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(17);
    }];
    
    [self.redField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.tipsLabel.mas_left).offset(-30);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
}

- (void)setupTitleFieldTypeUI {
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.titleField];
    [self.contentView addSubview:self.tipsLabel];
    
    self.leftLabel.text = @"文字介绍";
    self.tipsLabel.text = @"0/6";
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(18);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(17);
    }];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.tipsLabel.mas_left).offset(-30);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
}

- (void)setupImageTypeUI {
    [self.contentView addSubview:self.imageAndVideoView];
    [self.imageAndVideoView addSubview:self.videoView];
    
    [self.imageAndVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(120, 160));
    }];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}


- (NSString *)getTheIdentifierWithType:(MFYPrivacyOptionType)type {
    return nil;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.label.WH_textColor(wh_colorWithHexString(@"333333")).WH_font(WHFont(17));
    }
    return _titleLabel;
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = UIButton.button;
        _checkBtn.WH_setImage_forState(WHImageNamed(@"public_privacy_normal"),UIControlStateNormal);
        _checkBtn.WH_setImage_forState(WHImageNamed(@"public_privacy_selected"),UIControlStateSelected);
    }
    return _checkBtn;
}

- (UITextField *)redField {
    if (!_redField) {
        _redField = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入红包金额" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#999999"),
        NSFontAttributeName:WHFont(15)
        }];
        _redField.attributedPlaceholder = attrString;
        _redField.textColor = wh_colorWithHexString(@"333333");
        _redField.tintColor = wh_colorWithHexString(@"333333");
        _redField.textAlignment = NSTextAlignmentRight;
    }
    return _redField;
}

- (UITextField *)titleField {
    if (!_titleField) {
        _titleField = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入照片/视频标题" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"#999999"),
        NSFontAttributeName:WHFont(15)
        }];
        _titleField.attributedPlaceholder = attrString;
        _titleField.textColor = wh_colorWithHexString(@"333333");
        _titleField.tintColor = wh_colorWithHexString(@"333333");
        _titleField.textAlignment = NSTextAlignmentRight;
    }
    return _titleField;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = UILabel.label.WH_font(WHFont(16));
        _tipsLabel.WH_textColor(wh_colorWithHexString(@"#4D4D4D"));
    }
    return _tipsLabel;
}

-(MFYVideoAndImageView *)videoView {
    if (!_videoView) {
        _videoView = [[MFYVideoAndImageView alloc]initWithType:MFYVideoAndImageViewSmallType];
    }
    return _videoView;
}

- (UIView *)imageAndVideoView {
    if (!_imageAndVideoView) {
        _imageAndVideoView = [[UIView alloc]init];
        _imageAndVideoView.layer.borderColor = wh_colorWithHexString(@"#DCDDE6").CGColor;
        _imageAndVideoView.layer.borderWidth = 0.5;
    }
    return _imageAndVideoView;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = UILabel.label.WH_textColor(wh_colorWithHexString(@"333333")).WH_font(WHFont(15));
    }
    return _leftLabel;
}


@end
