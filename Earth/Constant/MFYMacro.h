//
//  MFYMacro.h
//  Earth
//
//  Created by colr on 2019/12/16.
//  Copyright © 2019 fuYin. All rights reserved.
//

#ifndef MFYMacro_h
#define MFYMacro_h

#define VERTICAL_SCREEN_HEIGHT MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define VERTICAL_SCREEN_WIDTH  MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define WINTH_SCALE VERTICAL_SCREEN_WIDTH / 375.0
#define HEIGHT_SCALE VERTICAL_SCREEN_HEIGHT / 667.0
#define W_SCALE(r) (WINTH_SCALE * r)
#define H_SCALE(r) (HEIGHT_SCALE * r)
#define SCREEN_SCALE [UIScreen mainScreen].scale

#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height


// 判断是否是iPhone X
#define IS_IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 判断是否时iPad
#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

//#define IS_IPHONEX [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0
// 状态栏高度
#define STATUS_BAR_HEIGHT (IS_IPHONEX ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (IS_IPHONEX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (IS_IPHONEX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (IS_IPHONEX ? 34.f : 0.f)

//设置format
#define FORMAT(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]

#define WHFont(a) (([[[UIDevice currentDevice] systemVersion] floatValue] >=9.0)? ([UIFont fontWithName:@"PingFangSC-Regular" size:a]):([UIFont systemFontOfSize:a]))

#define WHImageNamed(a) [UIImage imageNamed: a]

// log
#define WHLogMethod(fmt, ...) NSLog((@"%s [%d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define WHLog(fmt, ...) NSLog((@"🍺 " fmt), ##__VA_ARGS__)
#define WHLogError(fmt, ...) NSLog((@"❌ " fmt), ##__VA_ARGS__)
#define WHLogSuccess(fmt, ...) NSLog((@"🚀 " fmt), ##__VA_ARGS__)

#endif /* MFYMacro_h */
