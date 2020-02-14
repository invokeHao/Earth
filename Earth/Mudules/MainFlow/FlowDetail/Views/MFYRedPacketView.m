//
//  MFYRedPacketView.m
//  Earth
//
//  Created by colr on 2020/2/13.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYRedPacketView.h"

@interface MFYRedPacketView()

@property (nonatomic, strong)UIImageView * redBackView; //红包背景图片

@property (nonatomic, strong)UIButton * payBtn;

@property (nonatomic, strong)UIButton * backBtn;

@property (nonatomic, strong)UIView * titleView;

@property (nonatomic, strong)UIView * leftLine;

@property (nonatomic, strong)UIView * rightLine;

@property (nonatomic, strong)UILabel * tipLabel;

@property (nonatomic, strong)UILabel * priceLabel;

@end

@implementation MFYRedPacketView

+ (void)showInViwe:(UIView *)view itemModel:(nonnull MFYItem *)item{
    MFYRedPacketView * redView = [[MFYRedPacketView alloc]init];
    [view addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    [redView setItem:item];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self bindEvents];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.redBackView];
    [self.redBackView addSubview:self.titleView];
    [self.redBackView addSubview:self.priceLabel];
    [self.redBackView addSubview:self.backBtn];
    [self.redBackView addSubview:self.payBtn];
    
    [self.titleView addSubview:self.leftLine];
    [self.titleView addSubview:self.tipLabel];
    [self.titleView addSubview:self.rightLine];

}

- (void)layoutSubviews {
    [self.redBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(94);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(16);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.titleView);
        make.size.mas_equalTo(CGSizeMake(30, 0.5));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.leftLine.mas_right).offset(6);
        make.right.mas_equalTo(self.rightLine.mas_left).offset(-6);
        make.height.mas_equalTo(16);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.titleView);
        make.size.mas_equalTo(CGSizeMake(30, 0.5));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.redBackView);
        make.height.mas_equalTo(50);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(120, 20));
        make.centerX.mas_equalTo(self.redBackView);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.backBtn.mas_top).offset(-15);
        make.left.mas_equalTo(29);
        make.right.mas_equalTo(-29);
        make.height.mas_equalTo(40);
    }];
}

- (void)setItem:(MFYItem *)item {
    if (item) {
        _item = item;
        NSString * price = FORMAT(@"%.0f 元",item.priceAmount);
        NSMutableAttributedString * AttrStr = [[NSMutableAttributedString alloc]initWithString:price];
        NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
        attrDic[NSFontAttributeName] = WHFont(18);
        attrDic[NSForegroundColorAttributeName] = wh_colorWithHexString(@"FFFFFF");
        
        NSRange range = [price rangeOfString:@"元"];
        [AttrStr addAttributes:attrDic range:range];

        self.priceLabel.attributedText = AttrStr;
    }
}

- (void)bindEvents {
    @weakify(self)
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self hiddenTheRedPacket];
    }];
}

- (void)hiddenTheRedPacket {
    if (self) {
        [[WHAlertTool WHTopViewController].navigationController popViewControllerAnimated:YES];
        [self removeFromSuperview];
    }
}

#pragma mark- layzz

- (UIImageView *)redBackView {
    if (!_redBackView) {
        _redBackView = UIImageView.imageView;
        [_redBackView setImage:WHImageNamed(@"redPacket")];
        _redBackView.userInteractionEnabled = YES;
    }
    return _redBackView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    return _titleView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = UILabel.label.WH_font(WHFont(15)).WH_textColor(wh_colorWithHexString(@"FFFFFF")).WH_text(@"支付红包可查看照片")
        ;
    }
    return _tipLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = UILabel.label.WH_font(WHFont(50)).WH_textColor(wh_colorWithHexString(@"FFFFFF"));
    }
    return _priceLabel;
}

- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = UIButton.button.WH_titleLabel_font(WHFont(17)).WH_setTitleColor_forState(wh_colorWithHexString(@"#E93D45"),UIControlStateNormal).WH_setTitle_forState(@"立即支付",UIControlStateNormal);
        _payBtn.backgroundColor = [UIColor whiteColor];
        _payBtn.layer.cornerRadius = 6;
        _payBtn.clipsToBounds = YES;

    }
    return _payBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = UIButton.button.WH_titleLabel_font(WHFont(13)).WH_setTitleColor_forState(wh_colorWithHexString(@"FFFFFF"),UIControlStateNormal).WH_setTitle_forState(@"不想看了，悄然离开",UIControlStateNormal);
        _backBtn.backgroundColor = [UIColor clearColor];
    }
    return _backBtn;
}

-(UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = [[UIView alloc]init];
        _leftLine.backgroundColor = wh_colorWithHexString(@"FFFFFF");
    }
    return _leftLine;
}

-(UIView *)rightLine {
    if (!_rightLine) {
        _rightLine = [[UIView alloc]init];
        _rightLine.backgroundColor = wh_colorWithHexString(@"FFFFFF");
    }
    return _rightLine;
}


@end
