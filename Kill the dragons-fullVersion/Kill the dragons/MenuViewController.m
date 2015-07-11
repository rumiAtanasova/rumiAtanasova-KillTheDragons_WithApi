//
//  MenuViewController.m
//  Kill the dragons
//
//  Created by User-03 on 7/2/15.
//  Copyright (c) 2015 Rumyana Atanasova. All rights reserved.
//

#import "MenuViewController.h"
#import "Connection.h"
#import "UserInfo.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)toHighscore:(id)sender {
}

- (IBAction)toSettings:(id)sender {
    [[Connection sharedInstance]sendingGetReqestForPath:@"userInfoManager" withParameters:[NSString stringWithFormat:@"?userId=%@", [UserInfo sharedInstance].userId] withCompletionHandler:^(NSDictionary *jsonObject) {
        NSLog(@"%@",jsonObject);
    }];
}
@end
