

#import <SpriteKit/SpriteKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "GameViewController.h"

@interface GameOverForLevel : SKScene

- (instancetype)initWithSize:(CGSize)size hasWon:(BOOL)hasWon score:(NSInteger)score andTime:(NSString*)time;
@end
