

#import "Weapon.h"
#import "Common.h"
#import "Player.h"


static const NSInteger kWeaponMaxSize = 40;


@implementation Weapon

+ (Weapon*) generateWeaponWithImageNamed:(NSString*)name andGameScene:(GameScene*)scene{
    Weapon* weapon = [[Weapon alloc]initWithImageNamed:name];
    weapon.zPosition = 0;
    Player* player = (Player*)[scene childNodeWithName:playerName];
    weapon.position = CGPointMake(player.position.x , player.position.y + player.size.height/2);
    weapon.name = weaponName;
    weapon.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:weapon.size.height/2];
    weapon.physicsBody.dynamic = YES;
    weapon.physicsBody.categoryBitMask = weaponCategory;
    weapon.physicsBody.contactTestBitMask = enemyCategory | enemyWeaponCategory;
    weapon.physicsBody.collisionBitMask = enemyCategory | enemyWeaponCategory;
    weapon.physicsBody.usesPreciseCollisionDetection = YES;

    return weapon;
}

-(void) weaponActionsOnTheGameScene:(GameScene*) scene {
    float velocity = 300.0;
    float moveDuration = scene.size.height / velocity;
    SKAction* shootAction = [SKAction moveTo:CGPointMake(self.position.x, scene.size.height + self.size.height) duration:moveDuration];
    SKAction* resizeAction = [SKAction resizeToWidth:kWeaponMaxSize height:kWeaponMaxSize duration:0.5];
    SKAction* removeAction = [SKAction removeFromParent];
    SKAction* fullAction = [SKAction sequence:@[[SKAction group:@[shootAction, resizeAction]], removeAction]];
    [self runAction:fullAction];
}

@end
