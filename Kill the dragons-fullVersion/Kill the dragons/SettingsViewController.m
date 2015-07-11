//
//  SettingsViewController.m
//  Kill the dragons
//
//  Created by User-03 on 6/28/15.
//  Copyright (c) 2015 Rumyana Atanasova. All rights reserved.
//

#import "SettingsViewController.h"
#import "Connection.h"
#import "UserInfo.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmedPassword;
@property (weak, nonatomic) IBOutlet UISwitch *notificationsSwitch;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITextField *updatedPassword;

@property (nonatomic) BOOL isEditing;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    __weak SettingsViewController* weakSelf = self;
    
    [[Connection sharedInstance]sendingGetReqestForPath:@"userInfoManager" withParameters:[NSString stringWithFormat:@"?userId=%@", [UserInfo sharedInstance].userId] withCompletionHandler:^(NSDictionary *jsonObject) {
    
    NSNumber* a = [[NSNumber alloc]initWithInt:0];
        
        weakSelf.usernameTextField.text = jsonObject[@"username"];
        weakSelf.emailTextField.text = jsonObject[@"email"];
        if ([jsonObject[@"allowNotification"] isEqualToNumber:a]) {
            weakSelf.notificationsSwitch.on = NO;
        }
        else {
            weakSelf.notificationsSwitch.on = YES;
        }
    }];
    self.isEditing = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)edit:(id)sender {
    if (!self.isEditing) {
        [self editInfo];
    }
    else {
        [[UserInfo sharedInstance] changeProfilPassword:self.passwordTextField.text withNewPassword:self.updatedPassword.text withEmail:self.emailTextField.text andNotifications:self.notificationsSwitch.on];
        [self editInfo];
    }
}



-(void) editInfo {
    if (!self.isEditing) {
        self.isEditing = YES;
        [self.editButton setImage:[UIImage imageNamed:@"done_button.png"] forState:UIControlStateNormal];
        self.passwordTextField.userInteractionEnabled = YES;
        self.confirmedPassword.userInteractionEnabled = YES;
        self.updatedPassword.userInteractionEnabled = YES;
        self.notificationsSwitch.userInteractionEnabled = YES;
    }
    else {
        self.isEditing = NO;
        [self.editButton setImage:[UIImage imageNamed:@"edit_button.png"] forState:UIControlStateNormal];
        self.passwordTextField.userInteractionEnabled = NO;
        self.confirmedPassword.userInteractionEnabled = NO;
        self.notificationsSwitch.userInteractionEnabled = NO;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"User Info" message:@"Changes are made" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
