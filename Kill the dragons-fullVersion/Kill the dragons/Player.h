

#import <SpriteKit/SpriteKit.h>
@class GameScene;

@interface Player : SKSpriteNode
@property (nonatomic, readonly) NSInteger numberOfHits;
@property (nonatomic, readonly) NSInteger health;
- (instancetype)initWithImageNamed:(NSString *)name andScene:(GameScene*)scene;
- (void) startAnimationWithKey:(NSString*) key andFrame:(NSMutableArray*)frame andTimePerFrame:(CGFloat)time;
- (void) stopAnimationWithKey:(NSString*) key;
- (void) startWalkingAnimation;
- (void) startStayingAnimation;
- (void) movingPlayerAnimationWithSceneSize:(CGSize)size andDirection:(NSInteger) direction;
- (void) changingPlayerLifeBar;
- (void) initHealth:(NSInteger)health;

@end
