//
//  MFYAddTagView.h
//  Earth
//
//  Created by colr on 2020/2/27.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^confirmBlock)(BOOL needRefreshTag);

NS_ASSUME_NONNULL_BEGIN

@interface MFYAddTagView : UIView

+ (void)showWithCompletion:(confirmBlock)completion;

- (instancetype)initWithCompletion:(confirmBlock)completion;


@end

NS_ASSUME_NONNULL_END
