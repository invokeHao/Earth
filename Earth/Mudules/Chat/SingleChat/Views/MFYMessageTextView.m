//
//  MFYMessageTextView.m
//  Earth
//
//  Created by colr on 2020/2/28.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYMessageTextView.h"
#import "JCHATAlertToSendImage.h"

@implementation MFYMessageTextView

#pragma mark - Setters

- (void)setPlaceHolder:(NSString *)placeHolder {
  if([placeHolder isEqualToString:_placeHolder]) {
    return;
  }
  
  NSUInteger maxChars = [MFYMessageTextView maxCharactersPerLine];
  if([placeHolder length] > maxChars) {
    placeHolder = [placeHolder substringToIndex:maxChars - 8];
    placeHolder = [[placeHolder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByAppendingFormat:@"..."];
  }
  
  _placeHolder = placeHolder;
  [self setNeedsDisplay];
}

//"反馈"关心的功能
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
  return (action == @selector(paste:));
}

- (void)paste:(id)sender {
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  NSTextAttachment *textAttachment = [NSTextAttachment new];
  if (pasteboard.string != nil) {
    [super paste:sender];
    return;
  }
  if (pasteboard.image != nil) {
    textAttachment.image = pasteboard.image;
    NSAttributedString *attString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [[JCHATAlertToSendImage shareInstance] showInViewWith:pasteboard.image];
  }
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
  if([placeHolderTextColor isEqual:_placeHolderTextColor]) {
    return;
  }
  
  _placeHolderTextColor = placeHolderTextColor;
  [self setNeedsDisplay];
}

#pragma mark - Message text view

- (NSUInteger)numberOfLinesOfText {
  return [MFYMessageTextView numberOfLinesForMessage:self.text];
}

+ (NSUInteger)maxCharactersPerLine {
  return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text {
  return (text.length / [MFYMessageTextView maxCharactersPerLine]) + 1;
}

#pragma mark - Text view overrides

- (void)setText:(NSString *)text {
  [super setText:text];
  [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
  [super setAttributedText:attributedText];
  [self setNeedsDisplay];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
  [super setContentInset:contentInset];
  [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
  JCHATMAINTHREAD(^{
    [super setFont:font];
    [self setNeedsDisplay];
  });
  
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
  [super setTextAlignment:textAlignment];
  [self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
  [self setNeedsDisplay];
}

#pragma mark - Life cycle

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didReceiveTextDidChangeNotification:)
                                               name:UITextViewTextDidChangeNotification
                                             object:self];
  
    _placeHolderTextColor = wh_colorWithHexString(@"#999999");
    _placeHolder = @"请输入聊天内容...";
  
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
//    self.userInteractionEnabled = YES;
    self.textColor = wh_colorWithHexString(@"#333333");
    self.backgroundColor = wh_colorWithHexString(@"#F7F8FC");
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDefault;
    self.textAlignment = NSTextAlignmentLeft;
    self.font = WHFont(16);
    self.layer.cornerRadius = 6;
    [self.layer setMasksToBounds:YES];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
      [self setup];
      [self bindEvents];
  }
  return self;
}

- (void)bindEvents {
    
}

- (void)dealloc {
  _placeHolder = nil;
  _placeHolderTextColor = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  
  if([self.text length] == 0 && self.placeHolder) {
    CGRect placeHolderRect = CGRectMake(10.0f,
                                        7.0f,
                                        rect.size.width,
                                        rect.size.height);
    
    [self.placeHolderTextColor set];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0) {
      NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
      paragraphStyle.alignment = self.textAlignment;
      
      [self.placeHolder drawInRect:placeHolderRect
                    withAttributes:@{ NSFontAttributeName : WHFont(16),
                                      NSForegroundColorAttributeName : self.placeHolderTextColor,
                                      NSParagraphStyleAttributeName : paragraphStyle }];
    }
    else {
      NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
      paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
      paragraphStyle.alignment = self.textAlignment;
      [self.placeHolder drawInRect:placeHolderRect withAttributes:@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paragraphStyle}];
    }
  }
}

@end
