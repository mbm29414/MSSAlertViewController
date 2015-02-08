# MSSAlertViewController
A blocks-based replacement for Apple's UIAlertView.

<b>Usage:</b>

Simply add MSSAlertViewController.h/.m to your project and you'll be good to go!


Here's a basic, "OK only" alert:

    MSSAlertViewController *alert = [MSSAlertViewController 
                                        alertWithTitle:@"Alert Title" 
                                               message:@"Alert Message"];
    [alert addButtonWithTitle:@"OK" 
                   tapHandler:nil];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];


Here's how you'd execute condition code based on the button clicked/tapped:

    MSSAlertViewController *alert = [MSSAlertViewController 
                                        alertWithTitle:@"Alert Title" 
                                               message:@"Alert Message"];
    [alert addButtonWithTitle:@"OK" 
                   tapHandler:^{
                       // "OK" code goes here
                   }];
    [alert addButtonWithTitle:@"Cancel" 
                   tapHandler:^{
                       // "Cancel" code goes here
                   }];                   
    [self presentViewController:alert
                       animated:YES
                     completion:nil];


If you want to use this form for text entry, it's pretty easy:

    MSSAlertViewController *alert   = [MSSAlertViewController alertWithTitle:@"This is a text-entry alert!" message:@"Enter some text below..."];
    __weak typeof(alert) weakAlert  = alert;
    alert.showTextField             = YES;
    [alert addButtonWithTitle:@"OK"
                   tapHandler:^{
                       NSString *text                   = weakAlert.enteredText;
                       // Now, do something with it...
                   }
     ];
    // In case the user doesn't want to enter anything...
    [alert addButtonWithTitle:@"Cancel"     tapHandler:nil];
    [self presentViewController:alert animated:YES completion:nil];
    
What about a password entry form? That's pretty easy, too:

    MSSAlertViewController *alert   = [MSSAlertViewController alertWithTitle:@"This is a secure, password-entry alert!" message:nil];
    __weak typeof(alert) weakAlert  = alert;
    alert.showTextField             = YES;
    alert.textFieldSecure           = YES;
    [alert addButtonWithTitle:@"OK"
                   tapHandler:^{
                       NSString *password               = weakAlert.enteredText;
                       // Now, you've got the password...
                   }
     ];
    [alert addButtonWithTitle:@"Cancel"     tapHandler:nil];
    [self presentViewController:alert animated:YES completion:nil];

<b>Options:</b>

Have a look at ViewController.h/.m in the demo project to see some ways to style
and use the controller in your project! The code is built to accept `NSString` values
and apply default styling to all of them, or you can supply `NSAttributedString`
values to pre-configure your text. 1
