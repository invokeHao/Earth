//
//  MFYBindZFBView.h
//  Earth
//
//  Created by colr on 2020/5/7.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYBindZFBView : UIView

@property (nonatomic, strong)UIButton * submitBtn;

@property (nonatomic, copy)void(^submitBlock)(NSDictionary * infoDic);

@end

NS_ASSUME_NONNULL_END
