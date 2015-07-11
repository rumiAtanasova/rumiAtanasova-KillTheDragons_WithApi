
#import "Enemy.h"
#import "Common.h"
#import "ProgressBar.h"
#import "GameScene.h"
#import "LevelInfo.h"
#import "MapScene.h"



@interface Enemy ()
@property (nonatomic, strong) NSMutableArray* flyFrame;
@property (nonatomic, strong) NSMutableArray* resizeFrame;
@property (nonatomic, strong) ProgressBar* progress;
@property (nonatomic, readwrite) NSInteger numberOfCoins;
@property (nonatomic, readwrite) NSInteger health;
@property (nonatomic) NSInteger numberOfHits;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger damage;
@property (nonatomic, strong) NSDictionary* atlases;


@end

static const CGFloat kMoveingLengthCoefficient = 0.5;
static const NSInteger kLeftMove = 1;
static const NSInteger kRightMove = 2;
static const NSInteger kNuberOfLoopInteractions = 20;
static const NSInteger kEnemyPosition = 5;
static const CGFloat kMaxEnemyHealthProgress = 100;


@implementation Enemy


- (instancetype)initWithHealth:(NSInteger)health andCoins:(NSInteger)coins andDamage:(NSInteger)damage andWithGameScene:(GameScene*)scene
{
    self = [super init];
    if (self) {
        self.health = health;
        self.numberOfCoins = coins;
        self.damage = damage;
        self.numberOfCoins = 100;
        self.flyFrame = [NSMutableArray array];
        self.resizeFrame = [NSMutableArray array];
        self.name = enemyName;
        self.zPosition = kEnemyZPosition;
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(60, 60) center:CGPointMake(0, 0)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = enemyCategory;
        self.physicsBody.contactTestBitMask = weaponCategory ;
        self.physicsBody.collisionBitMask = weaponCategory ;
        [self resizeDragonAnimation];
        [self setupProgressBar];
        [self enemyPositionOnGameScene:scene];
        
    }
    return self;
}

-(NSInteger)giveDamageToWeapon {
    return self.damage;
}


//move with random Y
-(NSMutableArray*) moveToCenterWithMyX:(CGFloat)myX andDuration:(CGFloat)duration {
    CGFloat x;
    NSInteger y;
    NSInteger minY = -10;
    NSInteger maxY = 0;
    
    NSMutableArray* moves = [NSMutableArray array];
    for (int i = 0; i < kNuberOfLoopInteractions; i++) {
        x = myX;
        y = (arc4random() % (maxY - minY)) + minY;
        
        SKAction* moveAction = [SKAction moveByX:x y:y duration:0.2];
        [moves addObject:moveAction];
    }
    return moves;
}

-(NSMutableArray*) moveFromCenterWithMyX:(CGFloat)myX andDuration:(CGFloat)duration {
    CGFloat x;
    NSInteger y;
    NSInteger minY = 0;
    NSInteger maxY = 10;
    
    NSMutableArray* moves = [NSMutableArray array];
    
    for (int i = 0; i < kNuberOfLoopInteractions; i++) {
        x = myX;
        y = (arc4random() % (maxY - minY)) + minY;
        
        SKAction* moveAction = [SKAction moveByX:x y:y duration:0.2];
        [moves addObject:moveAction];
    }
    return moves;
}

//create full action with different directions
- (SKAction*)makeFullActionWithFirstDirection:(NSArray*) first secondDirection:(NSArray*) second thirdDirection:(NSArray*) third andFourthDirection :(NSArray*) fourth {
    CGFloat waitDuration;
    waitDuration = ((arc4random() % (8 - 3)) + 3) / 10;
    SKAction* waitAction = [SKAction waitForDuration:waitDuration];
    SKAction* removeFromScreen = [SKAction removeFromParent];
    NSMutableArray* fullAction = [NSMutableArray array];
    [fullAction addObject:waitAction];
    if (first != nil) {
        [fullAction addObjectsFromArray:first];
    }
    if (second != nil) {
        [fullAction addObjectsFromArray:second];
    }
    if (third != nil) {
        [fullAction addObjectsFromArray:third];
    }
    if (fourth != nil) {
        [fullAction addObjectsFromArray:fourth];
    }
    
    [fullAction addObject:removeFromScreen];
    SKAction* currentAction = [SKAction sequence:fullAction];
    return currentAction;
}


