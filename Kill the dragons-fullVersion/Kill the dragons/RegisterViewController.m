//
//  RegisterViewController.m
//  Kill the dragons
//
//  Created by User-03 on 6/25/15.
//  Copyright (c) 2015 Rumyana Atanasova. All rights reserved.
//

#import "RegisterViewController.h"
#import "Connection.h"

#import "UserInfo.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmedPass;

@end

@implementation RegisterViewController

extern const NSInteger minPasswordLength;
extern const NSInteger maxPasswordLength;
extern const NSInteger minUsernameLength;
extern const NSInteger maxUsernameLength;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextField.delegate =self;
    self.confirmedPass.delegate = self;
    self.emailTextField.delegate = self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)submit:(id)sender {
    if ([self isRegistrationValid]) {
        NSDictionary* registration = @{@"username":self.usernameTextField.text,@"password":self.passwordTextField.text,@"email":self.emailTextField.text};
        
        __weak RegisterViewController* weakSelf = self;
        
        [[Connection sharedInstance]sendingPostReqestFor:@"registration" withDictionary:registration withCompletionHandler:^(NSDictionary *jsonObject) {
            if ([[Connection sharedInstance]checkStausCode]==200) {
                [[UserInfo sharedInstance]initWithId:jsonObject[@"userId"]];
                [weakSelf performSegueWithIdentifier:@"toMenuFromReg" sender:sender];
            }
        }];
        
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Invalid Registration" message:@"Incorrect username, password or e-mail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}


//scrolling the view when submitting text
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130;
    const float movementDuration = 0.3f;
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


#pragma mark Validations

-(BOOL) isRegistrationValid {
    if ([self.usernameTextField.text length] != 0 && [self.emailTextField.text length] != 0 && [self isPasswordValid] && [self isValidEmail:self.emailTextField.text]) {
        return YES;
    }
    return NO;
}

-(BOOL) isPasswordValid {
    if ([self.passwordTextField.text isEqualToString:self.confirmedPass.text] && [self.passwordTextField.text length] >= minPasswordLength && [self.passwordTextField.text length]<= maxPasswordLength && [self.confirmedPass.text length] >= minPasswordLength && [self.confirmedPass.text length]<= maxPasswordLength) {
        return YES;
    }
    return NO;
}

-(BOOL) isValidEmail: (NSString*) checkString{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}



@end
