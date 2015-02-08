//  MSSAlertViewController.m
//  AlertViewControllerDemo
//  Created by Michael McEvoy on 2/8/15.
//  Copyright (c) 2015 Mustard Seed Software LLC. All rights reserved.
// Header import
#import "MSSAlertViewController.h"
@interface MSSAlertViewController () <UITextFieldDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate> {
    
}
#pragma mark -
#pragma mark - UI "Constants"
@property (assign, nonatomic) CGFloat leftRightMarginMessage;
@property (assign, nonatomic) CGFloat leftRightMarginTitle;
@property (assign, nonatomic) CGFloat messageBottomMargin;
@property (assign, nonatomic) CGFloat titleToMessageSpacing;
@property (assign, nonatomic) CGFloat titleTopMargin;

#pragma mark -
#pragma mark - UI Controls
@property (strong, nonatomic) UILabel       *messageLabel;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UITextField   *textField;
@property (strong, nonatomic) UIView        *alertView;

#pragma mark -
#pragma mark - Private Properties
@property (strong, nonatomic)               NSLayoutConstraint  *centerConstraint;
@property (strong, nonatomic, readwrite)    NSMutableArray      *buttonInfo;
@property (copy  , nonatomic, readwrite)    NSString            *enteredText;

@end

@implementation MSSAlertViewController

static NSDictionary *buttonAttrs;
static NSDictionary *messageAttrs;
static NSDictionary *titleAttrs;

#pragma mark -
#pragma mark - Public Class Methods
+ (NSDictionary *)defaultButtonAttributes {
    static CGFloat fontSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontSize        = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?([UIFont buttonFontSize] + 2):([UIFont buttonFontSize]);
    });
    if (buttonAttrs == nil) {
        buttonAttrs     = @{NSFontAttributeName:            [UIFont boldSystemFontOfSize:fontSize],
                            NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    }
    return buttonAttrs;
}
+ (NSDictionary *)messageAttributes {
    static CGFloat fontSize;
    static NSMutableParagraphStyle *style;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontSize        = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?([UIFont labelFontSize] + 2):([UIFont labelFontSize]);
        style           = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
    });
    if (messageAttrs == nil) {
        messageAttrs    = @{NSFontAttributeName:            [UIFont systemFontOfSize:fontSize],
                            NSForegroundColorAttributeName: [UIColor darkGrayColor],
                            NSParagraphStyleAttributeName:  style};
    }
    return messageAttrs;
}
+ (NSDictionary *)titleAttributes {
    static CGFloat fontSize;
    static NSMutableParagraphStyle *style;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontSize        = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)?([UIFont labelFontSize] + 4):([UIFont labelFontSize] + 2);
        style           = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
    });
    if (titleAttrs == nil) {
        titleAttrs      = @{NSFontAttributeName:            [UIFont boldSystemFontOfSize:fontSize],
                            NSForegroundColorAttributeName: [UIColor blackColor],
                            NSParagraphStyleAttributeName:  style};
    }
    return titleAttrs;
}
+ (void)setDefaultButtonAttributed:(NSDictionary *)buttonAttributes {
    buttonAttrs = buttonAttributes;
}
+ (void)setMessageAttributes:(NSDictionary *)messageAttributes {
    if (messageAttributes != nil) {
        messageAttrs = messageAttributes;
    }
}
+ (void)setTitleAttributes:(NSDictionary *)titleAttributes {
    if (titleAttributes != nil) {
        titleAttrs = titleAttributes;
    }
}
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    title                           = (title)?:@"";
    message                         = (message)?:@"";
    NSAttributedString *attTitle    = [[NSAttributedString alloc] initWithString:title   attributes:[self titleAttributes]];
    NSAttributedString *attMessage  = [[NSAttributedString alloc] initWithString:message attributes:[self messageAttributes]];
    return [self alertWithAttributedTitle:attTitle attributedMessage:attMessage];
}
+ (instancetype)alertWithAttributedTitle:(NSAttributedString *)title attributedMessage:(NSAttributedString *)message {
    MSSAlertViewController *alert   = [[self alloc] init];
    alert.attributedTitle           = title;
    alert.attributedMessage         = message;
    return alert;
}

