//
//  GameViewController.h
//  Kill the dragons
//

//  Copyright (c) 2015 г. Rumyana Atanasova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface GameViewController : UIViewController <UITextFieldDelegate>
-(void)facebookConnection:(NSNotification*)notification;
@end
