//
//  ChatImageBubble.h
//  Earth
//
//  Created by colr on 2020/2/29.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatBubbleLayer.h"

@interface ChatImageBubble : UIImageView
@property (strong, nonatomic)ChatBubbleLayer *maskBubbleLayer;
@property (assign, nonatomic)BOOL isReceivedBubble;
- (void)setBubbleSide:(BOOL)isReci;
@end
