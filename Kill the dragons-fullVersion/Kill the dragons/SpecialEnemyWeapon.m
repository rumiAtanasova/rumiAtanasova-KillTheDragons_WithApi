

#import "SpecialEnemyWeapon.h"
#import "SpecialEnemy.h"

@interface SpecialEnemyWeapon ()

@end

@implementation SpecialEnemyWeapon
- (instancetype)initWithEnemy:(Enemy*)enemy{
    self = [super initWithEnemy:enemy];
    if (self) {
        UIImage* image = [UIImage imageNamed:@"specialDragonFire"];
        self.texture = [SKTexture textureWithImage:image];
    }
    return self;
}

- (SKAction*)startAction {
    SKAction* waitAction = [SKAction waitForDuration:0.1];
    return waitAction;
}


@end
