//
//  MOPhotoLibraryNavigationBar.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/7.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOPhotoLibraryConfiguration.h"
@class MOPhotoLibraryNavigationBar;

@protocol PhotoLibraryNavigationBarDelegate <NSObject>

- (void)navigationBar:(MOPhotoLibraryNavigationBar *)navigationBar didClickLeftButton:(UIButton *)leftButton;
- (void)navigationBar:(MOPhotoLibraryNavigationBar *)navigationBar didClickCenterButtonWithSelected:(BOOL)isSelected;
- (void)navigationBar:(MOPhotoLibraryNavigationBar *)navigationBar didClickRightButton:(UIButton *)rightButton;

@end

@interface MOPhotoLibraryNavigationBar : UIView

@property (nonatomic, weak) id<PhotoLibraryNavigationBarDelegate> delegate;

- (void)changePhotoColletionTitle:(NSString*)title;
- (void)changeViewAlpha:(CGFloat)alpha;
- (void)changeRightTitle:(NSString*)title;

- (void)loadWithPhotoLibraryConfiguration:(MOPhotoLibraryConfiguration *)configuration;

// 复原
- (void)recoverEvent;

@end
