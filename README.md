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


<b>Options:</b>

Have a look at ViewController.h/.m in the demo project to see some ways to style
and use the controller in your project! The code is built to accept `NSString` values
and apply default styling to all of them, or you can supply `NSAttributedString`
values to pre-configure your text. 1
