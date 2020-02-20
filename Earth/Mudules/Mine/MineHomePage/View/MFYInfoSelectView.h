//
//  MFYInfoSelectView.h
//  Earth
//
//  Created by colr on 2020/2/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MFYInfoSelectType) {
    MFYInfoAgeType,
    MFYInfoGenderType,
    MFYInfoNameType,
};

typedef void(^confirmBlock)(BOOL needRefresh);

NS_ASSUME_NONNULL_BEGIN

@interface MFYInfoSelectView : UIView

+ (void)showWithType:(MFYInfoSelectType)type completion:(confirmBlock)completion;

- (instancetype)initWithType:(MFYInfoSelectType)type completion:(confirmBlock)comletion;

@end

NS_ASSUME_NONNULL_END
