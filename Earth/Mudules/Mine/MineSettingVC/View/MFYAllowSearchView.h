//
//  MFYAllowSearchView.h
//  Earth
//
//  Created by colr on 2020/2/21.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYAllowSearchView : UIView

@property (strong, nonatomic)void(^modifyBlock)(BOOL isAllow);

- (void)setSearchOn:(BOOL)on;

@end

NS_ASSUME_NONNULL_END
