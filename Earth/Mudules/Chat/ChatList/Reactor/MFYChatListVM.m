//
//  MFYChatListVM.m
//  Earth
//
//  Created by colr on 2020/3/10.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYChatListVM.h"
#import "MFYChatService.h"
#import <Contacts/Contacts.h>

@interface MFYChatListVM ()

@property (nonatomic, strong) NSMutableArray<JMSGConversation *> * dataList;

@property (nonatomic, strong) NSMutableArray<MFYProfile*> * userList;

@property (nonatomic, strong) NSArray<NSString *>* topIdList;

@property (nonatomic, strong) NSMutableArray * phoneNumArr;

@property (nonatomic, assign) NSInteger NewDataCount;

@property (nonatomic, assign) MFYChatListType listType;

@property (nonatomic, strong) NSString * keyWords;

@property (nonatomic, assign) NSInteger page;


@end


@implementation MFYChatListVM

- (instancetype)initWithType:(MFYChatListType)listType {
    self = [super init];
    if (self) {
        _listType = listType;
        switch (listType) {
            case MFYChatListFriendsType:
                    [self loadAllConversations];
                break;
            case MFYChatListSearchType:
                self.page = 1;
                break;
            case MFYChatListMayKnowType:
                    [self requestContactAuthor];
                break;
            default:
                break;
        }
        
    }
    return self;
}

#pragma mark- 数据获取
- (void)loadAllConversations {
    [MFYChatService getTopChatListCompletion:^(NSArray<NSString *> * _Nonnull imIdArr, NSError * _Nonnull error) {
        self.topIdList = [imIdArr copy];
        if (imIdArr.count > 0) {
            //根据置顶的聊天，重新排序聊天
            [JMSGConversation allConversations:^(id resultObject, NSError *error) {
                if (!error) {
                    self.dataList = [self sortConversation:resultObject];
                }
            }];
        }
    }];
}

- (void)searchTheFriendWithKeyWord:(NSString *)keyword {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"keyword"] = keyword;
    dic[@"page"] = @(self.page);
    dic[@"size"] = @(20);
    [MFYChatService postSearchFriendsPramaDic:dic Completion:^(NSArray<MFYProfile *> * _Nonnull userArr, NSError * _Nonnull error) {
        if (!error) {
            self.userList = [userArr mutableCopy];
        }else{
            [WHHud showString:error.descriptionFromServer];
        }
    }];
}

- (void)loadTheMayknowFriends {
    if (self.phoneNumArr.count > 0) {
        [MFYChatService postMayKnowFriendsWithPhoneNum:self.phoneNumArr Completion:^(NSArray<MFYProfile *> * _Nonnull userArr, NSError * _Nonnull error) {
            if (!error) {
                self.userList = userArr;
            }else {
                [WHHud showString:error.descriptionFromServer];
            }
        }];
    }
}

#pragma mark- public method
- (void)addChatTop:(JMSGConversation *)conversation {
    JMSGUser * user = conversation.target;
    [MFYChatService postAddTopsChat:user.username Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            conversation.isTop = YES;
            [self loadAllConversations];
        }
    }];
}

- (void)deleteTheTopChat:(JMSGConversation *)conversation {
    JMSGUser * user = conversation.target;
    [MFYChatService postRemoveTopsChat:user.username Completion:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            conversation.isTop = NO;
            [self loadAllConversations];
        }
    }];
}


#pragma mark-将用户数组转化为会话数组
- (NSMutableArray *)transformTheUserArr:(NSArray *)arr {
    NSMutableArray * resultArr = [NSMutableArray arrayWithCapacity:0];
    for (MFYProfile * profile in arr) {
        [JMSGConversation createSingleConversationWithUsername:profile.imId completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                [resultArr addObject:resultObject];
            }
        }];
    }
    return resultArr;
}

#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSArray *)conversationArr {
    //1.取出置顶的会话
    NSMutableArray * conversationList = [NSMutableArray arrayWithArray:conversationArr];
    NSMutableArray * topListArr = [NSMutableArray arrayWithCapacity:0];
    if (self.topIdList.count > 0) {
        [conversationArr enumerateObjectsUsingBlock:^(JMSGConversation * conversation, NSUInteger idx, BOOL * _Nonnull stop) {
            JMSGUser * user = conversation.target;
            for (NSString * imId in self.topIdList) {
                if ([user.username isEqualToString:imId]) {
                    conversation.isTop = YES;
                    [conversationList removeObject:conversation];
                    [topListArr addObject:conversation];
                }
            }
        }];
    }
    //2.剩余的会话进行排序
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"latestMessage.timestamp" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    
    NSArray *sortedArray = [conversationList sortedArrayUsingDescriptors:sortDescriptors];
    
    NSMutableArray * resultArr = [NSMutableArray arrayWithArray:sortedArray];
    
    //3.将置顶的会话插入到最前方
    NSRange range = NSMakeRange(0, topListArr.count);
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [resultArr insertObjects:topListArr atIndexes:indexSet];
    return resultArr;

//    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
//    return [NSMutableArray arrayWithArray:sortResultArr];
}

#pragma mark 请求通讯录权限
- (void)requestContactAuthor{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                NSLog(@"授权失败");
            }else {
                [self openContact];
                NSLog(@"成功授权");
            }
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
}

- (void)openContact{
 // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    self.phoneNumArr = [NSMutableArray arrayWithCapacity:0];
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
        //遍历一个人名下的多个电话号码
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString * string = phoneNumber.stringValue ;
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            [self.phoneNumArr addObject:string];
//        NSLog(@"姓名=%@, 电话号码是=%@", nameStr, string);
        }
        [self loadTheMayknowFriends];
    }];
}


- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"请授权通讯录权限"
        message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录"
        preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [[WHAlertTool WHTopViewController] presentViewController:alertController animated:YES completion:nil];
}
@end

