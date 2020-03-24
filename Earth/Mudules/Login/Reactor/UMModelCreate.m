//
//  UMModelCreate.m
//  Earth
//
//  Created by colr on 2020/3/12.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "UMModelCreate.h"

#define UM_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define UM_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define IS_HORIZONTAL (UM_SCREEN_WIDTH > UM_SCREEN_WIDTH)


#define UM_Alert_NAV_BAR_HEIGHT      55.0
#define UM_Alert_HORIZONTAL_NAV_BAR_HEIGHT      41.0

//竖屏弹窗
#define UM_Alert_Default_LR_Padding           18.0
#define UM_Alert_LogoImg_Height_Width         60.0
#define UM_Alert_LogoImg_OffetY               12.0
#define UM_Alert_SloganTxt_OffetY             88.0
#define UM_Alert_SloganTxt_Height             24.0
#define UM_Alert_NumberTxt_OffetY             121.0
#define UM_Alert_LoginBtn_OffetY              163.0
#define UM_Alert_LogonBtn_Height              40.0
#define UM_Alert_ChangeWayBtn_OffetY          219.0
#define UM_Alert_Default_Left_Padding         42
#define UM_Alert_Default_Top_Padding          115

/**横屏弹窗*/
#define UM_Alert_Horizontal_Default_Left_Padding      80.0
#define UM_Alert_Horizontal_Default_LR_Padding        18.0
#define UM_Alert_Horizontal_NumberTxt_OffetY          22.5
#define UM_Alert_Horizontal_LoginBtn_OffetY           78.5
#define UM_Alert_Horizontal_LoginBtn_Height           51.0

/**竖屏全屏*/
#define UM_LogoImg_OffetY               32.0
#define UM_SloganTxt_OffetY             150.0
#define UM_SloganTxt_Height             24.0
#define UM_NumberTxt_OffetY             220.0
#define UM_LoginBtn_OffetY              270.0
#define UM_ChangeWayBtn_OffetY          344.0
#define UM_LoginBtn_Height              50.0
#define UM_LogoImg_Height_Width         90.0
#define UM_Default_LR_Padding           18.0
#define UM_Privacy_Bottom_OffetY        13.5

/**横屏全屏*/
#define UM_Horizontal_LogoImg_OffetY               11.0
#define UM_Horizontal_NumberTxt_OffetY             76.0
#define UM_Horizontal_LogoImg_Height_Width         55.0
#define UM_Horizontal_Default_LR_Padding           UM_SCREEN_WIDTH * 0.5 * 0.5
#define UM_Horizontal_LoginBtn_OffetY              122.0
#define UM_Horizontal_Privacy_Bottom_OffetY        13.5


static CGFloat ratio ;

@implementation UMModelCreate

+ (void)load {
    ratio = MAX(UM_SCREEN_WIDTH, UM_SCREEN_HEIGHT) / 667.0;
}
/// 创建横屏全屏的model
+ (UMCustomModel *)createFullScreen {
    
    UMCustomModel *model = [[UMCustomModel alloc] init];
    
    model.navColor = UIColor.clearColor;
    model.navTitle = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,NSFontAttributeName : [UIFont systemFontOfSize:20.0]}];
    model.navIsHidden = YES;
    model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    //model.hideNavBackItem = NO;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    model.navMoreView = rightBtn;
    
    model.privacyNavColor = UIColor.orangeColor;
    model.privacyNavBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
    model.privacyNavTitleFont = [UIFont systemFontOfSize:20.0];
    model.privacyNavTitleColor = UIColor.whiteColor;
    
    model.logoImage = [UIImage imageNamed:@""];
    model.logoIsHidden = YES;
    //model.sloganIsHidden = NO;
    model.sloganText = [[NSAttributedString alloc] initWithString:@"全球风靡的生活圈社交软件" attributes:@{NSForegroundColorAttributeName : wh_colorWithHexString(@"#383838"),NSFontAttributeName : WHFont(25)}];
    model.numberColor = wh_colorWithHexString(@"#383838");
    model.numberFont = WHFont(30);
    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,NSFontAttributeName : WHFont(22)}];
    model.loginBtnBgImgs = @[WHImageNamed(@"autoLogin_btn"),WHImageNamed(@"autoLogin_btn"),WHImageNamed(@"autoLogin_btn")];
    
    //model.autoHideLoginLoading = NO;
    //model.privacyOne = @[@"《隐私1》",@"https://www.taobao.com/"];
    //model.privacyTwo = @[@"《隐私2》",@"https://www.taobao.com/"];
    model.privacyColors = @[UIColor.lightGrayColor, wh_colorWithHexString(@"#FC5B64")];
    model.privacyAlignment = NSTextAlignmentCenter;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13.0];
    model.privacyOperatorPreText = @"《";
    model.privacyOperatorSufText = @"》";
    model.checkBoxIsChecked = YES;
model.checkBoxIsHidden = YES;
    model.checkBoxWH = 17.0;
    model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"切换到其他方式" attributes:@{NSForegroundColorAttributeName : wh_colorWithHexString(@"#FF6CA0"),NSFontAttributeName : [UIFont systemFontOfSize:14.0]}];
    model.changeBtnIsHidden = YES;
    //model.prefersStatusBarHidden = NO;
    model.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    //model.presentDirection = PNSPresentationDirectionBottom;
    
    //授权页默认控件布局调整
    //model.navBackButtonFrameBlock =
    //model.navTitleFrameBlock =
    model.navMoreViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGFloat width = superViewSize.height;
        CGFloat height = width;
        return CGRectMake(superViewSize.width - 15 - width, 0, width, height);
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            frame.origin.y = 20;
            return frame;
        }
        return frame;
    };
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            return CGRectZero; //横屏时模拟隐藏该控件
        } else {
            return CGRectMake(0, 100, superViewSize.width, frame.size.height);
        }
    };
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            frame.origin.y = 100;
        }
        return frame;
    };
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            frame.origin.y = 185;
        }
        return frame;
    };
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        if ([self isHorizontal:screenSize]) {
            return CGRectZero; //横屏时模拟隐藏该控件
        } else {
            return CGRectMake(10, frame.origin.y - 20, superViewSize.width - 20, 30);
        }
    };
    
    //添加自定义控件并对自定义控件进行布局
    __block UILabel *customLabel = UILabel.label;
    [customLabel setText:@"所在国家注册达到100万人开启全球社交"];
    customLabel.WH_textColor(wh_colorWithHexString(@"#666666"));
    customLabel.WH_textAlignment(NSTextAlignmentCenter);
    customLabel.WH_font(WHFont(15));
    customLabel.frame = CGRectMake(0, 0, 270, 16);
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
         [superCustomView addSubview:customLabel];
    };
    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
        CGRect frame = customLabel.frame;
        frame.origin.x = (contentViewFrame.size.width - frame.size.width) * 0.5;
        frame.origin.y = CGRectGetMaxY(sloganFrame) + 20;
        frame.size.width = contentViewFrame.size.width - frame.origin.x * 2;
        customLabel.frame = frame;
    };
    return model;
}

//是否是横屏 YES:横屏 NO:竖屏
+ (BOOL)isHorizontal:(CGSize)size {
    return size.width > size.height;
}

@end
