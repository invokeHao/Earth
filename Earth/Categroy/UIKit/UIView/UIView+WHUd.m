//
//  UIView+WHUd.m
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "UIView+WHUd.h"

// Keys for values associated with self
static const NSString * WHToastActivityViewKey      = @"WOOToastActivityViewKey";

@implementation UIView (WHUd)

- (void)showActivityView {
    if (objc_getAssociatedObject(self, &WHToastActivityViewKey)) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor wh_colorWithHexString:@"#000000" alpha:0.65];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    objc_setAssociatedObject(self, &WHToastActivityViewKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hideActivityView {
    MBProgressHUD *hud = (MBProgressHUD *)objc_getAssociatedObject(self, &WHToastActivityViewKey);
    if (hud) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            objc_setAssociatedObject(self, &WHToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        });
    }
}

- (void)showString:(NSString *)string {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor wh_colorWithHexString:@"#000000" alpha:0.65];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = string;
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES afterDelay:2.f];
    });
}


@end
