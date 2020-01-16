//
//  MFYBaseViewController.m
//  Earth
//
//  Created by colr on 2019/12/16.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYBaseViewController.h"

@interface MFYBaseViewController ()

@end

@implementation MFYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _bindEvents];
}

- (void)_bindEvents {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"ico_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navBar.leftButton = backButton;
}

#pragma mark - Actions

- (void)backButtonAction:(UIButton *)button {
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if (self.navigationController.presentationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - Accessors

- (MFYNavigationBar *)navBar {
    if (!_navBar) {
        _navBar = [[MFYNavigationBar alloc] init];
    }
    return _navBar;
}

#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.navBar];
}


#pragma mark - 等待重写

- (void)setupViews {}

- (void)bindEvents {}

@end
