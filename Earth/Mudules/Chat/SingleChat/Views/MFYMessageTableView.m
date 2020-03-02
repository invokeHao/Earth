//
//  MFYMessageTableView.m
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMessageTableView.h"

@implementation MFYMessageTableView

- (void)setContentSize:(CGSize)contentSize
{
  if(_isFlashToLoad){// 去除发消息滚动的影响
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
    {
      if (contentSize.height > self.contentSize.height)
      {
        CGPoint offset = self.contentOffset;
        offset.y += (contentSize.height - self.contentSize.height);
        self.contentOffset = offset;
      }
    }
  }
  _isFlashToLoad = NO;
  [super setContentSize:contentSize];
}

- (void)loadMoreMessage {
  _isFlashToLoad = YES;
  [self reloadData];
}

@end
