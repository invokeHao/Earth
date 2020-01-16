//
//  UIView+WHUd.h
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WHUd)

- (void)showActivityView;

- (void)hideActivityView;

- (void)showString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
