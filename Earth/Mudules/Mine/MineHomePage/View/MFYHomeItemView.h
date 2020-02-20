//
//  MFYHomeItemView.h
//  Earth
//
//  Created by colr on 2020/2/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MFYHomeItemType) {
    MFYHomeItemLikeType,
    MFYHomeItemIconType,
    MFYHomeItemInfoType,
    MFYHomeItemSettingType
};

typedef void(^selectBlock)(BOOL isTap);

NS_ASSUME_NONNULL_BEGIN

@interface MFYHomeItemView : UIView

@property (nonatomic, strong) UILabel * subtitleLabel;

@property (nonatomic, strong) YYAnimatedImageView * userIconView;

@property (nonatomic ,strong) YYAnimatedImageView * iconView;

@property (nonatomic ,strong) UILabel * titleLabel;

@property (nonatomic ,strong) selectBlock selectB;

- (instancetype)initWithType:(MFYHomeItemType)type;



@end

NS_ASSUME_NONNULL_END
