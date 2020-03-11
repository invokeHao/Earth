//
//  JMSGConversation+MFYTop.m
//  Earth
//
//  Created by colr on 2020/3/11.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "JMSGConversation+MFYTop.h"

static char *MFYIsTop = "MFYIsTop";

@implementation JMSGConversation (MFYTop)

-(BOOL)isTop {
    NSNumber *isTop = objc_getAssociatedObject(self, &MFYIsTop);
    return [isTop boolValue];
}

- (void)setIsTop:(BOOL)isTop {
    objc_setAssociatedObject(self, &MFYIsTop, @(isTop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
