//
//  MOPhotoPreviewNavigationBar.h
//  PhotoLibraryKit
//
//  Created by colr on 2018/6/11.
//  Copyright © 2018年 colr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MOPhotoPreviewNavigationBar;

@protocol MOPhotoPreviewNavigationBarDelegate <NSObject>

- (void)navigationBar:(MOPhotoPreviewNavigationBar *)navigationBar didClickLeftButton:(UIButton *)leftButton;
- (void)navigationBar:(MOPhotoPreviewNavigationBar *)navigationBar didClickRightButton:(UIButton *)rightButton;

@end

@interface MOPhotoPreviewNavigationBar : UIView

@property (nonatomic, weak) id<MOPhotoPreviewNavigationBarDelegate> delegate;

@end
