//  ViewController.m
//  AlertViewControllerDemo
//  Created by Michael McEvoy on 2/8/15.
//  Copyright (c) 2015 Mustard Seed Software LLC. All rights reserved.
// Header import
#import "ViewController.h"
// Other imports
#import "MSSAlertViewController.h"
@interface ViewController () {
    
}
#pragma mark -
#pragma mark - UI "Constants"
@property (assign, nonatomic) CGFloat    buttonBorderWidth;
@property (assign, nonatomic) CGFloat    buttonCornerRadius;
@property (assign, nonatomic) CGFloat    buttonFontSize;
@property (assign, nonatomic) CGFloat    buttonHeight;
@property (strong, nonatomic) UIFont    *buttonFont;

#pragma mark -
#pragma mark - UI Controls
@property (strong, nonatomic) UIButton  *chainingAlertButton;
@property (strong, nonatomic) UIButton  *customizedAlertButton;
@property (strong, nonatomic) UIButton  *normalAlertButton;
@property (strong, nonatomic) UIButton  *passwordAlertButton;
@property (strong, nonatomic) UIButton  *textAlertButton;

@end

@implementation ViewController
#pragma mark -
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUserInterface];
}

#pragma mark -
#pragma mark - Button Press
- (void)chainingAlertButtonPressed {
    MSSAlertViewController *alert1  = [MSSAlertViewController alertWithTitle:@"This is a first alert!"
                                                                     message:@"This is the first alert's message!"];
    [alert1 addButtonWithTitle:@"Dismiss Alert 1"
                    tapHandler:^{
                        MSSAlertViewController *alert2  = [MSSAlertViewController alertWithTitle:@"This is a second alert!"
                                                                                         message:@"This is the second alert's message!"];
                        [alert2 addButtonWithTitle:@"Dismiss Alert 2"
                                        tapHandler:nil
                         ];
                        [self presentViewController:alert2 animated:YES completion:nil];
                    }
     ];
    [self presentViewController:alert1 animated:YES completion:nil];
}
- (void)customizedAlertButtonPressed {
    UIFont *titleFont               = [UIFont fontWithName:@"GillSans-Bold" size:self.buttonFontSize];
    UIFont *messageFont             = [UIFont fontWithName:@"Courier"       size:self.buttonFontSize - 6];
    NSAttributedString *attTitle    = [[NSAttributedString alloc] initWithString:@"This is a customized alert."
                                                                      attributes:@{NSFontAttributeName              : titleFont,
                                                                                   NSForegroundColorAttributeName   : [UIColor redColor]}
                                       ];
    NSAttributedString *attMessage  = [[NSAttributedString alloc] initWithString:@"This is a customized message."
                                                                      attributes:@{NSFontAttributeName              : messageFont,
                                                                                   NSForegroundColorAttributeName   : [UIColor blueColor]}
                                       ];
    
    MSSAlertViewController *alert   = [MSSAlertViewController alertWithAttributedTitle:attTitle attributedMessage:attMessage];
    
    UIFont *button1Font             = [UIFont fontWithName:@"AmericanTypewriter"        size:self.buttonFontSize];
    UIFont *button2Font             = [UIFont fontWithName:@"Baskerville-BoldItalic"    size:self.buttonFontSize - 1];
    UIFont *button3Font             = [UIFont fontWithName:@"ChalkboardSE-Regular"      size:self.buttonFontSize - 2];
    UIFont *button4Font             = [UIFont fontWithName:@"Chalkduster"               size:self.buttonFontSize - 3];
    UIFont *button5Font             = [UIFont fontWithName:@"HoeflerText-BlackItalic"   size:self.buttonFontSize - 4];
    UIFont *button6Font             = [UIFont fontWithName:@"SnellRoundhand"            size:self.buttonFontSize - 5];
    
    NSAttributedString *attButton1  = [[NSAttributedString alloc] initWithString:@"Button 1"
                                                                      attributes:@{NSFontAttributeName              : button1Font,
                                                                                   NSForegroundColorAttributeName   : [UIColor greenColor]}
                                       ];
    [alert addButtonWithAttributedTitle:attButton1 tapHandler:nil];
    
    NSAttributedString *attButton2  = [[NSAttributedString alloc] initWithString:@"Button 2"
                                                                      attributes:@{NSBackgroundColorAttributeName   : [UIColor blackColor],
                                                                                   NSFontAttributeName              : button2Font,
                                                                                   NSForegroundColorAttributeName   : [UIColor yellowColor]}
                                       ];
    [alert addButtonWithAttributedTitle:attButton2 tapHandler:nil];
    
    NSAttributedString *attButton3  = [[NSAttributedString alloc] initWithString:@"Button 3"
                                                                      attributes:@{NSFontAttributeName              : button3Font,
                                                                                   NSForegroundColorAttributeName   : [UIColor purpleColor]}
                                       ];
    [alert addButtonWithAttributedTitle:attButton3 tapHandler:nil];
    
    NSAttributedString *attButton4  = [[NSAttributedString alloc] initWithString:@"Button 4"
                                                                      attributes:@{NSFontAttributeName              : button4Font,
                                                                                   NSForegroundColorAttributeName   : [UIColor blackColor]}
                                       ];
    [alert addButtonWithAttributedTitle:attButton4 tapHandler:nil];
    
    NSAttributedString *attButton5  = [[NSAttributedString alloc] initWithString:@"Button 5"
                                                                      attributes:@{NSFontAttributeName              : button5Font,
                                                                                   NSForegroundColorAttributeName   : [[UIColor blackColor] colorWithAlphaComponent:0.4f]}
                                       ];
    [alert addButtonWithAttributedTitle:attButton5 tapHandler:nil];
    
    NSAttributedString *attButton6  = [[NSAttributedString alloc] initWithString:@"Button 6"
                                                                      attributes:@{NSFontAttributeName              : button6Font,
                                                                                   NSForegroundColorAttributeName   : [UIColor lightGrayColor]}
                                       ];
    [alert addButtonWithAttributedTitle:attButton6 tapHandler:nil];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)normalAlertButtonPressed {
    MSSAlertViewController *alert   = [MSSAlertViewController alertWithTitle:@"This is a normal alert!" message:@"This is the normal alert's message!"];
    [alert addButtonWithTitle:@"OK"         tapHandler:nil];
    [alert addButtonWithTitle:@"Option 1"   tapHandler:nil];
    [alert addButtonWithTitle:@"Option 2"   tapHandler:nil];
    [alert addButtonWithTitle:@"Cancel"     tapHandler:nil];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)passwordAlertButtonPressed {
    MSSAlertViewController *alert   = [MSSAlertViewController alertWithTitle:@"This is a secure, password-entry alert!" message:nil];
    __weak typeof(alert) weakAlert  = alert;
    alert.showTextField             = YES;
    alert.textFieldSecure           = YES;
    [alert addButtonWithTitle:@"OK"
                   tapHandler:^{
                       NSString *password               = weakAlert.enteredText;
                       MSSAlertViewController *alert2   = [MSSAlertViewController alertWithTitle:@"Entered Password was:\n(Don't do this in your app!)" message:password];
                       [alert2 addButtonWithTitle:@"OK" tapHandler:nil];
                       [self presentViewController:alert2 animated:YES completion:nil];
                   }
     ];
    [alert addButtonWithTitle:@"Cancel"     tapHandler:nil];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)textAlertButtonPressed {
    MSSAlertViewController *alert   = [MSSAlertViewController alertWithTitle:@"This is a text-entry alert!" message:@"Enter some text below..."];
    __weak typeof(alert) weakAlert  = alert;
    alert.showTextField             = YES;
    [alert addButtonWithTitle:@"OK"
                   tapHandler:^{
                       NSString *text                   = weakAlert.enteredText;
                       MSSAlertViewController *alert2   = [MSSAlertViewController alertWithTitle:@"The text you entered was:" message:text];
                       [alert2 addButtonWithTitle:@"OK" tapHandler:nil];
                       [self presentViewController:alert2 animated:YES completion:nil];
                   }
     ];
    [alert addButtonWithTitle:@"Cancel"     tapHandler:nil];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -
#pragma mark - UI Setup
- (void)setupUserInterface {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControls];
    // Because the default color is black, for some reason
    self.view.backgroundColor   = [UIColor whiteColor];
}
- (void)createConstants {
    if (IS_IPHONE_4) {
        self.buttonBorderWidth  =  1.0f;
        self.buttonCornerRadius =  4.0f;
        self.buttonFontSize     = 14.0f;
        self.buttonHeight       = 40.0f;
        
    } else if (IS_IPHONE_5) {
        self.buttonBorderWidth  =  1.0f;
        self.buttonCornerRadius =  4.0f;
        self.buttonFontSize     = 17.0f;
        self.buttonHeight       = 40.0f;
        
    } else if (IS_IPHONE_6) {
        self.buttonBorderWidth  =  1.5f;
        self.buttonCornerRadius =  5.0f;
        self.buttonFontSize     = 20.0f;
        self.buttonHeight       = 50.0f;
        
    } else if (IS_IPHONE_6PLUS) {
        self.buttonBorderWidth  =  1.5f;
        self.buttonCornerRadius =  6.0f;
        self.buttonFontSize     = 24.0f;
        self.buttonHeight       = 60.0f;
        
    } else {
        // iPad
        self.buttonBorderWidth  =  1.5f;
        self.buttonCornerRadius =  6.0f;
        self.buttonFontSize     = 28.0f;
        self.buttonHeight       = 60.0f;
        
    }
    self.buttonFont             = [UIFont systemFontOfSize:self.buttonFontSize];
}
- (void)createControls {
    self.normalAlertButton      = [UIButton buttonWithType:UIButtonTypeSystem];
    self.customizedAlertButton  = [UIButton buttonWithType:UIButtonTypeSystem];
    self.chainingAlertButton    = [UIButton buttonWithType:UIButtonTypeSystem];
    self.textAlertButton        = [UIButton buttonWithType:UIButtonTypeSystem];
    self.passwordAlertButton    = [UIButton buttonWithType:UIButtonTypeSystem];
}
- (void)setupControls {
    self.normalAlertButton.layer.borderColor        = self.normalAlertButton.tintColor.CGColor;
    self.normalAlertButton.layer.borderWidth        = 1.0f;
    self.normalAlertButton.layer.cornerRadius       = 4.0f;
    self.normalAlertButton.titleLabel.font          = self.buttonFont;
    [self.normalAlertButton addTarget:self action:@selector(normalAlertButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.normalAlertButton setTitle:@"Normal Alert" forState:UIControlStateNormal];
    [self.normalAlertButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.customizedAlertButton.layer.borderColor    = self.customizedAlertButton.tintColor.CGColor;
    self.customizedAlertButton.layer.borderWidth    = 1.0f;
    self.customizedAlertButton.layer.cornerRadius   = 4.0f;
    self.customizedAlertButton.titleLabel.font      = self.buttonFont;
    [self.customizedAlertButton addTarget:self action:@selector(customizedAlertButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.customizedAlertButton setTitle:@"Customized Alert" forState:UIControlStateNormal];
    [self.customizedAlertButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.chainingAlertButton.layer.borderColor      = self.chainingAlertButton.tintColor.CGColor;
    self.chainingAlertButton.layer.borderWidth      = 1.0f;
    self.chainingAlertButton.layer.cornerRadius     = 4.0f;
    self.chainingAlertButton.titleLabel.font        = self.buttonFont;
    [self.chainingAlertButton addTarget:self action:@selector(chainingAlertButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.chainingAlertButton setTitle:@"Chained Alerts" forState:UIControlStateNormal];
    [self.chainingAlertButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.textAlertButton.layer.borderColor          = self.textAlertButton.tintColor.CGColor;
    self.textAlertButton.layer.borderWidth          = 1.0f;
    self.textAlertButton.layer.cornerRadius         = 4.0f;
    self.textAlertButton.titleLabel.font            = self.buttonFont;
    [self.textAlertButton addTarget:self action:@selector(textAlertButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.textAlertButton setTitle:@"Text Alert" forState:UIControlStateNormal];
    [self.textAlertButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.passwordAlertButton.layer.borderColor      = self.passwordAlertButton.tintColor.CGColor;
    self.passwordAlertButton.layer.borderWidth      = 1.0f;
    self.passwordAlertButton.layer.cornerRadius     = 4.0f;
    self.passwordAlertButton.titleLabel.font        = self.buttonFont;
    [self.passwordAlertButton addTarget:self action:@selector(passwordAlertButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.passwordAlertButton setTitle:@"Password Alert" forState:UIControlStateNormal];
    [self.passwordAlertButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}
- (void)layoutControls {
    [self.view addSubview:self.normalAlertButton];
    [self.view addSubview:self.customizedAlertButton];
    [self.view addSubview:self.chainingAlertButton];
    [self.view addSubview:self.textAlertButton];
    [self.view addSubview:self.passwordAlertButton];
 
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"button"       : self.normalAlertButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"button"       : self.customizedAlertButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"button"       : self.chainingAlertButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"button"       : self.textAlertButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[button]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"button"       : self.passwordAlertButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40)-[normal(==height)]-[customized(==height)]-[chaining(==height)]-[text(==height)]-[password(==height)]"
                                                                      options:0
                                                                      metrics:@{@"height"       : @(self.buttonHeight)}
                                                                        views:@{@"normal"       : self.normalAlertButton,
                                                                                @"customized"   : self.customizedAlertButton,
                                                                                @"chaining"     : self.chainingAlertButton,
                                                                                @"text"         : self.textAlertButton,
                                                                                @"password"     : self.passwordAlertButton}]];
}
@end