//
//  LoginViewController.m
//  Kill the dragons
//
//  Created by User-02 on 6/25/15.
//  Copyright (c) 2015 Rumyana Atanasova. All rights reserved.
//

#import "LoginViewController.h"
#import "Connection.h"
#import "UserInfo.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak,nonatomic) IBOutlet UIImageView* backgroundImage;



@end

@implementation LoginViewController

const NSInteger minPasswordLength = 6;
const NSInteger maxPasswordLength = 12;
const NSInteger minUsernameLength = 4;
const NSInteger maxUsernameLength = 10;


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}




- (IBAction)login:(id)sender {
    if (![self isLoginValid]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Invalid username or password!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
    else {
        NSDictionary* login = @{@"username" : self.usernameTextField.text,@"password":self.passwordTextField.text};
        NSLog(@"%@", login);
        
        __weak LoginViewController* weakSelf = self;

        [[Connection sharedInstance]sendingPostReqestFor:@"login" withDictionary:login withCompletionHandler:^(NSDictionary *jsonObject) {

                if ([[Connection sharedInstance]checkStausCode]==200) {
                    [[UserInfo sharedInstance]initWithId:jsonObject[@"userId"]];
                    [weakSelf performSegueWithIdentifier:@"toMenuScreen" sender:sender];
                }
                else {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Invalid Login" message:@"The User doesn't exist!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
        }];
    }
}



- (IBAction)register:(id)sender {
   
}


//Validations
-(BOOL) isLoginValid {
    if ([self.usernameTextField.text length] != 0 && [self.passwordTextField.text length] != 0) {
        return YES;
    }
    return NO;
}

//-(void)setUsernameTextField:(UITextField *)usernameTextField {
//    if ([usernameTextField.text length] >= minUsernameLength &&[usernameTextField.text length] <= maxUsernameLength ) {
//        usernameTextField = _usernameTextField;
//    }
//}
//
//
//-(void)setPasswordTextField:(UITextField *)passwordTextField {
//    if ([passwordTextField.text length] >= minPasswordLength && [passwordTextField.text length] <= maxPasswordLength) {
//        passwordTextField = _passwordTextField;
//    }
//}



@end
