//
//  MFYChatSearchTopView.h
//  Earth
//
//  Created by colr on 2020/3/11.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFYChatSearchView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYChatSearchTopView : UIView

@property (nonatomic, strong)MFYChatSearchView * searchView;

- (void)searchAction:(void (^)(NSString *keywork))action cancelAction:(dispatch_block_t)cancelAction;

@end

NS_ASSUME_NONNULL_END
