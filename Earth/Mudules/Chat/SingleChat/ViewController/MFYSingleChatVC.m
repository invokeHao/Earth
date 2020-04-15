//
//  MFYSingleChatVC.m
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYSingleChatVC.h"
#import "JCHATSendMsgManager.h"
#import "JCHATStringUtils.h"
#import "JCHATChatModel.h"
#import "JCHATMessageTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JCHATLoadMessageTableViewCell.h"
#import "JCHATShowTimeCell.h"
#import "MFYChatToolBar.h"
#import "MFYMessageTextView.h"
#import "MFYPublicManager.h"
#import "MFYPhotosManager.h"

#define KMoreviewHeight  (211 + HOME_INDICATOR_HEIGHT)
#define KToolviewHeight 57

@interface MFYSingleChatVC ()
{
@private
    BOOL isNoOtherMessage;
    NSInteger messageOffset;
    NSMutableArray *_imgDataArr;
    JMSGConversation *_conversation;//
    NSMutableDictionary *_allMessageDic; //缓存所有的message model
    NSMutableArray *_allmessageIdArr; //按序缓存后有的messageId， 于allMessage 一起使用
    NSMutableArray *_userArr;//
    NSMutableDictionary *_refreshAvatarUsersDic;
}

@property (nonatomic, strong)UIButton * rightInfoBtn;

@property (nonatomic, strong)MFYPublicManager * publicManager;

@end

@implementation MFYSingleChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    _refreshAvatarUsersDic = [NSMutableDictionary dictionary];
    _allMessageDic = [NSMutableDictionary dictionary];
    _allmessageIdArr = [NSMutableArray array];
    _imgDataArr = [NSMutableArray array];
    
    [_conversation clearUnreadCount];
    
    [self setupView];
    [self addNotification];
    [self addDelegate];
    [self getGroupMemberListWithGetMessageFlag:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    WHLog(@"Event - viewWillAppear");
    [super viewWillAppear:animated];
    
    @weakify(self)
    [_conversation refreshTargetInfoFromServer:^(id resultObject, NSError *error) {
        WHLog(@"refresh nav right button");
        @strongify(self)
        // 禁用 iOS7 返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        [self.messageTableView reloadData];
    }];
  
}

- (void)updateGroupConversationTittle:(JMSGGroup *)newGroup {
    
  
  [self getGroupMemberListWithGetMessageFlag:NO];
  if (self.isConversationChange) {
    [self cleanMessageCache];
    [self getPageMessage];
    self.isConversationChange = NO;
  }
}

- (void)viewDidLayoutSubviews {
    WHLog(@"Event - viewDidLayoutSubviews");
    [self scrollToBottomAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
  WHLog(@"Event - viewWillDisappear");
  [super viewWillDisappear:animated];
  [_conversation clearUnreadCount];
//  [[JCHATAudioPlayerHelper shareInstance] stopAudio];
//  [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
}

#pragma mark --释放内存
- (void)dealloc {
    WHLog(@"Action -- dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.toolBarContainer.toolbar.MessagetextView removeObserver:self forKeyPath:@"contentSize"];
    //remove delegate
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
    [JMessage removeDelegate:self withConversation:_conversation];
}

- (void)setupView {
  [self setupNavigation];
  [self setupComponentView];
}

- (void)setupComponentView {
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapClick:)];
    [self.view addGestureRecognizer:gesture];
    self.view.backgroundColor = wh_colorWithHexString(@"#F7F8FC");
    [self.view addSubview:self.messageTableView];
    [self.view addSubview:self.toolBarContainer];
    [self.view addSubview:self.moreView];
    
    
  self.toolBarContainer.toolbar.MessagetextView.text = [[JCHATSendMsgManager ins] draftStringWithConversation:_conversation];
    
  [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT);
      make.left.right.mas_equalTo(0);
      make.bottom.mas_equalTo(- (57 + HOME_INDICATOR_HEIGHT));
  }];
  
//  _moreViewContainer.moreView.delegate = self;
//  _moreViewContainer.moreView.backgroundColor = messageTableColor;
}

- (void)setupNavigation {
    self.navBar.backgroundColor = wh_colorWithHexString(@"#FFFFFF");
    self.navBar.rightButton = self.rightInfoBtn;
    NSString * nickName = self.userProfile? self.userProfile.nickname : self.nickName;
    self.navBar.titleLabel.text = nickName;
    self.navBar.titleLabel.textColor = wh_colorWithHexString(@"#333333");
    [self.navBar.leftButton setImage:WHImageNamed(@"chat_nav_back") forState:UIControlStateNormal];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)getGroupMemberListWithGetMessageFlag:(BOOL)getMesageFlag {
  if (self.conversation && self.conversation.conversationType == kJMSGConversationTypeGroup) {
    JMSGGroup *group = nil;
    group = self.conversation.target;
    _userArr = [NSMutableArray arrayWithArray:[group memberArray]];
    [self isContantMeWithUserArr:_userArr];
    if (getMesageFlag) {
      [self getPageMessage];
    }
  } else {
    if (getMesageFlag) {
      [self getPageMessage];
        
    }
  }
}

- (void)isContantMeWithUserArr:(NSMutableArray *)userArr {
  BOOL hideFlag = YES;
  for (NSInteger i =0; i< [userArr count]; i++) {
    JMSGUser *user = [userArr objectAtIndex:i];
    if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
      hideFlag = NO;
      break;
    }
  }
    if (!hideFlag) {
        [self reloadAllCellAvatarImage];
    }
}


- (void)setTitleWithUser:(JMSGUser *)user {
  self.title = _conversation.title;
}

#pragma mark --JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
  WHLog(@"Event - sendMessageResponse");
    
  if (message != nil) {
    NSLog(@"发送的 Message:  %@",message);
  }
    [self relayoutTableCellWithMessage:message];
  
  if (error != nil) {
    WHLog(@"Send response error - %@", error);
    [_conversation clearUnreadCount];
    NSString *alert = [JCHATStringUtils errorAlert:error];
    if (alert == nil) {
      alert = [error description];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
      [WHHud showString:alert];
    return;
  }
    
  JCHATChatModel *model = _allMessageDic[message.msgId];
  if (!model) {
    return;
  }
}

