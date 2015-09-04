//
//  JSPopTextField.h
//  Arrietty
//
//  Created by liuyan on 14-11-20.
//  Copyright (c) 2014年 JoyShare Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JSPopTextInput <NSObject>

@optional
- (NSString *)decorateTextForChangedText:(NSString *)changedText;

@end

@interface JSPopTextField : UIView <UITextFieldDelegate, JSPopTextInput> {
    UITextField *_textField;
    __weak UILabel *_accessoryLabel;
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSUInteger numberOfWords;

@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, weak) UILabel *accessoryLabel;

@property (nonatomic, assign, readonly) BOOL overMaxWords;

@property (nonatomic, copy) void (^didEndEditingBlock)(JSPopTextField *popTextField);

- (void)showInView:(UIView *)inView;
- (void)dismiss;

@end
