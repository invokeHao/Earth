//
//  MFYPublicImageCardVC.m
//  Earth
//
//  Created by colr on 2020/1/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYPublicImageCardVC.h"

@interface MFYPublicImageCardVC ()

@end

@implementation MFYPublicImageCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    self.navBar.titleLabel.text = @"颜控";
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FF3F70");
    [self.navBar.leftButton setImage:WHImageNamed(@"ico_arrow_back") forState:UIControlStateNormal];
    
}

- (void)backButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:NULL];
}




@end