#pragma mark --收到消息
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    
    if (message != nil) {
    }
    if (error != nil) {
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setErrorMessageChatModelWithError:error];
        [self addMessage:model];
        return;
    }

    if (![self.conversation isMessageForThisConversation:message]) {
        return;
    }

    if (message.contentType == kJMSGContentTypeCustom) {
        return;
    }
    WHLog(@"Event - receiveMessageNotification");
    
    @weakify(self)
    JCHATMAINTHREAD((^{
        @strongify(self)
        if (!message) {
          WHLog(@"get the nil message .");
          return;
        }

//        if (_allMessageDic[message.msgId] != nil) {
//          WHLog(@"该条消息已加载");
//          return;
//        }

        if (message.contentType == kJMSGContentTypeEventNotification) {
          if (((JMSGEventContent *)message.content).eventType == kJMSGEventNotificationRemoveGroupMembers
              && ![((JMSGGroup *)self.conversation.target) isMyselfGroupMember]) {
            [self setupNavigation];
          }
        }

        if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
        } else if (![((JMSGGroup *)self.conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
          return;
        }
        
        JCHATChatModel *model = [self->_allMessageDic objectForKey:message.msgId];
        if (model) {// 说明已经加载，说明可能是同步下来的多媒体消息，下载完成，然后再次收到就去刷新
            model.message = message;
            [self refreshCellMessageMediaWithChatModel:model];
        }else{
            
            NSString *firstMsgId = [self->_allmessageIdArr firstObject];
            JCHATChatModel *firstModel = [self->_allMessageDic objectForKey:firstMsgId];
            if (message.timestamp < firstModel.message.timestamp) {
                // 比数组中最老的消息时间都小的，无需加入界面显示，下次翻页时会加载
                return ;
            }
            
            model = [[JCHATChatModel alloc] init];
            [model setChatModelWith:message conversationType:self.conversation];
            if (message.contentType == kJMSGContentTypeImage) {
                [self->_imgDataArr addObject:model];
            }
            model.photoIndex = [self->_imgDataArr count] -1;
            [self addmessageShowTimeData:message.timestamp];
            [self addMessage:model];
            
            BOOL isHaveCache = NO;
            NSString *key = [NSString stringWithFormat:@"%@_%@",message.fromUser.username,message.fromUser.appKey];
            NSMutableArray *messages = self->_refreshAvatarUsersDic[key];
            if (messages) {
                isHaveCache = YES;
                [messages addObject:message];
            }else{
                messages = [NSMutableArray array];
                [messages addObject:message];
            }
            if (messages.count > 10) {
                [messages removeObjectAtIndex:0];
            }
            [self->_refreshAvatarUsersDic setObject:messages forKey:key];
            
            [self chcekReceiveMessageAvatarWithReceiveNewMessage:message];
//            if (!isHaveCache) {
//                [strongSelf performSelector:@selector(chcekReceiveMessageAvatarWithReceiveNewMessage:) withObject:message afterDelay:1.5];
//            }
        }
  }));
}

- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
  if (![self.conversation isMessageForThisConversation:message]) {
    return;
  }
  
  WHLog(@"Event - receiveMessageNotification");
  JCHATMAINTHREAD((^{
      if (!message) {
          WHLog(@"get the nil message .");
          return;
      }
      
      if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
      } else if (![((JMSGGroup *)self.conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
          return;
      }
    
      JCHATChatModel *model = [self->_allMessageDic objectForKey:message.msgId];
      if (model) {// 说明已经加载，说明可能是同步下来的多媒体消息，下载完成，然后再次收到就去刷新
          model.message = message;
          [self refreshCellMessageMediaWithChatModel:model];
      }else{
          model = [[JCHATChatModel alloc] init];
          [model setChatModelWith:message conversationType:self.conversation];
          if (message.contentType == kJMSGContentTypeImage) {
              [self->_imgDataArr addObject:model];
          }
          model.photoIndex = [self->_imgDataArr count] -1;
          [self addmessageShowTimeData:message.timestamp];
          [self addMessage:model];
      }
    
  }));
}
- (void)onSyncOfflineMessageConversation:(JMSGConversation *)conversation
                         offlineMessages:(NSArray<__kindof JMSGMessage *> *)offlineMessages {
    WHLog(@"Action -- onSyncOfflineMessageConversation:offlineMessages:");
    
    if (conversation.conversationType != self.conversation.conversationType) {
        return ;
    }
    BOOL isThisConversation = NO;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user1 = (JMSGUser *)conversation.target;
        JMSGUser *user2 = (JMSGUser *)self.conversation.target;
        if ([user1.username isEqualToString:user2.username] &&
            [user1.appKey isEqualToString:user2.appKey]) {
            isThisConversation = YES;
        }
    }else{
        JMSGGroup *group1 = (JMSGGroup *)conversation.target;
        JMSGGroup *group2 = (JMSGGroup *)conversation.target;
        if ([group1.gid isEqualToString:group2.gid]) {
            isThisConversation = YES;
        }
    }
    
    if (!isThisConversation) {
        return ;
    }
    
    NSMutableArray *pathsArray = [NSMutableArray array];
    NSMutableArray *allSyncMessages = [NSMutableArray arrayWithArray:offlineMessages];
    for (int i = 0; i< allSyncMessages.count; i++) {
        JMSGMessage *message = allSyncMessages[i];
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr addObject:model];
        }
        model.photoIndex = [_imgDataArr count] -1;
        
        [_allMessageDic setObject:model forKey:model.message.msgId];
        [_allmessageIdArr addObject:model.message.msgId];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0];
        [pathsArray addObject:path];
    }
    if (pathsArray.count) {
        [_messageTableView beginUpdates];
        [_messageTableView insertRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationNone];
        [_messageTableView endUpdates];
        [self scrollToEnd];
    }
}

