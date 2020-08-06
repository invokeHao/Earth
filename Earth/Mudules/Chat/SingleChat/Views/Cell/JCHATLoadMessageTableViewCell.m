//
//  JCHATLoadMessageTableViewCell.m
//  Earth
//
//  Created by colr on 2020/3/2.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "JCHATLoadMessageTableViewCell.h"

@implementation JCHATLoadMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self != nil) {
    loadIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(VERTICAL_SCREEN_WIDTH/2 - 10, 10, 20, 20)];
    [loadIndicator startAnimating];
    loadIndicator.hidesWhenStopped = NO;
    loadIndicator.color = [UIColor grayColor];
    [self addSubview:loadIndicator];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

- (void)startLoading {
  [loadIndicator startAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