-(SKAction*)createActionsWith:(NSInteger) direction {
    CGFloat lengthOneForX;
    CGFloat lengthTwoForX;
    const CGFloat lenghtX = 667/(kNuberOfLoopInteractions*2);
    if (direction == kLeftMove) {
        lengthOneForX = lenghtX;
    }
    else {
        lengthOneForX = -lenghtX;
    }
    lengthTwoForX = lengthOneForX * kMoveingLengthCoefficient;
    
//    create and return random action
    NSInteger moveNumber = (arc4random() % (5 - 1)) + 1;
    if (moveNumber == 1) {
        NSArray* firstDirection = [self moveToCenterWithMyX:lengthOneForX andDuration:0.3];
        NSArray* secondDirection = [self moveFromCenterWithMyX:lengthOneForX andDuration:0.3];

        SKAction* actionOne = [self makeFullActionWithFirstDirection:firstDirection secondDirection:secondDirection thirdDirection:nil andFourthDirection:nil];
        return actionOne;
    }
    else if (moveNumber == 2) {
        NSMutableArray* actonTwoFirstDirection = [self moveToCenterWithMyX:lengthTwoForX andDuration:0.15];
        NSMutableArray* actonTwoSecondDirection = [self moveFromCenterWithMyX:lengthTwoForX andDuration:0.15];
        NSMutableArray* actonTwoThirdDirection = [self moveToCenterWithMyX:lengthTwoForX andDuration:0.15];
        NSMutableArray* actonTwoForthDirection = [self moveFromCenterWithMyX:lengthTwoForX andDuration:0.15];
        SKAction* actionTwo = [self makeFullActionWithFirstDirection:actonTwoFirstDirection secondDirection:actonTwoSecondDirection thirdDirection:actonTwoThirdDirection andFourthDirection:actonTwoForthDirection];
        return actionTwo;
    }
    else if (moveNumber == 3){
        NSMutableArray* actonThreeFirstDirection = [self moveToCenterWithMyX:lengthOneForX andDuration:0.3];
        NSMutableArray* actonThreeSecondDirection = [self moveFromCenterWithMyX:-lengthTwoForX andDuration:0.15];
        NSMutableArray* actonThreeThirdDirection = [self moveToCenterWithMyX:lengthOneForX andDuration:0.3];
        NSMutableArray* actonThreeForthDirection = [self moveFromCenterWithMyX:lengthTwoForX andDuration:0.15];
        SKAction* actionThree = [self makeFullActionWithFirstDirection:actonThreeFirstDirection secondDirection:actonThreeSecondDirection thirdDirection:actonThreeThirdDirection andFourthDirection:actonThreeForthDirection];
        return actionThree;
    }
    else {
        NSMutableArray* actonFourFirstDirection = [self moveToCenterWithMyX:lengthOneForX andDuration:0.3];
        NSMutableArray* actonFourSecondDirection = [self moveFromCenterWithMyX:lengthTwoForX andDuration:0.15];
        NSMutableArray* actonFourThirdDirection = [self moveToCenterWithMyX:-lengthTwoForX andDuration:0.15];
        NSMutableArray* actonFourForthDirection = [self moveFromCenterWithMyX:lengthOneForX andDuration:0.3];
        SKAction* actionFour = [self makeFullActionWithFirstDirection:actonFourFirstDirection secondDirection:actonFourSecondDirection thirdDirection:actonFourThirdDirection andFourthDirection:actonFourForthDirection];
        return actionFour;
    }

}

-(void) enemyPositionOnGameScene:(GameScene*)scene {
//    counter for direction
    static NSInteger enemiesCounter = 0;
    enemiesCounter++;

    CGPoint leftPosition = CGPointMake(-kEnemyPosition, scene.size.height - kEnemyPosition);
    
    CGPoint rightPosition = CGPointMake(scene.size.width - kEnemyPosition , scene.size.height-kEnemyPosition );
    if (enemiesCounter % 2 != 0) {
        self.position = leftPosition;
        SKAction* currentAction = [self createActionsWith:kLeftMove];
        [self runAction:currentAction];
    }
    else {
        self.position = rightPosition;
        SKAction* currentAction = [self createActionsWith:kRightMove];
        [self runAction:currentAction];
    }
    
}

#pragma mark progress bar

-(CGPoint)progrssBackgroundPosition {
    CGPoint backgroundPosition = CGPointMake(0, -35);
    return backgroundPosition;
}

