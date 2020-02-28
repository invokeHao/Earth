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

// GCD related
#define wh_dispatch_time(seconds) dispatch_time(DISPATCH_TIME_NOW, (int64_t)((seconds) * NSEC_PER_SEC))

#define wh_dispatch_after(seconds, block) do { \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((seconds) * NSEC_PER_SEC)), dispatch_get_main_queue(), block);\
} while(0)

#define wh_dispatch_main_async(block) do { \
dispatch_async(dispatch_get_main_queue(), block); \
} while(0)

#define wh_dispath_background_async(block) do { \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block); \
} while(0)


#define MFYNotificationPublishImageSuccess @"MFYNotificationPublishImageSuccess" //发帖颜值贴成功
#define MFYNotificationPublishAudioSuccess @"MFYNotificationPublishAudioSuccess" //发帖声控贴成功

#define MFYTagAddSingal @"MFYTAGADDSINGAL"  //判断为添加按钮

//JChat相关

#define JMESSAGE_APPKEY @"e4d5daa38a8022d73d435949"

#define kuserName @"userName"
#define klastLoginUserName @"lastUserName"
#define kBADGE @"badge"

#define kPassword @"password"
#define kLogin_NotifiCation @"loginNotification"
#define kFirstLogin @"firstLogin"
#define kHaveLogin @"haveLogin"

#define kimgKey @"imgKey"
#define kmessageKey @"messageKey"
#define kupdateUserInfo @"updateUserInfo"
#define KNull @"(null)"
#define KApnsNotification @"apnsNotification"

#define kDBMigrateStartNotification @"DBMigrateStartNotification"
#define kDBMigrateFinishNotification @"DBMigrateFinishNotification"
#define JCHATMAINTHREAD(block) dispatch_async(dispatch_get_main_queue(), block)

#endif /* MFYMacro_h */
