//
//  MFYChatFriendCell.m
//  Earth
//
//  Created by colr on 2020/3/9.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYChatFriendCell.h"
#import "WHTimeUtil.h"

@interface MFYChatFriendCell()

@property (nonatomic, strong)YYAnimatedImageView * iconView;

@property (nonatomic, strong)UILabel * nameLabel;

@property (nonatomic, strong)UILabel * messageLabel;

@property (nonatomic, strong)UILabel * timeLabel;

@property (nonatomic, strong)UILabel * messageNumberLabel;

//消息数label


@end

@implementation MFYChatFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.messageNumberLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(53, 53));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(12);
        make.top.mas_equalTo(self.iconView.mas_top).offset(6);
        make.height.mas_equalTo(18);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.centerY.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(13);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(15);
    }];
    
    [self.messageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.timeLabel);
        make.centerY.mas_equalTo(self.messageLabel);
        make.height.mas_equalTo(16);
    }];
}

+ (MFYChatFriendCell *)mfy_cellWithTableView:(MFYBaseTableView *)tableView {
    
    MFYChatFriendCell * cell = [[MFYChatFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MFYChatFriendCell reuseID]];
    return cell;
}

- (void)setConversation:(JMSGConversation *)conversation {
    if (conversation) {
        self.contentView.backgroundColor = conversation.isTop? wh_colorWithHexString(@"#F0F1F5") : [UIColor whiteColor];
        _conversation = conversation;
        self.nameLabel.text = conversation.title;
        self.messageLabel.text = conversation.latestMessageContentText;
        [conversation avatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (!error) {
                if (data) {
                    [self.iconView setImage:[UIImage imageWithData:data]];
                }else {
                    [self.iconView setImage:WHImageNamed(@"default_user")];
                }
            }else {
                [self.iconView setImage:WHImageNamed(@"default_user")];
            }
        }];
        if (conversation.latestMessage.timestamp != nil ) {
          double time = [conversation.latestMessage.timestamp doubleValue];
          [self.timeLabel setText:[WHTimeUtil articleCardDateStringByTimeStamp:time ]];
        } else {
          self.timeLabel.text = @"";
        }
        if ([conversation.unreadCount integerValue] > 0) {
//            NSString * unreadStr = @"10";
//            NSInteger unreadCount = 10;

            NSString * unreadStr = [NSString stringWithFormat:@"%@", conversation.unreadCount];
            NSInteger unreadCount = [conversation.unreadCount integerValue];
            [self.messageNumberLabel setHidden:NO];
            
            CGFloat width = 16;
            if (unreadCount > 9) {
                width = 26;
            }
            if (unreadCount > 99) {
                width = 40;
                unreadStr = @"99+";
            }
            self.messageNumberLabel.text = unreadStr;
        [self.messageNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        } else {
            [self.messageNumberLabel setHidden:YES];
        }
    }
}

- (YYAnimatedImageView *)iconView {
    if (!_iconView) {
        _iconView = [[YYAnimatedImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.backgroundColor = wh_colorWithHexString(@"E5E5E5");
        _iconView.layer.cornerRadius = 7;
        _iconView.clipsToBounds = YES;
    }
    return _iconView;
}

-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = UILabel.label.WH_font(WHFont(17)).WH_textColor(wh_colorWithHexString(@"#FF6CA0"));
    }
    return _nameLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = UILabel.label.WH_font(WHFont(14)).WH_textColor(wh_colorWithHexString(@"#939499"));
    }
    return _messageLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = UILabel.label.WH_font(WHFont(12)).WH_textColor(wh_colorWithHexString(@"#939499"));
    }
    return _timeLabel;
}

- (UILabel *)messageNumberLabel {
    if (!_messageNumberLabel) {
        _messageNumberLabel = UILabel.label.WH_font(WHFont(12)).WH_textColor([UIColor whiteColor]).WH_textAlignment(NSTextAlignmentCenter);
        _messageNumberLabel.backgroundColor = wh_colorWithHexString(@"#F74C31");
        _messageNumberLabel.layer.cornerRadius = 8;
        _messageNumberLabel.clipsToBounds = YES;
    }
    return _messageNumberLabel;
}


@end
