//
//  MFYCategoryListVC.h
//  Earth
//
//  Created by colr on 2019/12/26.
//  Copyright © 2019 fuYin. All rights reserved.
//

#import "MFYBaseViewController.h"

typedef NS_ENUM(NSUInteger, MFYImageFlowType) {
    MFYImageFlowMainType,
    MFYImageFlowCategroyType
};


NS_ASSUME_NONNULL_BEGIN

@interface MFYImageFlowVC : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong)NSArray * imageTagArray;

- (instancetype)initWithType:(MFYImageFlowType)type;

@end

NS_ASSUME_NONNULL_END
