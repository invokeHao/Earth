//
//  MFYAudioFLowVC.h
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseViewController.h"

typedef NS_ENUM(NSUInteger, MFYAudioFlowType) {
    MFYAudioFlowMainType,
    MFYAudioFlowCategroyType
};



NS_ASSUME_NONNULL_BEGIN

@interface MFYAudioFLowVC : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong)NSArray * audioTagArray;

- (instancetype)initWithType:(MFYAudioFlowType)type;

@end

NS_ASSUME_NONNULL_END
