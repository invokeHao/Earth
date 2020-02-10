//
//  UIView+MOHud.m
//  cosmos
//
//  Created by Lane on 2018/5/27.
//  Copyright © 2018年 Shell&Colr. All rights reserved.
//

#import "UIView+MOHud.h"
#import "UIColor+MOKit.h"

// Keys for values associated with self
static const NSString * CMSToastActivityViewKey      = @"CMSToastActivityViewKey";
static const NSString * CMSToastTextViewKey          = @"CMSToastTextViewKey";

@implementation UIView (MOHud)

- (void)showActivityView {
    if (objc_getAssociatedObject(self, &CMSToastActivityViewKey)) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor cms_colorWithHexString:@"#000000" alpha:0.65];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    objc_setAssociatedObject(self, &CMSToastActivityViewKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hideActivityView {
    MBProgressHUD *hud = (MBProgressHUD *)objc_getAssociatedObject(self, &CMSToastActivityViewKey);
    if (hud) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            objc_setAssociatedObject(self, &CMSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        });
    }
}

- (void)showString:(NSString *)string {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor cms_colorWithHexString:@"#000000" alpha:0.65];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = string;
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES afterDelay:2.f];
    });
}

@end