- (void)onSyncRoamingMessageConversation:(JMSGConversation *)conversation {
    WHLog(@"Action -- onSyncRoamingMessageConversation:");
    
    if (conversation.conversationType != self.conversation.conversationType) {
        return ;
    }
    BOOL isThisConversation = NO;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user1 = (JMSGUser *)conversation.target;
        JMSGUser *user2 = (JMSGUser *)self.conversation.target;
        if ([user1.username isEqualToString:user2.username] &&
            [user1.appKey isEqualToString:user2.appKey]) {
            isThisConversation = YES;
        }
    }else{
        JMSGGroup *group1 = (JMSGGroup *)conversation.target;
        JMSGGroup *group2 = (JMSGGroup *)conversation.target;
        if ([group1.gid isEqualToString:group2.gid]) {
            isThisConversation = YES;
        }
    }
    
    if (!isThisConversation) {
        return ;
    }
    
    isNoOtherMessage = NO;
    messageOffset = 0;
    [_imgDataArr removeAllObjects];
    [_userArr removeAllObjects];
    
    [_allMessageDic removeAllObjects];
    [_allmessageIdArr removeAllObjects];
    [_imgDataArr removeAllObjects];
    
    [self getGroupMemberListWithGetMessageFlag:YES];
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
  [self updateGroupConversationTittle:group];
}

- (void)relayoutTableCellWithMessage:(JMSGMessage *) message{
    WHLog(@"relayoutTableCellWithMessage: msgid:%@",message.msgId);
    if ([message.msgId isEqualToString:@""]) {
        return;
    }
    
    JCHATChatModel *model = _allMessageDic[message.msgId];
    if (model) {
        model.message = message;
        [_allMessageDic setObject:model forKey:message.msgId];
    }
    
    NSInteger index = [_allmessageIdArr indexOfObject:message.msgId];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    JCHATMessageTableViewCell *tableviewcell = [_messageTableView cellForRowAtIndexPath:indexPath];
    tableviewcell.model = model;
    [tableviewcell layoutAllView];
    
//    [_messageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark --获取对应消息的索引
- (NSInteger )getIndexWithMessageId:(NSString *)messageID {
  for (NSInteger i=0; i< [_allmessageIdArr count]; i++) {
    NSString *getMessageID = _allmessageIdArr[i];
    if ([getMessageID isEqualToString:messageID]) {
      return i;
    }
  }
  return 0;
}

- (bool)checkDevice:(NSString *)name {
  NSString *deviceType = [UIDevice currentDevice].model;
  WHLog(@"deviceType = %@", deviceType);
  NSRange range = [deviceType rangeOfString:name];
  return range.location != NSNotFound;
}

#pragma mark -- 清空消息缓存
- (void)cleanMessageCache {
  [_allMessageDic removeAllObjects];
  [_allmessageIdArr removeAllObjects];
  [self.messageTableView reloadData];
}

#pragma mark --添加message
- (void)addMessage:(JCHATChatModel *)model {
  if (model.isTime) {
    [_allMessageDic setObject:model forKey:model.timeId];
    [_allmessageIdArr addObject:model.timeId];
    [self addCellToTabel];
    return;
  }
  [_allMessageDic setObject:model forKey:model.message.msgId];
  [_allmessageIdArr addObject:model.message.msgId];
  [self addCellToTabel];
}

NSInteger sortMessageType(id object1,id object2,void *cha) {
  JMSGMessage *message1 = (JMSGMessage *)object1;
  JMSGMessage *message2 = (JMSGMessage *)object2;
  if([message1.timestamp integerValue] > [message2.timestamp integerValue]) {
    return NSOrderedDescending;
  } else if([message1.timestamp integerValue] < [message2.timestamp integerValue]) {
    return NSOrderedAscending;
  }
  return NSOrderedSame;
}

- (void)AlertToSendImage:(NSNotification *)notification {
  UIImage *img = notification.object;
  [self prepareImageMessage:img];
}

- (void)deleteMessage:(NSNotification *)notification {
  JMSGMessage *message = notification.object;
  [_conversation deleteMessageWithMessageId:message.msgId];
  [_allMessageDic removeObjectForKey:message.msgId];
  [_allmessageIdArr removeObject:message.msgId];
  [_messageTableView loadMoreMessage];
}

#pragma mark --排序conversation
- (NSMutableArray *)sortMessage:(NSMutableArray *)messageArr {
  NSArray *sortResultArr = [messageArr sortedArrayUsingFunction:sortMessageType context:nil];
  return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)getPageMessage {
  WHLog(@"Action - getAllMessage");
  [self cleanMessageCache];
  NSMutableArray * arrList = [[NSMutableArray alloc] init];
  [_allmessageIdArr addObject:[[NSObject alloc] init]];
  
  messageOffset = messagefristPageNumber;
  [arrList addObjectsFromArray:[[[_conversation messageArrayFromNewestWithOffset:@0 limit:@(messageOffset)] reverseObjectEnumerator] allObjects]];
  if ([arrList count] < messagefristPageNumber) {
    isNoOtherMessage = YES;
    [_allmessageIdArr removeObjectAtIndex:0];
  }
  
  for (NSInteger i=0; i< [arrList count]; i++) {
    JMSGMessage *message = [arrList objectAtIndex:i];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation];
    if (message.contentType == kJMSGContentTypeImage) {
      [_imgDataArr addObject:model];
      model.photoIndex = [_imgDataArr count] - 1;
    }
    
    [self dataMessageShowTime:message.timestamp];
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allmessageIdArr addObject:model.message.msgId];
  }
  [_messageTableView reloadData];
  [self scrollToBottomAnimated:NO];
}

- (void)flashToLoadMessage {
    NSMutableArray * arrList = @[].mutableCopy;
    NSArray *newMessageArr = [_conversation messageArrayFromNewestWithOffset:@(messageOffset) limit:@(messagePageNumber)];
    [arrList addObjectsFromArray:newMessageArr];
    if ([arrList count] < messagePageNumber) {// 判断还有没有新数据
        isNoOtherMessage = YES;
        [_allmessageIdArr removeObjectAtIndex:0];
    }
    
    messageOffset += messagePageNumber;
    for (NSInteger i = 0; i < [arrList count]; i++) {
        JMSGMessage *message = arrList[i];
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr insertObject:model atIndex:0];
            model.photoIndex = [_imgDataArr count] - 1;
        }
        
        [_allMessageDic setObject:model forKey:model.message.msgId];
        [_allmessageIdArr insertObject:model.message.msgId atIndex: isNoOtherMessage?0:1];
        [self dataMessageShowTimeToTop:message.timestamp];// FIXME:
    }
    
    [_messageTableView loadMoreMessage];
}

