//
//  MFYPayCardView.h
//  Earth
//
//  Created by colr on 2020/3/13.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYPayCardView : UIView

+ (void)showInView:(UIView *)view completion:(void(^)(BOOL isSuccess))completion;

@end


@interface MFYPayItemView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, strong)UILabel * timesLabel;

@property (nonatomic, strong)UILabel * priceLabel;

@end

NS_ASSUME_NONNULL_END