#pragma mark -
#pragma mark - Public Instance Methods
- (void)addButtonWithAttributedTitle:(NSAttributedString *)title tapHandler:(void (^)(void))handler {
    NSMutableDictionary *dict       = [@{@"title": title} mutableCopy];
    if (handler == nil) {
        dict[@"handler"]            = [NSNull null];
    } else {
        dict[@"handler"]            = handler;
    }
    if (self.buttonInfo == nil) {
        self.buttonInfo             = [NSMutableArray array];
    }
    [self.buttonInfo addObject:[dict copy]];
}
- (void)addButtonWithTitle:(NSString *)title tapHandler:(void (^)(void))handler {
    NSAttributedString *attTitle;
    NSMutableDictionary *btnAttrs   = [[MSSAlertViewController defaultButtonAttributes] mutableCopy];
    attTitle                        = [[NSAttributedString alloc] initWithString:title attributes:btnAttrs];
    [self addButtonWithAttributedTitle:attTitle tapHandler:handler];
}

#pragma mark -
#pragma mark - Initializers
- (instancetype)init {
    self = [super init];
    if (self != nil) {
        // Moving outside --> inside
        
        // Main View
        self.view.backgroundColor           = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        self.view.frame                     = [[UIApplication sharedApplication] keyWindow].bounds;
        
        // Alert "container" view
        self.alertView                      = [[UIView alloc] initWithFrame:CGRectZero];
        [self.alertView setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.alertView.backgroundColor      = [UIColor whiteColor];
        self.alertView.layer.cornerRadius   = 8.0f;
        self.alertView.layer.masksToBounds  = YES;
        [self.view addSubview:self.alertView];
        CGFloat alertWidthFloat;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            alertWidthFloat                 = 400.0f;
        } else {
            alertWidthFloat                 = SCREEN_WIDTH - 40.0f;
        }
        NSLayoutConstraint *alertWidth      = [NSLayoutConstraint constraintWithItem:self.alertView     attribute:NSLayoutAttributeWidth    relatedBy:NSLayoutRelationEqual toItem:nil                  attribute:NSLayoutAttributeNotAnAttribute   multiplier:1.0f constant:alertWidthFloat];
        [self.alertView addConstraint:alertWidth];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        self.centerConstraint               = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.alertView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        [self.view addConstraint:self.centerConstraint];
        
        // Transition Properties
        self.modalPresentationStyle         = UIModalPresentationCustom;
        self.transitioningDelegate          = self;
        
    }
    return self;
}

#pragma mark -
#pragma mark - Accessors
- (void)setAttributedMessage:(NSAttributedString *)attributedMessage {
    self.messageLabel.attributedText    = attributedMessage;
    _attributedMessage                  = attributedMessage;
}
- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    self.titleLabel.attributedText      = attributedTitle;
    _attributedTitle                    = attributedTitle;
}

#pragma mark -
#pragma mark - View Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self setupUserInterface];
    [self.alertView layoutIfNeeded];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.showTextField == YES && self.textField != nil) {
        [self.textField becomeFirstResponder];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterForKeyboardNotifications];
}

#pragma mark -
#pragma mark - Keyboard Appearance Methods
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    // The keyboard is going to show, so get the height of the keyboard and adjust the height of self.textView accordingly
    CGRect keyboard                     = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat topOfKeyboard               = keyboard.origin.y;
    CGFloat keyBoardHeight              = self.view.frame.size.height - topOfKeyboard;
    self.centerConstraint.constant      = (keyBoardHeight / 2.0f) - 10.0f;
    [UIView animateWithDuration:0.4f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
     ];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [self.textField resignFirstResponder];
    self.centerConstraint.constant      = 0.0f;
    [UIView animateWithDuration:0.4f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
     ];
}