- (JMSGUser *)getAvatarWithTargetId:(NSString *)targetId {
    
  for (NSInteger i=0; i<[_userArr count]; i++) {
    JMSGUser *user = [_userArr objectAtIndex:i];
    if ([user.username isEqualToString:targetId]) {
      return user;
    }
  }
  return nil;
}

//- (XHVoiceRecordHelper *)voiceRecordHelper {
//  if (!_voiceRecordHelper) {
//    WEAKSELF
//    _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
//
//    _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
//      WHLog(@"已经达到最大限制时间了，进入下一步的提示");
//      __strong __typeof(weakSelf)strongSelf = weakSelf;
//      [strongSelf finishRecorded];
//    };
//
//    _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
//      __strong __typeof(weakSelf)strongSelf = weakSelf;
//      strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
//    };
//
//    _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
//  }
//  return _voiceRecordHelper;
//}
//
//- (XHVoiceRecordHUD *)voiceRecordHUD {
//  if (!_voiceRecordHUD) {
//    _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
//  }
//  return _voiceRecordHUD;
//}

- (void)backClick {
  if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressVoiceBtnToHideKeyBoard {///!!!
  [self.toolBarContainer.toolbar.MessagetextView resignFirstResponder];
//  _toolBarHeightConstrait.constant = 45;
  [self dropToolBar];
}

- (void)switchToTextInputMode {
  MFYMessageTextView *inputview = self.toolBarContainer.toolbar.MessagetextView;
  [inputview becomeFirstResponder];
  [self layoutAndAnimateMessageInputTextView:inputview];
}
#pragma mark --增加朋友
- (void)addFriends
{
//    JCHATGroupDetailViewController *groupDetailCtl = [[JCHATGroupDetailViewController alloc] init];
//    groupDetailCtl.hidesBottomBarWhenPushed = YES;
//    groupDetailCtl.conversation = _conversation;
//    groupDetailCtl.sendMessageCtl = self;
//    [self.navigationController pushViewController:groupDetailCtl animated:YES];
}

#pragma mark -调用相册
- (void)photoClick {
    [self.publicManager publishPhotoFromVC:self publishType:MFYPublicTypeChat completion:^(MFYAssetModel * _Nullable model) {
        [[MFYPhotosManager sharedManager] requestImageDataWithAsset:model.asset completion:^(NSData * _Nonnull imageData, NSString * _Nonnull dataUTI, UIImageOrientation orientation, NSDictionary * _Nonnull assetInfo) {
            UIImage * image = [YYImage imageWithData:imageData];
            [self prepareImageMessage:image];
            [self dropToolBarNoAnimate];
        }];
    }];
}

//#pragma mark --调用相机
//- (void)cameraClick {
//  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//
//  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    NSString *requiredMediaType = ( NSString *)kUTTypeImage;
//    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
//    [picker setMediaTypes:arrMediaTypes];
//    picker.showsCameraControls = YES;
//    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    picker.editing = YES;
//    picker.delegate = self;
//    [self presentViewController:picker animated:YES completion:nil];
//  }
//}
//
//#pragma mark - UIImagePickerController Delegate
////相机,相册Finish的代理
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//
//  if ([mediaType isEqualToString:@"public.movie"]) {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [WHHud showString:@"不支持视频发送"];
//    return;
//  }
//  UIImage *image;
//  image = [info objectForKey:UIImagePickerControllerOriginalImage];
//  [self prepareImageMessage:image];
//  [self dropToolBarNoAnimate];
//  [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark --发送图片
- (void)prepareImageMessage:(UIImage *)img {
  WHLog(@"Action - prepareImageMessage");
  img = [img resizedImageByWidth:upLoadImgWidth];
  
  JMSGMessage* message = nil;
  JCHATChatModel *model = [[JCHATChatModel alloc] init];
  JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:UIImagePNGRepresentation(img)];
  if (imageContent) {
    message = [_conversation createMessageWithContent:imageContent];
    [[JCHATSendMsgManager ins] addMessage:message withConversation:_conversation];
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    [_imgDataArr addObject:model];
    model.photoIndex = [_imgDataArr count] - 1;
    [model setupImageSize];
    [self addMessage:model];
  }
}

#pragma mark --
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --add Delegate
- (void)addDelegate {
  [JMessage addDelegate:self withConversation:self.conversation];
}

#pragma mark --加载通知
- (void)addNotification{
  //给键盘注册通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillShow:)
   
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(cleanMessageCache)
                                               name:kDeleteAllMessage
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(AlertToSendImage:)
                                               name:kAlertToSendImage
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(deleteMessage:)
                                               name:kDeleteMessage
                                             object:nil];

  [self.toolBarContainer.toolbar.MessagetextView addObserver:self
                                           forKeyPath:@"contentSize"
                                              options:NSKeyValueObservingOptionNew
                                              context:nil];
//  self.toolBarContainer.toolbar.MessagetextView.delegate = self;
}

- (void)inputKeyboardWillShow:(NSNotification *)notification{
  _barBottomFlag=NO;
//  CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
  [UIView animateWithDuration:animationTime animations:^{
      self.moreView.hidden = YES;
      [self.view layoutIfNeeded];
  }];
  [self scrollToEnd];
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//  [UIView animateWithDuration:animationTime animations:^{
//
//    [self.view layoutIfNeeded];
//  }];
//  [self scrollToBottomAnimated:NO];
    
    CGFloat moveY = keyBoardFrame.origin.y - VERTICAL_SCREEN_HEIGHT;
    WHLog(@"moveF==%f",moveY);
    [UIView animateWithDuration:animationTime animations:^{
        self.messageTableView.transform = CGAffineTransformMakeTranslation(0, moveY);
        self.toolBarContainer.transform = CGAffineTransformMakeTranslation(0, moveY);
    }];

}

