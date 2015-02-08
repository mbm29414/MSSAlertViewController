#pragma mark -
#pragma mark - Defines
#define IS_IPHONE_4     (MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width) == 480.0)
#define IS_IPHONE_5     (MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width) == 568.0)
#define IS_IPHONE_6     (MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width) == 667.0)
#define IS_IPHONE_6PLUS (MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width) == 736.0)
#define SCREEN_HEIGHT    MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)
#define SCREEN_WIDTH     MIN([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)

//  MSSAlertViewController.h
//  AlertViewControllerDemo
//  Created by Michael McEvoy on 2/8/15.
//  Copyright (c) 2015 Mustard Seed Software LLC. All rights reserved.
#import <UIKit/UIKit.h>
@interface MSSAlertViewController : UIViewController {
    
}

#pragma mark -
#pragma mark - Public Class Methods
+ (NSDictionary *)defaultButtonAttributes;
+ (NSDictionary *)messageAttributes;
+ (NSDictionary *)titleAttributes;
+ (void)setDefaultButtonAttributed:(NSDictionary *)buttonAttributes;
+ (void)setMessageAttributes:(NSDictionary *)messageAttributes;
+ (void)setTitleAttributes:(NSDictionary *)titleAttributes;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)alertWithAttributedTitle:(NSAttributedString *)title attributedMessage:(NSAttributedString *)message;

#pragma mark -
#pragma mark - Public Instance Methods
- (void)addButtonWithAttributedTitle:(NSAttributedString *)title tapHandler:(void(^)(void))handler;
- (void)addButtonWithTitle:(NSString *)title tapHandler:(void(^)(void))handler;

#pragma mark -
#pragma mark - Properties
@property (assign, nonatomic)           BOOL                 showTextField;
@property (assign, nonatomic)           BOOL                 textFieldSecure;
@property (strong, nonatomic)           NSAttributedString  *attributedMessage;
@property (strong, nonatomic)           NSAttributedString  *attributedTitle;
@property (strong, nonatomic, readonly) NSMutableArray      *buttonInfo;
@property (copy  , nonatomic, readonly) NSString            *enteredText;
@property (copy  , nonatomic)           NSString            *textFieldPlaceholder;

@end