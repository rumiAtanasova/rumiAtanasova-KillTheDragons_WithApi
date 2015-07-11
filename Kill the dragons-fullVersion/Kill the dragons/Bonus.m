

#import "Bonus.h"
#import "Common.h"
#import "Enemy.h"
#import "GameScene.h"

@interface Bonus ()
@property (nonatomic, readwrite) NSInteger typeOfBonus;

@end


@implementation Bonus

- (instancetype)initWithImageNamed:(NSString *)name andEnemy:(Enemy*)enemy
{
    self = [super initWithImageNamed:name];
    if (self) {
        self.position = enemy.position;
        self.name = bonusName;
        self.zPosition = kBonusZPosition;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.categoryBitMask = bonusCategory;
        self.physicsBody.contactTestBitMask = playerCategory;
        self.physicsBody.collisionBitMask = playerCategory;
        self.physicsBody.dynamic = YES;
        
    }
    return self;
}


-(void)bonusActionsOnGameScene:(GameScene*)scene {
    if (self.position.x >= scene.size.width/2) {
        [self runAction:[self moveWithWidth:10]];       
    }
    else {
        [self runAction:[self moveWithWidth:-10]];
        
    }
}

-(void)changeBonusType:(NSInteger)type {
    self.typeOfBonus = type;
}

-(SKAction*)moveWithWidth:(CGFloat)width {
    const CGFloat moveByHeight = -(self.position.y - self.size.height)/20;
    SKAction* moveDownFirstDirection = [SKAction moveByX:width y:moveByHeight duration:0.5];
    SKAction* moveDownSecondDirection = [SKAction moveByX:-width/2 y:moveByHeight duration:0.5];
    SKAction* waitAction = [SKAction waitForDuration:2];
    SKAction* removeAction = [SKAction removeFromParent];
    SKAction* fullMoveDown = [SKAction repeatAction: [SKAction sequence:@[moveDownFirstDirection, moveDownSecondDirection]] count:10];
    SKAction* fullBonusAction = [SKAction sequence:@[fullMoveDown, waitAction, removeAction]];
    return fullBonusAction;
}


@end