#pragma mark --发送文本
- (void)sendText:(NSString *)text {
  [self prepareTextMessage:text];
}

#pragma mark- 发送语音
- (void)finishRecoderAudioPath:(NSString *)audioPath audioDuration:(NSString *)audioDuration {
    [self SendMessageWithVoice:audioPath voiceDuration:audioDuration];
}

- (void)perform {
    WHLog(@"moreView的heigh设置为空");
//  _moreViewHeight.constant = 0;
//  _toolBarToBottomConstrait.constant = 0;
}

#pragma mark --返回下面的位置
- (void)dropToolBar {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 31;
  _toolBarContainer.toolbar.faceButton.selected = NO;
  [_messageTableView reloadData];
    CGFloat moveY = 0;
  [UIView animateWithDuration:0.2 animations:^{
      self.messageTableView.transform = CGAffineTransformMakeTranslation(0, moveY);
      self.toolBarContainer.transform = CGAffineTransformMakeTranslation(0, moveY);
      self.moreView.hidden = YES;
  } completion:^(BOOL finished) {
      if (finished) {
      }
  }];
}

- (void)dropToolBarNoAnimate {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 31;
  self.toolBarContainer.toolbar.faceButton.selected = NO;
  [_messageTableView reloadData];
//  _toolBarToBottomConstrait.constant = 0;
//  _moreViewHeight.constant = 0;
}

#pragma mark --按下功能响应
- (void)pressMoreBtnClick:(UIButton *)btn {
  _barBottomFlag=NO;
  [_toolBarContainer.toolbar.MessagetextView resignFirstResponder];
    CGFloat moveY = - (KMoreviewHeight - KToolviewHeight + 20);
    CGFloat moveH = - (KMoreviewHeight - KToolviewHeight + 20);
//    toolFrame.origin.y = VERTICAL_SCREEN_HEIGHT - KMoreviewHeight - KToolviewHeight;

  [UIView animateWithDuration:0.25 animations:^{
//      [self.messageTableView layoutIfNeeded];
      self.messageTableView.transform = CGAffineTransformMakeTranslation(0, moveY);
      self.toolBarContainer.transform = CGAffineTransformMakeTranslation(0, moveH);
//      self.toolBarContainer.frame = toolFrame;
      self.moreView.hidden = NO;
  }];
  [_toolBarContainer.toolbar switchToolbarToTextMode];
  [self scrollToBottomAnimated:NO];
}

- (void)noPressmoreBtnClick:(UIButton *)btn {
  [_toolBarContainer.toolbar.MessagetextView becomeFirstResponder];
}

#pragma mark ----发送文本消息
- (void)prepareTextMessage:(NSString *)text {
    
    WHLog(@"Action - prepareTextMessage");
    if ([text isEqualToString:@""] || text == nil) {
        return;
    }
    [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:@""];
    JMSGMessage *message = nil;
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    
    message = [_conversation createMessageWithContent:textContent];//!
    
    [_conversation sendMessage:message];
    
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    [self addMessage:model];
}

#pragma mark -- 刷新对应的
- (void)addCellToTabel {
  NSIndexPath *path = [NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0];
  [_messageTableView beginUpdates];
  [_messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  [_messageTableView endUpdates];
  [self scrollToEnd];
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)addmessageShowTimeData:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([_allmessageIdArr count] > 0 && lastModel.isTime == NO) {
      
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      [self addTimeData:timeInterVal];
    }
  } else if ([_allmessageIdArr count] == 0) {//首条消息显示时间
    [self addTimeData:timeInterVal];
  } else {
    WHLog(@"不用显示时间");
  }
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];//!
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allmessageIdArr addObject:timeModel.timeId];
    }
  } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];//!
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allmessageIdArr addObject:timeModel.timeId];
  } else {
    WHLog(@"不用显示时间");
  }
}

- (void)dataMessageShowTimeToTop:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allmessageIdArr insertObject:timeModel.timeId atIndex: isNoOtherMessage?0:1];
    }
  } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allmessageIdArr insertObject:timeModel.timeId atIndex: isNoOtherMessage?0:1];
  } else {
    WHLog(@"不用显示时间");
  }
}

- (void)addTimeData:(NSTimeInterval)timeInterVal {
  JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
  timeModel.timeId = [self getTimeId];
  timeModel.isTime = YES;
  timeModel.messageTime = @(timeInterVal);
  timeModel.contentHeight = [timeModel getTextHeight];//!
  [self addMessage:timeModel];
}

- (NSString *)getTimeId {
  NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
  return timeId;
}


- (void)tapClick:(UIGestureRecognizer *)gesture {
    [self.toolBarContainer.toolbar.MessagetextView resignFirstResponder];
    [self dropToolBar];
}

#pragma mark --滑动至尾端
- (void)scrollToEnd {
  if ([_allmessageIdArr count] != 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  }
}

