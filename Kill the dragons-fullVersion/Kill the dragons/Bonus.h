
#import <SpriteKit/SpriteKit.h>
#import "Enemy.h"

@interface Bonus : SKSpriteNode
@property (nonatomic, readonly) NSInteger typeOfBonus;

- (instancetype)initWithImageNamed:(NSString*)name andEnemy:(Enemy*)enemy;
- (void)bonusActionsOnGameScene:(GameScene*)scene;
- (void)changeBonusType:(NSInteger)type;
@end
