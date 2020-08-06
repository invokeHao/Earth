//
//  WHAlertTool.m
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "WHAlertTool.h"

@implementation WHAlertTool

+(WHAlertTool *)shareInstance {
    static WHAlertTool * ToolInstance =nil;
    static dispatch_once_t predicate ;
    dispatch_once(&predicate, ^{
        ToolInstance = [[self alloc]init];
    });
    return ToolInstance;
}


//警告框确定和取消
-(void)showAlterViewWithMessage:(NSString*)message andDoneBlock:(void(^)(UIAlertAction * _Nonnull action))doneBlock{
    if ([[WHAlertTool WHTopViewController] isKindOfClass:[UIAlertController class]]) {
        return;
    }
    UIAlertController * alterC = [UIAlertController alertControllerWithTitle:nil message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hadShow"];
    }];
    UIAlertAction * doneAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:doneBlock];
    [alterC addAction:cancelAction];
    [alterC addAction:doneAction];
    @try {
        if (IS_IPAD) {
            UIPopoverPresentationController *popPresent = [alterC popoverPresentationController];
            popPresent.sourceView = [WHAlertTool WHTopViewController].view;
        }
        [[WHAlertTool WHTopViewController] presentViewController:alterC animated:YES completion:nil];
    } @catch (NSException *exception) {
        
    } @finally {
    }
}

//警告框只有一个按钮
-(void)showALterViewWithOneButton:(NSString *)title andMessage:(NSString*)message{
    UIAlertController * alterVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alterVC addAction:cancel];
    @try {
        if (IS_IPAD) {
            UIPopoverPresentationController *popPresent = [alterVC popoverPresentationController];
            popPresent.sourceView = [WHAlertTool WHTopViewController].view;
        }
        [[WHAlertTool WHTopViewController] presentViewController:alterVC animated:YES completion:nil];
    } @catch (NSException *exception) {
        
    } @finally {
    }
}

//警告框确定并执行操作
-(void)showAlterViewWithTitle:(NSString*)title AndMessage:(NSString*)message andDoneBlock:(void(^)(UIAlertAction * _Nonnull action))doneBlock{
    UIAlertController * alterC = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:doneBlock];
    [alterC addAction:doneAction];
    @try {
        if (IS_IPAD) {
            UIPopoverPresentationController *popPresent = [alterC popoverPresentationController];
            popPresent.sourceView = [WHAlertTool WHTopViewController].view;
        }
        [[WHAlertTool WHTopViewController] presentViewController:alterC animated:YES completion:nil];
    } @catch (NSException *exception) {
        
    } @finally {
    }
}

-(void)showAlterViewQuitWithTitle:(NSString*)title andQuitBlock:(void(^)(UIAlertAction * _Nonnull action))quitBlock {
    UIAlertController * alterC = [UIAlertController alertControllerWithTitle:title message: @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction * quitAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:quitBlock];
    [alterC addAction:cancelAction];
    [alterC addAction:quitAction];
    @try {
        if (IS_IPAD) {
            UIPopoverPresentationController *popPresent = [alterC popoverPresentationController];
            popPresent.sourceView = [WHAlertTool WHTopViewController].view;
        }
        [[WHAlertTool WHTopViewController] presentViewController:alterC animated:YES completion:nil];
    } @catch (NSException *exception) {
    } @finally {
    }
}

-(void)showAlterViewWithTitle:(NSString*)title Message:(NSString*)message cancelBtn:(NSString*)cancelTitle doneBtn:(NSString*)doneTitle andDoneBlock:(void(^)(UIAlertAction * _Nonnull action))doneBlock andCancelBlock:(void(^)(UIAlertAction * _Nonnull action))cancelBlock{
    UIAlertController * alterC = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:cancelBlock];
    
    UIAlertAction * doneAction = [UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDestructive handler:doneBlock];
    
    [alterC addAction:cancelAction];
    [alterC addAction:doneAction];
    @try {
        if (IS_IPAD) {
            UIPopoverPresentationController *popPresent = [alterC popoverPresentationController];
            popPresent.sourceView = [WHAlertTool WHTopViewController].view;
        }
        [[WHAlertTool WHTopViewController] presentViewController:alterC animated:YES completion:nil];
    } @catch (NSException *exception) {
    } @finally {
    }
}

-(void)showAlterViewDeleteWithTitle:(NSString*)title
                      message:(NSString*)message
               deleteBlock:(void(^)(UIAlertAction * _Nonnull action))deleteBlock {
    UIAlertController * alterC = [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:deleteBlock];
    [alterC addAction:cancelAction];
    [alterC addAction:deleteAction];
    @try {
        if (IS_IPAD) {
            UIPopoverPresentationController *popPresent = [alterC popoverPresentationController];
            popPresent.sourceView = [WHAlertTool WHTopViewController].view;
        }
        [[WHAlertTool WHTopViewController] presentViewController:alterC animated:YES completion:nil];
    } @catch (NSException *exception) {

    } @finally {
    }
}

#pragma mark- actionSheet
//以后再封装多种情况
+ (void)showActionSheetWithTitle:(NSString*)title  withActionBlock:(void(^)(UIAlertAction * _Nonnull action))action {
    UIAlertController * alterVC = [UIAlertController alertControllerWithTitle:@"设置" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * alert1 = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:action];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alterVC addAction:alert1];
    [alterVC addAction:cancel];
    
    if (IS_IPAD) {
        UIPopoverPresentationController *popPresent = [alterVC popoverPresentationController];
        popPresent.sourceView = [WHAlertTool WHTopViewController].view;
    }
    
    [[WHAlertTool WHTopViewController] presentViewController:alterVC animated:YES completion:nil];
}

//获取当前VC
+ (UIViewController *)WHTopViewController{
    return [WHAlertTool WHTopViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)WHTopViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [WHAlertTool WHTopViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [WHAlertTool WHTopViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [WHAlertTool WHTopViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController {
    return (viewController.isViewLoaded && viewController.view.window);
}

@end