#pragma mark - tableView datasoce
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!isNoOtherMessage) {
    if (indexPath.row == 0) { //这个是第 0 行 用于刷新
      return 40;
    }
  }
    
    if (indexPath.row >= _allmessageIdArr.count) {
        WHLog(@"1.index %ld beyond bounds %ld",indexPath.row,_allmessageIdArr.count);
        return 40;
    }
  NSString *messageId = _allmessageIdArr[indexPath.row];
  JCHATChatModel *model = _allMessageDic[messageId];
  if (model.isTime == YES) {
    return 31;
  }
  
  if (model.message.contentType == kJMSGContentTypeEventNotification) {
    return model.contentHeight + 17;
  }
  
  if (model.message.contentType == kJMSGContentTypeText) {
    return model.contentHeight + 17;
  } else if (model.message.contentType == kJMSGContentTypeImage ||
             model.message.contentType == kJMSGContentTypeFile ||
             model.message.contentType == kJMSGContentTypeLocation) {
    if (model.imageSize.height == 0) {
      [model setupImageSize];
    }
    return model.imageSize.height < 44?59:model.imageSize.height + 14;
    
  } else if (model.message.contentType == kJMSGContentTypeVoice) {
    return 69;
  }  else {
    return 49;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_allmessageIdArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isNoOtherMessage) {
        if (indexPath.row == 0) {
          static NSString *cellLoadIdentifier = @"loadCell"; //name
          JCHATLoadMessageTableViewCell *cell = (JCHATLoadMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellLoadIdentifier];
          
          if (cell == nil) {
            cell = [[JCHATLoadMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellLoadIdentifier];
          }
          [cell startLoading];
            [self flashToLoadMessage];
//          [self performSelector:@selector(flashToLoadMessage) withObject:nil afterDelay:0];
          return cell;
        }
    }
    if (indexPath.row >= _allmessageIdArr.count) {
        WHLog(@"2.index %ld beyond bounds %ld",indexPath.row,_allmessageIdArr.count);
        return nil;
    }
    NSString *messageId = _allmessageIdArr[indexPath.row];
    if (!messageId) {
        WHLog(@"messageId is nil%@",messageId);
        return nil;
    }

    JCHATChatModel *model = _allMessageDic[messageId];
    if (!model) {
        WHLog(@"JCHATChatModel is nil%@", messageId);
        return nil;
    }

    if (model.isTime == YES || model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
        static NSString *cellIdentifier = @"timeCell";
        JCHATShowTimeCell *cell = (JCHATShowTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (cell == nil) {
            cell = [[JCHATShowTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        if (model.isErrorMessage) {
          cell.messageTimeLabel.text = [NSString stringWithFormat:@"%@ 错误码:%ld",st_receiveErrorMessageDes,model.messageError.code];
          return cell;
        }

        if (model.message.contentType == kJMSGContentTypeEventNotification) {
          cell.messageTimeLabel.text = [((JMSGEventContent *)model.message.content) showEventNotification];
        } else {
          cell.messageTimeLabel.text = [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
        }
        return cell;

    } else {
        static NSString *cellIdentifier = @"MessageCell";
        JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (cell == nil) {
          cell = [[JCHATMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
          cell.conversation = _conversation;
        }

        [cell setCellData:model delegate:self indexPath:indexPath];
        @weakify(self)
        cell.messageTableViewCellRefreshMediaMessage = ^(JCHATChatModel *cellModel,BOOL isShouldRefresh){
            @strongify(self)
            if (isShouldRefresh) {
                [self refreshCellMessageMediaWithChatModel:cellModel];
            }
        };
        
        return cell;
    }
}

#pragma mark - 检查并刷新消息图片图片
- (void)refreshCellMessageMediaWithChatModel:(JCHATChatModel *)model {
    WHLog(@"Action - refreshCellMessageMediaWithChatModel:");
    
    if (!model) {
        return ;
    }
    if (!model.message || ![self.conversation isMessageForThisConversation:model.message]) {
        return ;
    }
    NSString *msgId = model.message.msgId;
    JMSGMessage *db_message = [self.conversation messageWithMessageId:msgId];
    if (!db_message || !db_message.msgId) {
        return ;
    }
    
    model.message = db_message;
    [_allMessageDic setObject:model forKey:model.message.msgId];
    //[_allmessageIdArr addObject:model.message.msgId];msgId 不会变化所以不用去修改
    
    // 1.method
//    [self.messageTableView reloadData];
    
    // 2.method
//    NSArray *cellArray = [_messageTableView visibleCells];
//    for (id temp in cellArray) {
//        if ([temp isKindOfClass:[JCHATMessageTableViewCell class]]) {
//            JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)temp;
//            if ([cell.model.message.msgId isEqualToString:msgId]) {
//                cell.model = model;
//                [cell layoutAllView];
//            }
//        }
//    }
    // 3.在cell 里面刷新
}
#pragma mark - 检查并刷新头像
- (void)chcekReceiveMessageAvatarWithReceiveNewMessage:(JMSGMessage *)message {
    WHLog(@"chcekReceiveMessageAvatarWithReceiveNewMessage:%@",message.serverMessageId);
    if (!message || !message.fromUser) {
        return ;
    }
    
    JMSGMessage *lastMessage = message;
    JMSGUser *fromUser = lastMessage.fromUser;
    [fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error == nil && [objectId isEqualToString:fromUser.username]) {
            if (data != nil) {
                NSUInteger lenght = data.length;
                [self refreshVisibleRowsAvatarWithNewMessage:lastMessage avatarDataLength:lenght];
            }
        }
    }];
//    NSString *key = [NSString stringWithFormat:@"%@_%@",message.fromUser.username,message.fromUser.appKey];
//    NSMutableArray *messages = _refreshAvatarUsersDic[key];
//    if (messages.count > 0) {
//        JMSGMessage *lastMessage = [messages lastObject];
//        JMSGUser *fromUser = lastMessage.fromUser;
//        [fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
//            if (error == nil && [objectId isEqualToString:fromUser.username]) {
//                if (data != nil) {
//                    NSUInteger lenght = data.length;
//                    [self refreshVisibleRowsAvatarWithNewMessage:lastMessage avatarDataLength:lenght];
//                }
//            }
//            [_refreshAvatarUsersDic removeObjectForKey:key];
//        }];
//    }
}

- (void)refreshVisibleRowsAvatarWithNewMessage:(JMSGMessage *)message avatarDataLength:(NSUInteger)length {
    
    WHLog(@"refreshVisibleRowsAvatarWithNewMessage::%@",message.serverMessageId);
    
    NSString *username_appkey = [NSString stringWithFormat:@"%@_%@",message.fromUser.username,message.fromUser.appKey];
    NSString *msgId = message.msgId;
    
    NSArray *indexPaths = [[_messageTableView indexPathsForVisibleRows] mutableCopy];
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    for (int i = 0; i < indexPaths.count; i++) {
        NSIndexPath *indexPath = indexPaths[i];
        JCHATMessageTableViewCell *cell = [_messageTableView cellForRowAtIndexPath:indexPath];
        JCHATChatModel *cellModel = cell.model;
        JMSGUser *cellUser = cell.model.message.fromUser;
        NSString *key = [NSString stringWithFormat:@"%@_%@",cellUser.username,cellUser.appKey];
        
        if (![username_appkey isEqualToString:key]) {
            continue ;
        }
        if (cellModel.avatarDataLength != length) {
            JMSGMessage *dbMessage = [self.conversation messageWithMessageId:msgId];
            JCHATChatModel *model = [_allMessageDic objectForKey:msgId];
            model.message = dbMessage;
            [_allMessageDic setObject:model forKey:msgId];
            [reloadIndexPaths addObject:indexPath];
        }
    }
    
    if (reloadIndexPaths.count > 0) {
        [_messageTableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)reloadAllCellAvatarImage {
    WHLog(@"Action -reloadAllCellAvatarImage");
    
    for (int i = 0; i < _allmessageIdArr.count; i++) {
        NSString *msgid = [_allmessageIdArr objectAtIndex:i];
        JCHATChatModel *model = [_allMessageDic objectForKey:msgid];
        if (model.message.isReceived && !model.message.fromUser.avatar) {
            JMSGMessage *message = [self.conversation messageWithMessageId:msgid];
            model.message = message;
            [_allMessageDic setObject:model forKey:msgid];
        }
    }
    
    NSArray *cellArray = [_messageTableView visibleCells];
    for (id temp in cellArray) {
        if ([temp isKindOfClass:[JCHATMessageTableViewCell class]]) {
            JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)temp;
            if (cell.model.message.isReceived) {
                [cell reloadAvatarImage];
            }
        }
    }
}

#pragma mark -PlayVoiceDelegate

- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
  if ([_allmessageIdArr count] - 1 > indexPath.row) {
    NSString *messageId = _allmessageIdArr[indexPath.row + 1];
    JCHATChatModel *model = _allMessageDic[ messageId];
    
    if (model.message.contentType == kJMSGContentTypeVoice && model.message.flag) {
      JCHATMessageTableViewCell *voiceCell =(JCHATMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
      [voiceCell playVoice];
    }
  }
}

- (void)setMessageIDWithMessage:(JMSGMessage *)message chatModel:(JCHATChatModel * __strong *)chatModel index:(NSInteger)index {
  [_allMessageDic removeObjectForKey:(*chatModel).message.msgId];
  [_allMessageDic setObject:*chatModel forKey:message.msgId];
  
  if ([_allmessageIdArr count] > index) {
    [_allmessageIdArr removeObjectAtIndex:index];
    [_allmessageIdArr insertObject:message.msgId atIndex:index];
  }
}

- (void)selectHeadView:(JCHATChatModel *)model {
  if (!model.message.fromUser) {
      [WHHud showString:@"该用户为API用户"];
    return;
  }
    WHLog(@"点击用户头像");
//  if (![model.message isReceived]) {
//    JCHATPersonViewController *personCtl =[[JCHATPersonViewController alloc] init];
//    personCtl.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:personCtl animated:YES];
//  } else {
//    JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
//    if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
//      friendCtl.userInfo = model.message.fromUser;
//      friendCtl.isGroupFlag = NO;
//    } else {
//      friendCtl.userInfo = model.message.fromUser;
//      friendCtl.isGroupFlag = YES;
//    }
//
//    [self.navigationController pushViewController:friendCtl animated:YES];
//  }
}

#pragma mark -连续播放语音
- (void)getContinuePlay:(UITableViewCell *)cell
              indexPath:(NSIndexPath *)indexPath {
  JCHATMessageTableViewCell *tempCell = (JCHATMessageTableViewCell *) cell;
  if ([_allmessageIdArr count] - 1 > indexPath.row) {
    NSString *messageId = _allmessageIdArr[indexPath.row + 1];
    JCHATChatModel *model = _allMessageDic[ messageId];
    if (model.message.contentType == kJMSGContentTypeVoice && [model.message.flag isEqualToNumber:@(0)] && [model.message isReceived]) {
      if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
        tempCell.continuePlayer = YES;
      }else {
        tempCell.continuePlayer = NO;
      }
    }
  }
}

#pragma mark 预览图片 PictureDelegate
//PictureDelegate
- (void)tapPicture:(NSIndexPath *)index tapView:(UIImageView *)tapView tableViewCell:(UITableViewCell *)tableViewCell {
  [self.toolBarContainer.toolbar.MessagetextView resignFirstResponder];
  JCHATMessageTableViewCell *cell =(JCHATMessageTableViewCell *)tableViewCell;
  NSInteger count = _imgDataArr.count;
  NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
  for (int i = 0; i<count; i++) {
    JCHATChatModel *messageObject = [_imgDataArr objectAtIndex:i];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.message = messageObject;
    photo.srcImageView = tapView; // 来源于哪个UIImageView
    [photos addObject:photo];
  }
  MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
  browser.currentPhotoIndex = [_imgDataArr indexOfObject:cell.model];
//  browser.currentPhotoIndex = cell.model.photoIndex; // 弹出相册时显示的第一张图片是？
  browser.photos = photos; // 设置所有的图片
  browser.conversation =_conversation;
  [browser show];
}

#pragma mark --获取所有发送消息图片
- (NSArray *)getAllMessagePhotoImg {
  NSMutableArray *urlArr =[NSMutableArray array];
  for (NSInteger i=0; i<[_allmessageIdArr count]; i++) {
    NSString *messageId = _allmessageIdArr[i];
    JCHATChatModel *model = _allMessageDic[messageId];
    if (model.message.contentType == kJMSGContentTypeImage) {
      [urlArr addObject:((JMSGImageContent *)model.message.content)];
    }
  }
  return urlArr;
}

#pragma mark - Voice Recording Helper Method
//- (void)startRecord {
//  WHLog(@"Action - startRecord");
//  [self.voiceRecordHUD startRecordingHUDAtView:self.view];
//  [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
//  }];
//}
//
//- (void)finishRecorded {
//  WHLog(@"Action - finishRecorded");
//  WEAKSELF
//  [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
//    __strong __typeof(weakSelf)strongSelf = weakSelf;
//    strongSelf.voiceRecordHUD = nil;
//  }];
//  [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
//    __strong __typeof(weakSelf)strongSelf = weakSelf;
//    [strongSelf SendMessageWithVoice:strongSelf.voiceRecordHelper.recordPath
//                       voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
//  }];
//}

#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
  WHLog(@"Action - SendMessageWithVoice");
  
  if ([voiceDuration integerValue]<0.5 || [voiceDuration integerValue]>60) {
    if ([voiceDuration integerValue]<0.5) {
        [WHHud showString:@"录音时长小于 0.5s"];
    } else {
        [WHHud showString:@"录音时长大于 60s"];
    }
    return;
  }
  
  JMSGMessage *voiceMessage = nil;
  JCHATChatModel *model =[[JCHATChatModel alloc] init];
  JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath]
                                                                 voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
  
  voiceMessage = [_conversation createMessageWithContent:voiceContent];
  [_conversation sendMessage:voiceMessage];
  [model setChatModelWith:voiceMessage conversationType:_conversation];
  [JCHATFileManager deleteFile:voicePath];
  [self addMessage:model];
}

#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
  NSString *recorderPath = nil;
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yy-MMMM-dd";
  recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
  dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
  recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
  return recorderPath;
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (self.barBottomFlag) {
    return;
  }
  if (object == self.toolBarContainer.toolbar.MessagetextView && [keyPath isEqualToString:@"contentSize"]) {
    [self layoutAndAnimateMessageInputTextView:object];
  }
}


#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    return ceilf([textView sizeThatFits:textView.frame.size].height);
  } else {
    return textView.contentSize.height;
  }
}

