
#import "EnemiesWeapon.h"
#import "GameScene.h"
#import "Common.h"
#import "Enemy.h"

@interface EnemiesWeapon ()
@property (nonatomic, readwrite) NSInteger enemyDamage;
@end

static const NSInteger kWeaponMaxSize = 30;

@implementation EnemiesWeapon

- (instancetype)initWithEnemy:(Enemy*)enemy
{
    self = [super init];
    if (self) {
        self.enemyDamage = [enemy giveDamageToWeapon];
        UIImage* image = [UIImage imageNamed:@"dragonFire.png"];
        self.texture = [SKTexture textureWithImage:image];
        self.zPosition = 0;
        self.position = [EnemiesWeapon createPositionWithEnemy:enemy];
        self.name = enemiesWeaponName;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.height/2];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = enemyWeaponCategory;
        self.physicsBody.contactTestBitMask = playerCategory | weaponCategory;
        self.physicsBody.collisionBitMask = playerCategory | weaponCategory;
        self.physicsBody.usesPreciseCollisionDetection = YES;
    }
    return self;
}

+(CGPoint)createPositionWithEnemy:(Enemy*)enemy {
    CGPoint position = CGPointMake(enemy.position.x, enemy.position.y - enemy.texture.size.height/2);    
    return position;
}

- (SKAction*)startAction {
   SKAction* waitAction = [SKAction waitForDuration:0.01];
    return waitAction;
}

-(void) weaponActionsOnTheGameScene:(GameScene*) scene {
    float velocity = 300.0;
    float moveDuration = scene.size.height / velocity;
    SKAction* waitAction = [self startAction];
    SKAction* shootAction = [SKAction moveTo:CGPointMake(self.position.x, - self.size.height) duration:moveDuration];
    SKAction* resizeAction = [SKAction resizeToWidth:kWeaponMaxSize height:kWeaponMaxSize duration:1];
    SKAction* removeAction = [SKAction removeFromParent];
    SKAction* fullAction = [SKAction sequence:@[waitAction, [SKAction group:@[shootAction, resizeAction]], removeAction]];
    [self runAction:fullAction];
}


@end
