//
//  MFYChatSearchView.h
//  Earth
//
//  Created by colr on 2020/3/6.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYChatSearchView : UIView

@property (nonatomic, strong) UITextField *textField;

- (void)setPlaceholder:(NSString *)placeholder searchAction:(void (^)(NSString *keywork))action;

@end

NS_ASSUME_NONNULL_END
