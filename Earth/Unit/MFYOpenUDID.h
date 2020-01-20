//
//  MFYOpenUDID.h
//  Earth
//
//  Created by colr on 2020/1/19.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kOpenUDIDErrorNone          0
#define kOpenUDIDErrorOptedOut      1
#define kOpenUDIDErrorCompromised   2

@interface MFYOpenUDID : NSObject

+ (NSString*) value;
+ (NSString*) valueWithError:(NSError**)error;
+ (void) setOptOut:(BOOL)optOutValue;


@end

NS_ASSUME_NONNULL_END
