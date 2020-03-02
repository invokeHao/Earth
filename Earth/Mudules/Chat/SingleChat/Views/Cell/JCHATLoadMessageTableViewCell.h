//
//  JCHATLoadMessageTableViewCell.h
//  Earth
//
//  Created by colr on 2020/3/2.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCHATLoadMessageTableViewCell : UITableViewCell
{
  UIActivityIndicatorView *loadIndicator;
}

- (void)startLoading;

@end

NS_ASSUME_NONNULL_END
