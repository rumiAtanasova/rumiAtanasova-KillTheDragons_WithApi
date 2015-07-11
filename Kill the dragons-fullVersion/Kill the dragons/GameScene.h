

#import <SpriteKit/SpriteKit.h>
#import "Player.h"

@interface GameScene : SKScene
@property (nonatomic, readonly) NSInteger sumOfCoinsForLevel;
- (instancetype)initWithSize:(CGSize)size andPlayerHealth:(NSInteger)health andEnemies:(NSArray*)enemies;
-(void)sumEnemyDestroyed;
@end
