//
//  MFYMessageTableView.h
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYMessageTableView : UITableView

@property(assign,nonatomic)BOOL isFlashToLoad;

- (void)loadMoreMessage;

@end

NS_ASSUME_NONNULL_END
