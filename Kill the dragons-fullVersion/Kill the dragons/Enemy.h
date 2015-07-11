

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface Enemy : SKSpriteNode
@property (nonatomic, readonly) NSInteger numberOfCoins;
@property (nonatomic, readonly) NSInteger health;

-(NSInteger)giveDamageToWeapon;
- (instancetype)initWithHealth:(NSInteger)health andCoins:(NSInteger)coins andDamage:(NSInteger)damage andWithGameScene:(GameScene*)scene;
- (void)changingEnemyLifeBarAndCountingHitEnemiesForScene:(GameScene*) scene;
- (void)setupProgressBar;
- (void)setupAnimationsWithAtlasKind:(NSString*)atlasKind andFrame:(NSMutableArray*) frame;
- (NSString*)setupAtlasName:(NSString*)atlasKind;
-(CGPoint)progrssBackgroundPosition;
@end
