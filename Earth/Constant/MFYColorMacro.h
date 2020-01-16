//
//  MFYColorMacro.h
//  Earth
//
//  Created by colr on 2019/12/23.
//  Copyright © 2019 fuYin. All rights reserved.
//

#ifndef MFYColorMacro_h
#define MFYColorMacro_h

#define CMSHEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CMSHEXACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define WOOBackgroundColor CMSHEXCOLOR(0x1B1A28)
#define WOOBackgroundColorAlpha(a) CMSHEXACOLOR(0x1B1A28,a)
#define WOONavBarColor CMSHEXCOLOR(0x1B1A28)
#define WOONavBarTitleColor CMSHEXCOLOR(0xFFFFFF)
#define WOODocColorBlue CMSHEXCOLOR(0x7D95FF)
#define WOODocColorWhite CMSHEXCOLOR(0xFFFFFF)
#define WOODocColorBlueDisable CMSHEXACOLOR(0x7D95FF, 0.5)
#define WOODocColorWhiteDetail CMSHEXACOLOR(0xFFFFFF, 0.4)

#define MFYDoc333Title CMSHEXCOLOR(0x333333)

#define MFYefaultImageColor wh_colorWithHexString(@"d4d4d4")

#endif /* MFYColorMacro_h */
