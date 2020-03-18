//
//  MFYPayCardView.h
//  Earth
//
//  Created by colr on 2020/3/13.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYArticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYPayCardView : UIView

@property (nonatomic, strong)MFYArticle * article;

+ (void)showTheBeforeCard:(MFYArticle *)article Completion:(void (^)(BOOL payed))completion;

@end


@interface MFYPayItemView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong)MFYAudioRereadRechargeProduct * product;

@property (nonatomic, copy)void(^tapBlock)(BOOL isTap);

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, strong)UILabel * timesLabel;

@property (nonatomic, strong)UILabel * priceLabel;

@end

NS_ASSUME_NONNULL_END
