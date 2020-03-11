//
//  MFYSingleChatVC.h
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseViewController.h"
#import "MFYMessageTableView.h"
#import "MFYChatToolBar.h"
#import "MFYProfile.h"
#import "MFYChatMoreView.h"

NS_ASSUME_NONNULL_BEGIN

#define interval 60*2 //static =const

static NSInteger const messagePageNumber = 25;
static NSInteger const messagefristPageNumber = 20;

@interface MFYSingleChatVC : MFYBaseViewController<
UITableViewDataSource,
UITableViewDelegate,
SendMessageDelegate,
MoreViewRecoderDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextViewDelegate,
UIScrollViewDelegate,
UIGestureRecognizerDelegate
>

@property (strong, nonatomic) JMSGConversation *conversation;

@property (nonatomic, strong) MFYMessageTableView *messageTableView;

@property (nonatomic, strong) MFYChatMoreView * moreView;

@property (nonatomic, strong) MFYChatToolBarContainer *toolBarContainer;

@property(nonatomic, assign) JPIMInputViewType textViewInputViewType;

@property (nonatomic, strong) MFYProfile * userProfile;

@property(assign, nonatomic) BOOL barBottomFlag;

@property(strong, nonatomic) NSString *targetName;
@property(assign, nonatomic) BOOL isConversationChange;
@property(weak,nonatomic)id superViewController;

/**
 *  记录旧的textView contentSize Heigth
 */
@property(nonatomic, assign) CGFloat previousTextViewContentHeight;

- (void)setupView;
- (void)prepareImageMessage:(UIImage *)img;


@end

NS_ASSUME_NONNULL_END