-(void)setupProgressBar {    
    SKSpriteNode* progressBackground = [SKSpriteNode spriteNodeWithImageNamed:@"progressBackground"];
    progressBackground.zPosition = 1;
    progressBackground.name = progressBackgroundName;
    self.progress = [[ProgressBar alloc]init];
    self.progress.zPosition = 2;
    [progressBackground addChild:self.progress];
    progressBackground.position = [self progrssBackgroundPosition];
    
    progressBackground.alpha = 0;
    SKAction* makeVisibleProgress = [SKAction fadeInWithDuration:1.2];
    __weak SKSpriteNode* weakSelf = self;
    [self runAction: [SKAction waitForDuration:1.2] completion:^{
        [weakSelf addChild:progressBackground];
    }];
    
    [progressBackground runAction:makeVisibleProgress];
    
}

- (void)changingEnemyLifeBarAndCountingHitEnemiesForScene:(GameScene*) scene {
    CGFloat changingLifeWith = kMaxEnemyHealthProgress / self.health;   
    self.numberOfHits++;
    CGFloat changingLifeBar = kMaxEnemyHealthProgress - changingLifeWith * self.numberOfHits;
    SKSpriteNode* bac = (SKSpriteNode*) [self childNodeWithName:progressBackgroundName];
    self.progress = (ProgressBar*)[bac childNodeWithName:progressBarName];
    [self.progress setProgress:changingLifeBar];
    if (changingLifeBar <= 0) {
        [self runAction:[SKAction sequence:@[[SKAction removeFromParent]]]];
        [scene sumEnemyDestroyed];
    }
}


#pragma mark animations

- (NSString*)setupAtlasName:(NSString*)atlasKind {
    NSInteger indexForLevel = [MapScene sharedInstance].choosenLevel -1;
    NSString* atlasName = [self.atlases[atlasKind] objectAtIndex:indexForLevel];
    return atlasName;
}

- (void)setupAnimationsWithAtlasKind:(NSString*)atlasKind andFrame:(NSMutableArray*)frame  {
    NSString* atlasName = [self setupAtlasName:atlasKind];
    SKTextureAtlas* currentAtlas = [SKTextureAtlas atlasNamed:atlasName];
    NSMutableArray* imageNames = [NSMutableArray array];
    imageNames = (NSMutableArray*)[currentAtlas textureNames];
    imageNames = (NSMutableArray*)[imageNames sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    for (NSString* fileName in imageNames) {
        SKTexture* tempTexture = [currentAtlas textureNamed:fileName];
        if (tempTexture) {
            [frame addObject:tempTexture];
        }
    }
    
}

-(void)resizeDragonAnimation {
    [self setupAnimationsWithAtlasKind:@"smallAtlases" andFrame:self.resizeFrame];
    [self setupAnimationsWithAtlasKind:@"bigAtlases" andFrame:self.flyFrame];
    SKAction* resizeAction =  [SKAction animateWithTextures:self.resizeFrame timePerFrame:0.2 resize:YES restore:NO];
    SKAction* realSizeFlying = [SKAction repeatActionForever:[SKAction animateWithTextures:self.flyFrame timePerFrame:0.2 resize:YES restore:NO]];
    [self runAction:[SKAction sequence:@[resizeAction, realSizeFlying]]];
    
}


//lazy loading
-(NSDictionary*)atlases {
    if (_atlases == nil) {
        NSMutableArray* bigAtlases = [NSMutableArray array];
        NSMutableArray* smallAtlases = [NSMutableArray array];
        [bigAtlases addObject:@"redDragons"];
        [bigAtlases addObject:@"blueDragons"];
        [bigAtlases addObject:@"purpleDragons"];
        [bigAtlases addObject:@"greenDragons"];
        [bigAtlases addObject:@"whiteDragons"];
        [bigAtlases addObject:@"redDragons"];
        [smallAtlases addObject:@"redSmallDragons"];
        [smallAtlases addObject:@"blueSmallDragons"];
        [smallAtlases addObject:@"purpleSDragons"];
        [smallAtlases addObject:@"greenSmallDragons"];
        [smallAtlases addObject:@"whiteSmallDragons"];
        [smallAtlases addObject:@"redSmallDragons"];
        self.atlases = @{@"bigAtlases":bigAtlases, @"smallAtlases":smallAtlases};
    }
    return _atlases;
}

@end
