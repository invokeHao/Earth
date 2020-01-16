//
//  MFYNavigationBar.h
//  Earth
//
//  Created by colr on 2019/12/16.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYNavigationBar : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;


@end

NS_ASSUME_NONNULL_END
