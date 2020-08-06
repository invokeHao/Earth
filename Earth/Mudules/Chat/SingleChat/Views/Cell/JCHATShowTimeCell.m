//
//  JCHATShowTimeCell.m
//  Earth
//
//  Created by colr on 2020/3/2.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "JCHATShowTimeCell.h"
#import "JCHATStringUtils.h"

@implementation JCHATShowTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = wh_colorWithHexString(@"#F7F8FC");
    [self.contentView addSubview:self.messageTimeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.messageTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.height.mas_equalTo(15);
    }];
}

- (void)setCellData:(JCHATChatModel *)model {
    self.model = model;
    [self setContentFram];
}

- (void)setContentFram {
  UIFont *font =[UIFont systemFontOfSize:14];
  CGSize maxSize = CGSizeMake(200, 2000);
  
  NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
  CGSize realSize = [[JCHATStringUtils getFriendlyDateString:[self.model.messageTime doubleValue]] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
  [self.messageTimeLabel setFrame:CGRectMake(self.messageTimeLabel.frame.origin.x, self.messageTimeLabel.frame.origin.y, realSize.width,realSize.height)];
  self.messageTimeLabel.text= [NSString stringWithFormat:@"%@",self.model.messageTime];
}


- (UILabel *)messageTimeLabel {
    if (!_messageTimeLabel) {
        _messageTimeLabel = UILabel.label;
        _messageTimeLabel.font = WHFont(13);
        _messageTimeLabel.textColor = wh_colorWithHexString(@"#999999");
        _messageTimeLabel.textAlignment = NSTextAlignmentCenter;
        _messageTimeLabel.numberOfLines = 0;
        _messageTimeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _messageTimeLabel;
}


@end