#pragma mark -
#pragma mark - Button Press
- (void)buttonPressed:(UIButton *)button {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    __block NSDictionary *info  = self.buttonInfo[button.tag];
    [self.presentingViewController
     dismissViewControllerAnimated:YES
     completion:^{
         if (info[@"handler"] != [NSNull null]) {
             void(^handler)(void) = info[@"handler"];
             handler();
         }
     }
     ];
}

#pragma mark -
#pragma mark - UI Setup
- (void)setupUserInterface {
    [self createConstants];
    [self setupViewLayout];
}
- (void)createConstants {
    if (IS_IPHONE_4) {
        self.leftRightMarginMessage = 20.0f;
        self.leftRightMarginTitle   = 12.0f;
        self.messageBottomMargin    = 12.0f;
        self.titleToMessageSpacing  =  8.0f;
        self.titleTopMargin         = 20.0f;
        
    } else if (IS_IPHONE_5) {
        self.leftRightMarginMessage = 20.0f;
        self.leftRightMarginTitle   = 12.0f;
        self.messageBottomMargin    = 12.0f;
        self.titleToMessageSpacing  =  8.0f;
        self.titleTopMargin         = 20.0f;
        
    } else if (IS_IPHONE_6) {
        self.leftRightMarginMessage = 24.0f;
        self.leftRightMarginTitle   = 16.0f;
        self.messageBottomMargin    = 16.0f;
        self.titleToMessageSpacing  = 12.0f;
        self.titleTopMargin         = 24.0f;
        
    } else if (IS_IPHONE_6PLUS) {
        self.leftRightMarginMessage = 28.0f;
        self.leftRightMarginTitle   = 20.0f;
        self.messageBottomMargin    = 20.0f;
        self.titleToMessageSpacing  = 16.0f;
        self.titleTopMargin         = 28.0f;
        
    } else {
        // iPad
        self.leftRightMarginMessage = 32.0f;
        self.leftRightMarginTitle   = 24.0f;
        self.messageBottomMargin    = 24.0f;
        self.titleToMessageSpacing  = 20.0f;
        self.titleTopMargin         = 32.0f;
        
    }
}
- (void)setupViewLayout {
    
    // Title Label
    self.titleLabel                     = [[UILabel alloc] init];
    self.titleLabel.attributedText      = self.attributedTitle;
    self.titleLabel.numberOfLines       = 0;
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.alertView addSubview:self.titleLabel];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[label]-(margin)-|"
                                                                           options:0
                                                                           metrics:@{@"margin"  : @(self.leftRightMarginTitle)}
                                                                             views:@{@"label"   : self.titleLabel}]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[label]"
                                                                           options:0
                                                                           metrics:@{@"margin"  : @(self.titleTopMargin)}
                                                                             views:@{@"label"   : self.titleLabel}]];
    
    // Message Label
    self.messageLabel                   = [[UILabel alloc] init];
    self.messageLabel.attributedText    = self.attributedMessage;
    self.messageLabel.numberOfLines     = 0;
    [self.messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.alertView addSubview:self.messageLabel];
    
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[label]-(margin)-|"
                                                                           options:0
                                                                           metrics:@{@"margin"  : @(self.leftRightMarginMessage)}
                                                                             views:@{@"label"   : self.messageLabel}]];
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-(margin)-[message]"
                                                                           options:0
                                                                           metrics:@{@"margin"  : @(self.titleToMessageSpacing)}
                                                                             views:@{@"title"   : self.titleLabel,
                                                                                     @"message" : self.messageLabel}]];
    
    // TextField
    if (self.showTextField == YES) {
        self.textField                      = [[UITextField alloc] init];
        UIFont *font                        = [MSSAlertViewController messageAttributes][NSFontAttributeName];
        self.textField.borderStyle          = UITextBorderStyleRoundedRect;
        self.textField.delegate             = self;
        self.textField.font                 = font;
        self.textField.placeholder          = self.textFieldPlaceholder;
        if (self.textFieldSecure == YES) {
            self.textField.secureTextEntry  = YES;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
        [self.textField setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.alertView addSubview:self.textField];
        
        [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[textfield]-(margin)-|"
                                                                               options:0
                                                                               metrics:@{@"margin"      : @(self.leftRightMarginMessage)}
                                                                                 views:@{@"textfield"   : self.textField}]];
        [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[message]-(margin)-[textfield(==height)]"
                                                                               options:0
                                                                               metrics:@{@"margin"      : @(self.messageBottomMargin),
                                                                                         @"height"      : @(font.pointSize * 2.0f)}
                                                                                 views:@{@"message"     : self.messageLabel,
                                                                                         @"textfield"   : self.textField}]];
        
    } else {
        self.textField                  = nil;
        
    }
    
    UIButton *previousButton            = nil;
    for (int i = 0; i < self.buttonInfo.count; i = i + 1) {
        NSDictionary *info              = self.buttonInfo[i];
        NSAttributedString *title       = info[@"title"];
        UIColor *backgroundColor        = [title attribute:NSBackgroundColorAttributeName   atIndex:0 effectiveRange:NULL];
        UIFont *buttonFont              = [title attribute:NSFontAttributeName              atIndex:0 effectiveRange:NULL];
        UIButton *button                = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor          = backgroundColor;
        button.layer.borderColor        = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth        = 1.0f;
        button.tag                      = i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setAttributedTitle:title forState:UIControlStateNormal];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.alertView addSubview:button];
        [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(negativeMargin)-[button]-(negativeMargin)-|"
                                                                               options:0
                                                                               metrics:@{@"negativeMargin"  : @(-10.0f)}
                                                                                 views:@{@"button"          : button}]];
        if (previousButton == nil) {
            UIView *previousView        = (self.textField == nil)?self.messageLabel:self.textField;
            [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]-(margin)-[button(==height)]"
                                                                                   options:0
                                                                                   metrics:@{@"margin"          : @(self.messageBottomMargin),
                                                                                             @"height"          : @(buttonFont.pointSize * 3.0f)}
                                                                                     views:@{@"previousView"    : previousView,
                                                                                             @"button"          : button}]];
            
        } else {
            [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousButton]-(negativeMargin)-[button(==height)]"
                                                                                   options:0
                                                                                   metrics:@{@"negativeMargin"  : @(-1.0f),
                                                                                             @"height"          : @(buttonFont.pointSize * 3.0f)}
                                                                                     views:@{@"previousButton"  : previousButton,
                                                                                             @"button"          : button}]];
        }
        previousButton                  = button;
    }
    [self.alertView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousButton]-(negativeMargin)-|"
                                                                           options:0
                                                                           metrics:@{@"negativeMargin"  : @(-1.0f)}
                                                                             views:@{@"previousButton"  : previousButton}]];
    
}

#pragma mark -
#pragma mark - UITextField Interaction Methods
- (void)textDidChange:(NSNotification *)notification {
    UITextField *textField  = notification.object;
    self.enteredText        = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - UIViewControllerTransitioningDelegate Protocol Methods
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *vc1                           = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *vc2                           = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *con                                     = [transitionContext containerView];
    UIView *v1                                      = vc1.view;
    UIView *v2                                      = vc2.view;
    UIView *av                                      = self.alertView;
    if (vc2 == self) {
        [con addSubview:v2];
        v2.frame                                    = v1.frame;
        v2.alpha                                    = 0;
        v1.tintAdjustmentMode                       = UIViewTintAdjustmentModeDimmed;
        av.transform                                = CGAffineTransformMakeScale(1.6,1.6);
        [UIView animateWithDuration:0.25
                         animations:^{
                             v2.alpha               = 1;
                             av.transform           = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }
         ];
        
    } else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             av.transform           = CGAffineTransformMakeScale(0.5,0.5);
                             v1.alpha               = 0;
                         }
                         completion:^(BOOL finished) {
                             v2.tintAdjustmentMode  = UIViewTintAdjustmentModeAutomatic;
                             [transitionContext completeTransition:YES];
                         }
         ];
    }
}
@end