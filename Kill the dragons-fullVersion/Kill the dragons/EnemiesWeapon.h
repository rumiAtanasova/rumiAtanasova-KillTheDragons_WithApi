

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "Enemy.h"

@interface EnemiesWeapon : SKSpriteNode
@property (nonatomic, readonly) NSInteger enemyDamage;
- (instancetype)initWithEnemy:(Enemy*)enemy;
+ (CGPoint)createPositionWithEnemy:(Enemy*)enemy;
- (void) weaponActionsOnTheGameScene:(GameScene*) scene;
- (SKAction*)startAction;

@end
