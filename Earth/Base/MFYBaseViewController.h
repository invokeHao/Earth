//
//  MFYBaseViewController.h
//  Earth
//
//  Created by colr on 2019/12/16.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYBaseViewController : UIViewController

@property (nonatomic, strong) MFYNavigationBar *navBar;

- (void)backButtonAction:(UIButton *)button;

- (void)setupViews;

- (void)bindEvents;

@end

NS_ASSUME_NONNULL_END
