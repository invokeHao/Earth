//
//  MFYBaseNavigationController.m
//  Earth
//
//  Created by colr on 2019/12/16.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYBaseNavigationController.h"

@interface MFYBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation MFYBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBarHidden = YES;
    
    __weak MFYBaseNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

- (UIModalPresentationStyle)modalPresentationStyle{
    return UIModalPresentationFullScreen;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 使自定义了 nav bar 返回按钮的 view controller 也可以通过 interactivePopGestureRecognizer 来 pop
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 ||
            self.visibleViewController == (self.viewControllers)[0]) {
            return NO;
        }
    }
    return YES;
}



@end
