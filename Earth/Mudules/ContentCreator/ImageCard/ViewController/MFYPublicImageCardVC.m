//
//  MFYPublicImageCardVC.m
//  Earth
//
//  Created by colr on 2020/1/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPublicImageCardVC.h"
#import "MFYVideoAndImageView.h"

@interface MFYPublicImageCardVC ()

@property (nonatomic, strong)UIScrollView * mainScroll;

@property (nonatomic, strong)UIView * contentView;

@property (nonatomic, strong)UITextField * titleField;

@property (nonatomic, strong)UIView * lineView;

@property (nonatomic, strong)UIView * backView;

@property (nonatomic, strong)MFYVideoAndImageView * bigView;

@property (nonatomic, strong)MFYVideoAndImageView * topSmallView;

@property (nonatomic, strong)MFYVideoAndImageView * bottomSmallView;

@end

@implementation MFYPublicImageCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupConstraint];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"颜控";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    [self.navBar.leftButton setImage:WHImageNamed(@"ico_arrow_back") forState:UIControlStateNormal];
    
    [self.view addSubview:self.mainScroll];
    [self.mainScroll addSubview:self.contentView];
    [self.contentView addSubview:self.titleField];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.bigView];
    [self.backView addSubview:self.topSmallView];
    [self.backView addSubview:self.bottomSmallView];
    
    if (@available(iOS 11.0, *)) {
        self.mainScroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupConstraint {
    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainScroll);
        make.width.mas_equalTo(VERTICAL_SCREEN_WIDTH);
        make.bottom.equalTo(self.backView.mas_bottom).offset(10);
    }];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(40);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleField);
        make.top.mas_equalTo(self.titleField.mas_bottom).offset(2);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat itemW = ( VERTICAL_SCREEN_WIDTH - 25) / 3;
    CGFloat itemH = itemW * 4 / 3;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(20);
        make.left.right.equalTo(self.lineView);
        make.height.mas_equalTo(2 * itemH);
    }];
}


- (void)backButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIScrollView *)mainScroll {
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc]init];
    }
    return _mainScroll;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}

- (UITextField *)titleField {
    if (!_titleField) {
        _titleField = [[UITextField alloc]init];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入自我介绍" attributes:@{NSForegroundColorAttributeName:wh_colorWithHexString(@"##939499"),
               NSFontAttributeName:WHFont(16)
               }];
        _titleField.attributedPlaceholder = attrString;
        _titleField.tintColor = wh_colorWithHexString(@"333333");
    }
    return _titleField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = wh_colorWithHexString(@"#F0F1F5");
    }
    return _lineView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = wh_colorWithHexString(@"#E1E2E6");
    }
    return  _backView;
}

- (MFYVideoAndImageView *)bigView {
    if (!_bigView) {
        _bigView = [[MFYVideoAndImageView alloc]initWithType:MFYVideoAndImageViewBigType];
    }
    return _bigView;
}

- (MFYVideoAndImageView *)topSmallView {
    if (!_topSmallView) {
        _topSmallView = [[MFYVideoAndImageView alloc]initWithType:MFYVideoAndImageViewSmallType];
    }
    return _topSmallView;
}

- (MFYVideoAndImageView *)bottomSmallView {
    if (!_bottomSmallView) {
        _bottomSmallView = [[MFYVideoAndImageView alloc]initWithType:MFYVideoAndImageViewSmallType];
    }
    return _bottomSmallView;
}





@end
