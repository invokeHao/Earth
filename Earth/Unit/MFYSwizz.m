//
//  MFYSwizz.m
//  Earth
//
//  Created by colr on 2020/3/12.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYSwizz.h"
#import "MFYResponseObject.h"

@implementation NSObject(MFYSwizz)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation MFYResponseObject(MFYSwizz)

+ (void)load {
    [self exchangeInstanceMethod1:@selector(setCode:) method2:@selector(cms_setCode:)];
}

- (void)cms_setCode:(NSInteger)code {
    [self cms_setCode:code];
    if (code == -21) {
        [MFYLoginManager umengPhoneVerifyLogin];
    }
}

@end