#pragma mark - Layout Message Input View Helper Method

//计算input textfield 的高度
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
  CGFloat maxHeight = [MFYChatToolBar maxHeight];
  
  CGFloat contentH = [self getTextViewContentH:textView];
  
  BOOL isShrinking = contentH < _previousTextViewContentHeight;
  CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
  
  if (!isShrinking && (_previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
    changeInHeight = 0;
  }
  else {
    changeInHeight = MIN(changeInHeight, maxHeight - _previousTextViewContentHeight);
  }
  if (changeInHeight != 0.0f) {

    [UIView animateWithDuration:0.25f
                     animations:^{
                       [self setTableViewInsetsWithBottomValue:_messageTableView.contentInset.bottom + changeInHeight];
                       
                       [self scrollToBottomAnimated:NO];
                       
                       if (isShrinking) {
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                           self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                         }
                         // if shrinking the view, animate text view frame BEFORE input view frame
                         [self.toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                       }
                       
                       if (!isShrinking) {
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                           self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                         }
                         // growing the view, animate the text view frame AFTER input view frame
                         [self.toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                       }
                     }
                     completion:^(BOOL finished) {
                     }];
    MFYMessageTextView *textview =_toolBarContainer.toolbar.MessagetextView;
    CGSize textSize = [JCHATStringUtils stringSizeWithWidthString:textview.text withWidthLimit:textView.frame.size.width withFont:WHFont(16)];
    CGFloat textHeight = textSize.height > maxHeight?maxHeight:textSize.height;
//    _toolBarHeightConstrait.constant = textHeight + 16;
    self.previousTextViewContentHeight = MIN(contentH, maxHeight);
  }
  
  // Once we reached the max height, we have to consider the bottom offset for the text view.
  // To make visible the last line, again we have to set the content offset.
  if (self.previousTextViewContentHeight == maxHeight) {
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime,
                   dispatch_get_main_queue(),
                   ^(void) {
                     CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                     [textView setContentOffset:bottomOffset animated:YES];
                   });
  }
}

