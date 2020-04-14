//
//  MFYVersionManager.m
//  Earth
//
//  Created by colr on 2020/4/13.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYVersionManager.h"
#import "MFYGlobalConfigService.h"

@interface MFYVersionManager ()

@property (nonatomic, strong)MFYVersionModel * versionModel;

@end

@implementation MFYVersionManager

+ (instancetype)sharedManager {
    static MFYVersionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MFYVersionManager alloc] init];
    });
    return manager;
}


+ (void)mfy_checkTheVerionShowTheVersion:(BOOL)show{
    MFYVersionManager * manager = [MFYVersionManager sharedManager];
    @weakify(manager)
    [MFYGlobalConfigService versionUpDateCheckCompletion:^(MFYVersionModel *  model, NSError *  error) {
        @strongify(manager)
        if (!error) {
            manager.versionModel = model;
            [manager showTheAlterWithModel:model showTheToast:show];
        }
    }];
}

- (void)showTheAlterWithModel:(MFYVersionModel *)model showTheToast:(BOOL)show{
    if (model.update) {
        //强制更新
        if (model.required) {
            [[WHAlertTool shareInstance] showAlterViewWithTitle:@"版本更新" AndMessage:model.updateDesc andDoneBlock:^(UIAlertAction * _Nonnull action) {
                BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.updateUrl]];
                if(isExsit) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.updateUrl] options:@{} completionHandler:^(BOOL success) {}];
                }
            }];
        }else {
            [[WHAlertTool shareInstance] showAlterViewWithTitle:@"版本更新" Message:model.updateDesc cancelBtn:@"取消" doneBtn:@"更新" andDoneBlock:^(UIAlertAction * _Nonnull action) {
                BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.updateUrl]];
                if(isExsit) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.updateUrl] options:@{} completionHandler:^(BOOL success) {}];
                }
            } andCancelBlock:^(UIAlertAction * _Nonnull action) {
                
            }];
        }
    }else {
        if (show) {
            [WHHud showString:@"当前已是最新版本"];
        }
    }
}

@end
