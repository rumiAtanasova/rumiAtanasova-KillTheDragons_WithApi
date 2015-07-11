
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface Weapon : SKSpriteNode
+ (Weapon*) generateWeaponWithImageNamed:(NSString*)name andGameScene:(GameScene*)scene;
-(void) weaponActionsOnTheGameScene:(GameScene*) scene;

@end