- (void)inputTextViewDidChange:(MFYMessageTextView *)messageInputTextView {
  [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:messageInputTextView.text];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
  if (![self shouldAllowScroll]) return;
  
  NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
  
  if (rows > 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
  }
}

#pragma mark - Previte Method

- (BOOL)shouldAllowScroll {
  //      if (self.isUserScrolling) {
  //          if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
  //              && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
  //              return NO;
  //          }
  //      }
  
  return YES;
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
  //    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
  //    self.messageTableView.contentInset = insets;
  //    self.messageTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
  UIEdgeInsets insets = UIEdgeInsetsZero;
  if ([self respondsToSelector:@selector(topLayoutGuide)]) {
    insets.top = 64;
  }
  insets.bottom = bottom;
  return insets;
}

#pragma mark - XHMessageInputView Delegate

- (void)inputTextViewWillBeginEditing:(MFYMessageTextView *)messageInputTextView {
  _textViewInputViewType = JPIMInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(MFYMessageTextView *)messageInputTextView {
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)inputTextViewDidEndEditing:(MFYMessageTextView *)messageInputTextView;
{
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (UIButton *)rightInfoBtn {
    if (!_rightInfoBtn) {
        _rightInfoBtn = UIButton.button.WH_setImage_forState(WHImageNamed(@"chat_userInfo"),UIControlStateNormal);
    }
    return _rightInfoBtn;
}

- (MFYMessageTableView *)messageTableView {
    if (!_messageTableView) {
        _messageTableView = [[MFYMessageTableView alloc]initWithFrame:CGRectZero];
        _messageTableView.userInteractionEnabled = YES;
        _messageTableView.showsVerticalScrollIndicator = NO;
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.backgroundColor = wh_colorWithHexString(@"#F7F8FC");
    }
    return _messageTableView;
}

- (MFYChatToolBarContainer *)toolBarContainer {
    if (!_toolBarContainer) {
        _toolBarContainer = [[MFYChatToolBarContainer alloc]initWithFrame:CGRectMake(0, VERTICAL_SCREEN_HEIGHT - (57 + HOME_INDICATOR_HEIGHT), VERTICAL_SCREEN_WIDTH, 57 + HOME_INDICATOR_HEIGHT)];
        _toolBarContainer.userInteractionEnabled = YES;
        _toolBarContainer.toolbar.delegate = self;
    }
    return _toolBarContainer;
}

- (MFYPublicManager *)publicManager {
    if (!_publicManager) {
        _publicManager = [[MFYPublicManager alloc]init];
    }
    return  _publicManager;
}

- (MFYChatMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[MFYChatMoreView alloc]initWithFrame:CGRectMake(0, VERTICAL_SCREEN_HEIGHT - KMoreviewHeight , VERTICAL_SCREEN_WIDTH, KMoreviewHeight)];
        _moreView.hidden = YES;
        _moreView.delegate = self;
    }
    return _moreView;
}

@end
