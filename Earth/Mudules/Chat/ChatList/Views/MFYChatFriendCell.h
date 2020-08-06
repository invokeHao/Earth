//
//  MFYChatFriendCell.h
//  Earth
//
//  Created by colr on 2020/3/9.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYBaseTableViewCell.h"
#import "MFYProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFYChatFriendCell : MFYBaseTableViewCell

@property (nonatomic, strong)JMSGConversation * conversation;

@property (nonatomic, strong)MFYProfile * profile;

+ (MFYChatFriendCell *)mfy_cellWithTableView:(MFYBaseTableView *)tableView;

@end

NS_ASSUME_NONNULL_END
