//
//  JSPopTextField.m
//  Arrietty
//
//  Created by liuyan on 14-11-20.
//  Copyright (c) 2014年 JoyShare Inc. All rights reserved.
//

#import "JSPopTextField.h"
#import <PupaFoundation/PupaFoundation.h>
#import <Masonry/Masonry.h>
#import <YAUIKit/YAUIKit.h>

#import "NSString+ARLength.h"

@implementation JSPopTextField {
    __weak UIButton *_maskButton;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfWords = 0;
        _keyboardType = UIKeyboardTypeDefault;

        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.font = [UIFont helveticaFontOfSize:16];
        _textField.keyboardType = _keyboardType;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [self addSubview:_textField];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _accessoryLabel = label;
        _accessoryLabel.font = [UIFont helveticaFontOfSize:12];
        _accessoryLabel.textColor = YASkinColor(@"text");
        _accessoryLabel.hidden = YES;
        [self addSubview:_accessoryLabel];

        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.mas_top);
          make.bottom.equalTo(self.mas_bottom);
          make.leading.equalTo(self.mas_leading).offset(10);
          make.trailing.equalTo(_accessoryLabel.mas_leading);
        }];

        [_accessoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.mas_top);
          make.bottom.equalTo(self.mas_bottom);
          make.leading.equalTo(_textField.mas_trailing);
          make.trailing.equalTo(self.mas_trailing).offset(-10);
        }];

        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(ar_keyboardWillShowNotification:)
                              name:UIKeyboardWillShowNotification
                            object:nil];
        [defaultCenter addObserver:self
                          selector:@selector(ar_keyboardWillHiddenNotification:)
                              name:UIKeyboardWillHideNotification
                            object:nil];
        [defaultCenter addObserver:self
                          selector:@selector(ar_textFieldDidChangedNotification:)
                              name:UITextFieldTextDidChangeNotification
                            object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Property

- (BOOL)overMaxWords
{
    if (self.numberOfWords > 0) {
        return _textField.text.lengthForChineseChar > self.numberOfWords;
    } else {
        return NO;
    }
}

- (NSString *)text
{
    if (self.overMaxWords) {
        NSStringEncoding stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData *stringData = [_textField.text dataUsingEncoding:stringEncoding];
        NSData *finalStringData = [stringData subdataWithRange:NSMakeRange(0, self.numberOfWords)];
        return [[NSString alloc] initWithData:finalStringData encoding:stringEncoding];
    }
    return _textField.text;
}

- (void)setText:(NSString *)text
{
    _textField.text = text;

    if (self.numberOfWords != 0) {
        _accessoryLabel.text = [self ar_countWordsString:_textField.text.lengthForChineseChar];
    }
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    _textField.keyboardType = _keyboardType;
}

- (void)setNumberOfWords:(NSUInteger)numberOfWords
{
    _numberOfWords = numberOfWords;
    _accessoryLabel.hidden = (_numberOfWords == 0);

    _accessoryLabel.text = [self ar_countWordsString:_textField.text.lengthForChineseChar];
}

#pragma mark - TextFiled Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.didEndEditingBlock) {
        dispatch_main_async_safe(^{
          self.didEndEditingBlock(self);
        });
    }
    return NO;
}

#pragma mark - Show & Dismiss

- (void)showInView:(UIView *)inView
{
    self.backgroundColor = [UIColor colorWithHex:0xFFFFFF];

    UIButton *maskButton = [[UIButton alloc] initWithFrame:CGRectZero];
    maskButton.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    maskButton.alpha = 0;
    _maskButton = maskButton;
    [inView addSubview:maskButton];

    [maskButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    [maskButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(inView);
    }];

    [inView addSubview:self];

    [self mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(inView.mas_leading);
      make.trailing.equalTo(inView.mas_trailing);
      make.bottom.equalTo(inView.mas_bottom).offset(0);
      make.height.equalTo(@55);
    }];

    [inView setNeedsLayout];
    [inView layoutIfNeeded];

    self.alpha = 0;
    [_textField becomeFirstResponder];
}

- (void)dismiss
{
    [_textField resignFirstResponder];
}

#pragma mark - Keyboard Notification

- (void)ar_keyboardWillShowNotification:(NSNotification *)notification
{
    CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration =
        [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.superview.mas_bottom).offset(-keyboardEndFrame.size.height);
    }];

    [self.superview setNeedsLayout];

    [UIView animateWithDuration:keyboardAnimationDuration
                          delay:0
         usingSpringWithDamping:5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       self.alpha = 1.0;
                       _maskButton.alpha = 1.0;
                       [self.superview layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)ar_keyboardWillHiddenNotification:(NSNotification *)notification
{
    NSTimeInterval keyboardAnimationDuration =
        [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [self mas_updateConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.superview.mas_bottom).offset(0);
    }];

    [self.superview setNeedsLayout];

    [UIView animateWithDuration:keyboardAnimationDuration
        delay:0
        usingSpringWithDamping:5
        initialSpringVelocity:10
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
          _maskButton.alpha = 0.0;
          self.alpha = 0.0;
          [self.superview layoutIfNeeded];
        }
        completion:^(BOOL finished) {
          [_maskButton removeFromSuperview];
          [self removeFromSuperview];
        }];
}

- (void)ar_textFieldDidChangedNotification:(NSNotification *)notification
{
    @autoreleasepool
    {
        if (self.numberOfWords > 0) {
            _accessoryLabel.text = [self ar_countWordsString:_textField.text.lengthForChineseChar];
            _accessoryLabel.textColor = self.overMaxWords ? YASkinColor(@"hint") : YASkinColor(@"text");
        }
    }
    if ([self respondsToSelector:@selector(decorateTextForChangedText:)]) {
        _textField.text = [self decorateTextForChangedText:_textField.text];
    }
}

#pragma mark - Util

- (NSString *)ar_countWordsString:(NSUInteger)wordsCount
{
    return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)wordsCount, (unsigned long)self.numberOfWords];
}

@end
