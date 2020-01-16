//
//  WHAlertTool.h
//  Earth
//
//  Created by colr on 2020/1/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHAlertTool : NSObject

+ (WHAlertTool *)shareInstance;

- (void)showAlterViewWithMessage:(NSString *)message
                    andDoneBlock:(void(^)(UIAlertAction *action))doneBlock;

- (void)showALterViewWithOneButton:(NSString *)title
                        andMessage:(NSString *)message;

- (void)showAlterViewWithTitle:(NSString *)title
                    AndMessage:(NSString *)message
                  andDoneBlock:(void(^)(UIAlertAction *action))doneBlock;

-(void)showAlterViewQuitWithTitle:(NSString*)title
                     andQuitBlock:(void(^)(UIAlertAction * _Nonnull action))quitBlock;

-(void)showAlterViewDeleteWithTitle:(NSString*)title
                            message:(NSString*)message
                        deleteBlock:(void(^)(UIAlertAction * _Nonnull action))deleteBlock;

- (void)showAlterViewWithTitle:(NSString *)title
                       Message:(NSString *)message
                     cancelBtn:(NSString *)cancelTitle
                       doneBtn:(NSString *)doneTitle
                  andDoneBlock:(void(^)(UIAlertAction *action))doneBlock
                andCancelBlock:(void(^)(UIAlertAction *action))cancelBlock;

+ (void)showActionSheetWithTitle:(NSString *)title
                 withActionBlock:(void(^)(UIAlertAction *action))action;

+ (UIViewController *)WHTopViewController;

#pragma mark- 当前VC是否在显示中
+ (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
