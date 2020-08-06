//
//  MFYAboutUsVC.m
//  Earth
//
//  Created by colr on 2020/2/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYAboutUsVC.h"

@interface MFYAboutUsVC ()

@property (nonatomic,strong) UILabel * titleLabel;

@property (nonatomic,strong) UILabel * detailLabel;

@end

@implementation MFYAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"关于";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    self.view.backgroundColor = wh_colorWithHexString(@"#FFFFFF");
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.detailLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17 + NAVIGATION_BAR_HEIGHT);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(18);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];

}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(wh_colorWithHexString(@"#333333"));
        _titleLabel.WH_textAlignment(NSTextAlignmentCenter);
        _titleLabel.WH_text(@"基于生活圈社交平台");
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = UILabel.label.WH_font(WHFont(16)).WH_textColor(wh_colorWithHexString(@"#333333"));
    _detailLabel.WH_text(@"同在一个玻璃瓶中的蜜蜂与苍蝇，结局却迥然不同：蜜蜂因循守旧，思维教条，终力竭而死;苍蝇看似横冲直撞，却是不断尝试，终重获自由。二者截然相反的命运给人们一个莫大的启示：拘泥于传统的经验和理论并非能有满意的结果，而破旧迎新、创新发展或许会有意想不到的收获。故曰：勇于破旧，方可迎新。");
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

@end
