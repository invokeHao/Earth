//
//  MFYSingleChatVC.m
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYSingleChatVC.h"

@interface MFYSingleChatVC ()

@end

@implementation MFYSingleChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}


- (void)setupViews {
    self.navBar.titleLabel.text = @"单聊";
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
