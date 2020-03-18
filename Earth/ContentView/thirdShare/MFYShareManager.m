//
//  MFYShareManager.m
//  Earth
//
//  Created by colr on 2020/3/18.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYShareManager.h"

@interface MFYShareManager()

@property (nonatomic, strong) NSArray *tencentPermissions;

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, strong)void(^shareResBlock)(BOOL success);

@end

@implementation MFYShareManager

+ (instancetype)sharedManager {
    static MFYShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MFYShareManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupConfig];
    }
    return self;
}


- (void)setupConfig {
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:MFYQQAppkey
                                            andDelegate:self];
    _tencentPermissions = @[@"get_user_info", @"get_simple_userinfo", @"add_t"];
    
    [WXApi registerApp:MFYWeChatAppKey universalLink:MFYUniversalLink];
}


-(BOOL)mfy_thirdPatyHandleTheUrl:(NSURL *)url {
    BOOL result = NO;
//    result = [WeiboSDK handleOpenURL:url delegate:self];
    result = [TencentOAuth HandleOpenURL:url];
    result = [QQApiInterface handleOpenURL:url delegate:self];
    result = [WXApi handleOpenURL:url delegate:self];
    return result;
}

- (BOOL)mfy_handleOpenUniversalLink:(NSUserActivity*)userActivity {
    BOOL result = NO;
    result = [WXApi handleOpenUniversalLink:userActivity delegate:self];
    result = [QQApiInterface handleOpenUniversallink:userActivity.webpageURL delegate:self];
    return result;
}

+ (void)shareToWechatFriend:(BOOL)isFriend article:(MFYArticle *)article completion:(void (^)(BOOL))completion {
    if (![WXApi isWXAppInstalled]) {
        [WHHud showString:@"您没有安装微信"];
        return;
    }
    MFYShareManager * manager = [MFYShareManager sharedManager];
    manager.shareResBlock = completion;
    
    WXMediaMessage *message = [WXMediaMessage message];
    if (article.functionType == 11 ) {
        message.title = article.title;
        message.description = @"我发布了最新动态【全球103个国家，超过300万人在交友】";
        NSURL * coverImageURL = nil;
        MFYItem * item = [article.embeddedArticles firstObject];
        if(item.mediaType == MFYMediavideoType){
            coverImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?vframe/jpg/offset/0.2", item.media.mediaUrl]];

        }else {
            coverImageURL = [NSURL URLWithString:item.media.mediaUrl];
        }
        NSData * imageData = [NSData dataWithContentsOfURL:coverImageURL];
        [message setThumbImage:[UIImage imageWithData:imageData]];
    }else {
        //音频卡片封面
        message.title = @"全球声控社交第一站";
        message.description = @"我发布了最新动态【全球103个国家，超过300万人在交友】";
        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:article.profile.headIconUrl]];
        [message setThumbImage:[UIImage imageWithData:imageData]];
    }
    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = model.url;
    ext.webpageUrl = @"https://www.baidu.com";
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = isFriend ? WXSceneSession : WXSceneTimeline;
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success) {
            WHLogSuccess(@"分享调起成功");
        }
    }];
}

+ (void)shareToQQ:(BOOL)isQQ
         andArticle:(MFYArticle *)article
       completion:(void(^)(BOOL))completion {
    
    MFYShareManager * manager = [MFYShareManager sharedManager];
    manager.shareResBlock = completion;
    
    if (![QQApiInterface isSupportShareToQQ]) {
        [WHHud showString:@"您还没有安装QQ"];
        return;
    }
    NSString *utf8String = @"https://www.baidu.com";
    NSString *title = nil;
    NSString *description = nil;
    NSString *previewImageUrl = nil;
    
    if (article.functionType == 11 ) {
        MFYItem * item = [article.embeddedArticles firstObject];
        title = @"全球颜控社交第一站";
        description = FORMAT(@"%@【全球103个国家，超过300万人在交友】",article.title);
        if(item.mediaType == MFYMediavideoType){
            previewImageUrl = [NSString stringWithFormat:@"%@?vframe/jpg/offset/0.2", item.media.mediaUrl];

        }else {
            previewImageUrl = item.media.mediaUrl;
        }
    }else {
        //音频卡片封面
        title = @"全球声控社交第一站";
        description = @"我发布了最新动态【全球103个国家，超过300万人在交友】";
        previewImageUrl = article.profile.headIconUrl;
    }
    
    QQApiObject *messageObject;
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String]
                                                        title:title
                                                  description:description
                                              previewImageURL:[NSURL URLWithString:previewImageUrl]];
    messageObject = newsObj;
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:messageObject];
    QQApiSendResultCode sent = isQQ ? [QQApiInterface sendReq:req] : [QQApiInterface SendReqToQZone:req];
    if (sent == EQQAPISENDSUCESS) {
        WHLogSuccess(@"调起分享成功");
    }else {
        
    }
}


- (void)isOnlineResponse:(NSDictionary *)response {
    
}

- (void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"微信分享"];
        SendAuthResp *aresp = (SendAuthResp *)resp;
        NSString *strMsg;
        if (aresp.errCode == 0) {
            strMsg = NSLocalizedString(@"分享成功！", @"");
        }else{
            strMsg = NSLocalizedString(@"分享失败！", @"");
        }
        
        [[WHAlertTool shareInstance] showALterViewWithOneButton:strTitle andMessage:strMsg];
    }
    //微信和QQ回调的方法名相同所以暂时放在一起了
    if (resp.type == ESENDMESSAGETOQQRESPTYPE) {
        SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
        if ([sendResp.result isEqualToString:@"0"]) {
            if (self.shareResBlock) {
                self.shareResBlock(YES);
            }
            [[WHAlertTool shareInstance] showALterViewWithOneButton:@"QQ分享" andMessage:@"分享成功"];
        }
        else {
            [[WHAlertTool shareInstance] showALterViewWithOneButton:@"QQ分享" andMessage:@"分享失败"];
        }
    }
}

#pragma mark- TencentSessionDelegate

- (void)tencentDidLogin {}

- (void)tencentDidNotLogin:(BOOL)cancelled {}

- (void)tencentDidNotNetWork {}



@end
