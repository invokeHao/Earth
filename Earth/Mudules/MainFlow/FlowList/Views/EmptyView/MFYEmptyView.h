//
//  MFYEmptyView.h
//  Earth
//
//  Created by colr on 2020/4/14.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYEmptyView : UIView

@property (nonatomic, copy)void(^refreshBlock)(void);

@property (nonatomic, strong)UIButton * refreshBtn;

+ (void)showInView:(UIView *)view refreshBlock:(void(^)(void))refresh;

@end

NS_ASSUME_NONNULL_END
