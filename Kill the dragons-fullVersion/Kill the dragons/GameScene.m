
#import "GameScene.h"
#import "Common.h"
#import "Background.h"
#import "Player.h"
#import "Enemy.h"
#import "Controllers.h"
#import "Weapon.h"
#import "ProgressBar.h"
#import "EnemiesWeapon.h"
#import "AppDelegate.h"
#import "MapScene.h"
#import "LevelInfo.h"
#import "SpecialEnemy.h"
#import "SpecialEnemyWeapon.h"
#import "GameOverForLevel.h"
#import "LevelsBonuses.h"
#import "Bonus.h"
#import "MagicFog.h"
#import "Connection.h"
@import AVFoundation;


@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic) NSInteger levelNumber;
@property (strong, nonatomic) Background* background;
@property (strong, nonatomic) Player* player;
@property (strong, nonatomic) Controllers* tapLeft;
@property (strong, nonatomic) Controllers* tapRight;
@property (strong, nonatomic) Controllers* tapCenter;
@property (strong, nonatomic) Controllers* pauseButton;
@property (nonatomic, strong) AVAudioPlayer * backgroundMusicPlayer;
@property (nonatomic) NSInteger numberOfEnemiesTypeOneForLevel;
@property (nonatomic) NSInteger numberOfEnemiesTypeTwoForLevel;
@property (nonatomic) NSInteger numberOfEnemiesOnScreen;
@property (nonatomic) NSInteger enemiesDestroyed;
@property (nonatomic) NSInteger enemiesForDestroyed;
@property (nonatomic, strong) NSString* currendEnemiesForDestroed;
@property (nonatomic) NSInteger scoreForLevel;
@property (strong, nonatomic) SKLabelNode* scoreLabel;
@property (strong, nonatomic) SKLabelNode* levelTime;
@property (nonatomic) NSTimeInterval currentTime;
@property (strong, nonatomic) NSDate* levelStartDate;
@property (strong, nonatomic) SKLabelNode* numberOfEnemiesForDestroed;
@property (strong, nonatomic) SKLabelNode* playerHealth;
@property (strong, nonatomic) LevelsBonuses* levelBonuses;
@property (strong, nonatomic) NSMutableArray* bonuses;
@property (nonatomic) NSInteger currentBonusType;
@property (nonatomic, strong) MagicFog* magicEmitter;
@property (nonatomic, strong) NSArray* enemies;




@end

static const NSInteger kLevels = 6;
static const NSInteger kEnemiesForDestroedDivider = 4;
static const NSInteger kToolBalLabelsPositionMinus = 10;
static const NSInteger kBonusCoins = 250;
static const NSInteger kEnemyOneCoins = 100;
static const NSInteger kEnemyTwoCoins = 150;

@implementation GameScene

- (instancetype)initWithSize:(CGSize)size andPlayerHealth:(NSInteger)health andEnemies:(NSArray*)enemies
{
    
    if (self = [super initWithSize:size]) {
        self.enemies = enemies;
        [self infoForLevel];        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        self.numberOfEnemiesOnScreen = kEnemiesOnScreen;
        self.levelBonuses = [[LevelsBonuses alloc]init];
        self.bonuses = [self.levelBonuses bonusesForLevel:self.levelNumber-1];
        self.background = [Background generateBackgroundWithImage:[[MapScene sharedInstance].level backgroundForChoosenLevel:self.levelNumber]];
        [self addChild: self.background];
        self.player =[[Player alloc]initWithImageNamed:@"wizard" andScene:self];
        [self addChild:self.player];
        [self.player initHealth:health];
        [self createToolBarAndLabels];
        [self createControlers];
        [self backgroundMusic];
        
        
    }
    return self;
}


- (void)infoForLevel {
    self.levelNumber = [[MapScene sharedInstance]choosenLevel];
    NSNumber* numberOfEnemiesTypeOne = self.enemies[0][@"count"];
    self.numberOfEnemiesTypeOneForLevel = [numberOfEnemiesTypeOne integerValue];
    NSNumber* numberOfEnemiesTypeTwo = self.enemies[1][@"count"];
    self.numberOfEnemiesTypeTwoForLevel = [numberOfEnemiesTypeTwo integerValue];
    NSInteger counter = 0;
    for (NSDictionary* dict in self.enemies) {
        NSNumber* countingEnemies = dict[@"count"];
        counter += [countingEnemies integerValue];
    }
    self.enemiesForDestroyed = counter / kEnemiesForDestroedDivider;
}

-(void)handleNotifications:(NSNotification*)notification {
    if ([notification.name isEqualToString:@"pauseGame"]) {
        self.paused = YES;
    }
}

-(void)shootEnemy {
    Weapon* weapon = [Weapon generateWeaponWithImageNamed:@"magicBall" andGameScene:self];
    [self addChild: weapon];
    [weapon weaponActionsOnTheGameScene:self];
}

#pragma mark scene nodes

-(void)createToolBarAndLabels {
//    create toolBar
    SKSpriteNode* toolBar = [SKSpriteNode spriteNodeWithImageNamed: @"toolBar.png" ];
    toolBar.position = CGPointMake(self.size.width/2, self.size.height - toolBar.size.height/2);
    [self addChild:toolBar];
    
//    time label
    self.levelStartDate = [NSDate date];
    __weak GameScene* weakSelf = self;
    SKAction* addTime = [SKAction runBlock:^{
        weakSelf.levelTime.text = [weakSelf giveCurrentTime];
    }];
    
    SKAction* timeWaitAction = [SKAction waitForDuration:0.2];
    self.levelTime = [GameScene generateLabelWithPosition:CGPointMake(toolBar.size.width/3, -5) andText:[self giveCurrentTime]];
    [self.levelTime runAction:[SKAction repeatActionForever:[SKAction sequence:@[addTime, timeWaitAction]]]];
    [toolBar addChild:self.levelTime];
    
//    enemies destroed label
    self.currendEnemiesForDestroed = [NSString  stringWithFormat:@"Destroyed: %ld/%ld",  self.enemiesDestroyed, self.enemiesForDestroyed];
    self.numberOfEnemiesForDestroed = [GameScene generateLabelWithPosition:CGPointMake(-toolBar.size.width/3, -5) andText:self.currendEnemiesForDestroed];
    [toolBar addChild:self.numberOfEnemiesForDestroed];
    
//   player health label
    self.playerHealth = [GameScene generateLabelWithPosition:CGPointMake(-toolBar.size.width/3 + self.numberOfEnemiesForDestroed.frame.size.width, -5) andText:[NSString stringWithFormat:@"Health: %ld",self.player.health]];
    [toolBar addChild:self.playerHealth];
//    score label
    self.scoreLabel = [GameScene generateLabelWithPosition:CGPointMake(self.playerHealth.position.x + self.playerHealth.frame.size.width*2, -5) andText:[NSString stringWithFormat:@"Score: %ld", self.scoreForLevel]];
    [toolBar addChild:self.scoreLabel];
//    pause button
    self.pauseButton = [[Controllers alloc]initWithImageNamed:@"pause"];
    self.pauseButton.position = CGPointMake(0, 0);
    self.pauseButton.name = @"pause";
    [toolBar addChild:self.pauseButton];
}

-(NSString*) giveCurrentTime {
    int min = (self.currentTime / 60)* -1;
    int hours = (fmod((self.currentTime / 3600), 60)* -1);
    int sec = ((fmod(self.currentTime, 60))* -1);
    NSString* labelTimeText = [NSString stringWithFormat:@"Time: %d:%d:%d", hours, min, sec];
    return labelTimeText;
}

-(void)backgroundMusic {
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"backgroundSound" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
}

-(void)createControlers {
    self.tapRight = [[Controllers alloc]initWithImageNamed:@"right.png"];
    self.tapRight.position = CGPointMake(self.size.width - self.tapRight.size.width/2-kToolBalLabelsPositionMinus, 40);
    self.tapRight.name = @"right";
    [self addChild:self.tapRight];
    
    self.tapCenter= [[Controllers alloc]initWithImageNamed:@"center.png"];
    self.tapCenter.position = CGPointMake(self.size.width - self.tapRight.size.width-kToolBalLabelsPositionMinus - self.tapCenter.size.width/2, 40);
    self.tapCenter.name = @"center";
    [self addChild:self.tapCenter];
    
    self.tapLeft = [[Controllers alloc]initWithImageNamed:@"left.png"];
    self.tapLeft.position = CGPointMake(self.tapCenter.position.x - self.tapCenter.size.width/2 - self.tapLeft.size.width/2, 40);
    self.tapLeft.name = @"left";
    [self addChild:self.tapLeft];
}

+(SKLabelNode*) generateLabelWithPosition:(CGPoint)position andText:(NSString*) text {
    SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@"Papyrus"];
    label.zPosition = 110;
    label.color = [UIColor whiteColor];
    label.position = position;
    label.fontColor = [UIColor whiteColor];
    label.fontSize = 10;
    label.text = text;
    return label;
}


#pragma mark bonuses

-(NSInteger)leftBonuses {
    NSInteger counter = 0;
    for (int i = 0; i < [self.bonuses count]; i++) {
        NSNumber* bonusesOfType = [self.bonuses objectAtIndex:i];
        counter += [bonusesOfType integerValue];
    }
    return counter;
    
}

-(void) generateBonusTypeToEnemy:(Enemy*)enemy {
    NSInteger minType = 1;
    NSInteger maxType = [self.bonuses count]+1;
    NSInteger typeOfBonus = arc4random() % (maxType - minType) + minType;
    NSNumber* numberOfBonuses = [self.bonuses objectAtIndex:typeOfBonus-1];
    NSInteger bonusesInInteger = [numberOfBonuses integerValue];
    
    if (bonusesInInteger > 0) {
        bonusesInInteger--;
        NSNumber* currentNumberOfBonuses = [NSNumber numberWithInteger:bonusesInInteger];
        [self.bonuses replaceObjectAtIndex:typeOfBonus-minType withObject: currentNumberOfBonuses];
        self.currentBonusType = typeOfBonus - 1;
        [self addBonusToEnemy:enemy];
    }
    else if ([self leftBonuses] == 0){
        return;
    }
    else {
        [self generateBonusTypeToEnemy:enemy];
    }
}

-(void)addBonusToEnemy:(Enemy*)enemy{
    NSString* bonusImageName = [self.levelBonuses bonusImageForType:self.currentBonusType];
    Bonus* currentBonus = [[Bonus alloc] initWithImageNamed:bonusImageName andEnemy:enemy];
    [currentBonus changeBonusType:self.currentBonusType + 1];
    [self addChild:currentBonus];
    [currentBonus bonusActionsOnGameScene:self];
}


-(void)countingBonusesAndAddingToEnemy:(Enemy*) enemy {
    static NSInteger bonusCounter = 0;
    static NSInteger bonusesFrequency;
    bonusCounter ++;
    if (self.levelNumber < kLevels/2) {
        bonusesFrequency = 4;
    }
    else {
        bonusesFrequency = 5;
    }
    if (bonusCounter == bonusesFrequency) {
        [self generateBonusTypeToEnemy:enemy];
        
        bonusCounter = 0;
    }
}

#pragma mark magic fog

-(void)magicAction {
    SKAction* moveActionOne = [SKAction moveToY:self.frame.size.height/2 duration:1];
    SKAction* moveActionTwo = [SKAction moveToY:self.frame.size.height duration:1];
    __weak GameScene* weakSelf = self;
    SKAction* changeEnemiesLifes = [SKAction runBlock:^{
        [weakSelf enumerateChildNodesWithName:enemyName usingBlock:^(SKNode* node, BOOL* stop) {
            Enemy* currentEnemy = (Enemy*)node;
            for (int i = 0; i < currentEnemy.health; i++) {
                [currentEnemy changingEnemyLifeBarAndCountingHitEnemiesForScene:weakSelf];
            }
            weakSelf.scoreForLevel += currentEnemy.numberOfCoins;
            weakSelf.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", weakSelf.scoreForLevel];
        }];
    }];
    [self.magicEmitter runAction:[SKAction sequence:@[moveActionOne, moveActionTwo, changeEnemiesLifes, [SKAction removeFromParent]]]];

}
-(void)initializeMagicEmitter {
    self.magicEmitter = [[MagicFog alloc]initWithGameScene:self];
    self.magicEmitter.position = CGPointMake(self.size.width/2, 0);
    [self addChild:self.magicEmitter];
    
}


#pragma mark collision

-(void)weapon:(SKSpriteNode*) weapon didCollideWithTarget:(SKSpriteNode*) target {
    if ([target.name isEqualToString: enemyName] && [weapon.name isEqualToString:weaponName]) {
        [self runAction:[SKAction playSoundFileNamed:@"hit.wav" waitForCompletion:NO]];
        Enemy* currentEnemy = (Enemy*)target;
        [self countingBonusesAndAddingToEnemy:currentEnemy];
        [currentEnemy changingEnemyLifeBarAndCountingHitEnemiesForScene:self];
        self.scoreForLevel += currentEnemy.numberOfCoins;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.scoreForLevel];
        [weapon removeFromParent];
        
    }
    if ([target.name isEqualToString: playerName]) {
        Player* wizard = (Player*)target;
        EnemiesWeapon* enemyWeapon = (EnemiesWeapon*)weapon;
        for (int i = 0; i < enemyWeapon.enemyDamage; i++) {
            [wizard changingPlayerLifeBar];
        }
        [enemyWeapon removeFromParent];
        self.playerHealth.text = [NSString stringWithFormat:@"Health: %ld",self.player.health - self.player.numberOfHits];
        if (self.player.numberOfHits >= self.player.health) {
            SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
            SKScene * gameOverScene = [[GameOverForLevel alloc] initWithSize:self.size hasWon:NO score:self.scoreForLevel andTime:self.levelTime.text ];
            [self.view presentScene:gameOverScene transition: reveal];
        }
    }
    
}


-(void)player:(SKSpriteNode*) player didCollideWithTarget:(SKSpriteNode*) target {
    if ([target.name isEqualToString:bonusName]) {
        Bonus* currentBonus = (Bonus*)target;
        if (currentBonus.typeOfBonus == 1) {
            self.scoreForLevel += kBonusCoins;
            self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.scoreForLevel];
        }
        if (currentBonus.typeOfBonus == 2) {
            [self initializeMagicEmitter];
            [self magicAction];
            
        }
        
        [currentBonus removeFromParent];
    }
}




-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody = contact.bodyA;
    SKPhysicsBody *secondBody = contact.bodyB;
    if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & weaponCategory) != 0 && (secondBody.categoryBitMask & enemyCategory) != 0) {
        [self weapon:(SKSpriteNode*)firstBody.node didCollideWithTarget:(SKSpriteNode*)secondBody.node];
    }
    if ((firstBody.categoryBitMask & enemyWeaponCategory) != 0 && (secondBody.categoryBitMask & playerCategory) != 0) {
        [self weapon:(SKSpriteNode*)firstBody.node didCollideWithTarget:(SKSpriteNode*)secondBody.node];
    }
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & bonusCategory) != 0) {
        [self player:(SKSpriteNode*)firstBody.node didCollideWithTarget:(SKSpriteNode*)secondBody.node];
    }

    
}

#pragma mark touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    SKSpriteNode* touchedNode = (SKSpriteNode*)[self nodeAtPoint:[touch locationInNode:self]];
    
    
    if ([touchedNode.name isEqualToString: self.tapLeft.name]) {
        self.tapLeft.isTouched = YES;
        if ([self.player.name isEqualToString:playerName]) {
            [self.player startWalkingAnimation];
            [self.player movingPlayerAnimationWithSceneSize:self.size andDirection:1];
        }
        
    }
    if ([touchedNode.name isEqualToString: self.tapRight.name] ) {
        self.tapRight.isTouched = YES;
        if ([self.player.name isEqualToString:playerName]) {
            [self.player startWalkingAnimation];
            [self.player movingPlayerAnimationWithSceneSize:self.size andDirection:0];
        }
    }
    
    if ([touchedNode.name isEqualToString: self.tapCenter.name ]) {
        self.tapCenter.isTouched = YES;
        [self shootEnemy];
    }
    if ([touchedNode.name isEqualToString: self.pauseButton.name]) {
        if (self.paused == NO) {
            self.pauseButton.isTouched = YES;
            self.paused = YES;
        }
        else {
            self.paused = NO;
            self.pauseButton.isTouched = NO;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    SKSpriteNode* touchedNode = (SKSpriteNode*)[self nodeAtPoint:[touch locationInNode:self]];
    if (touchedNode.name == self.tapLeft.name) {
        self.tapLeft.isTouched = NO;
    }
    if (touchedNode.name == self.tapRight.name) {
        self.tapRight.isTouched = NO;
        
    }
    if ([self.player.name isEqualToString: playerName]) {
        [self.player startStayingAnimation];
        
    }
}


#pragma mark enemies

-(void) addEnemy {
    NSNumber* health = self.enemies[0][@"health"];
    NSNumber* damage = self.enemies[0][@"damage"];
    Enemy* newOne = [[Enemy alloc]initWithHealth:[health integerValue] andCoins:kEnemyOneCoins andDamage:[damage integerValue] andWithGameScene:self];
    [self addChild: newOne];
}

-(void) addSpecialEnemy {
    NSNumber* health = self.enemies[1][@"health"];
    NSNumber* damage = self.enemies[1][@"damage"];
    SpecialEnemy* specialEnemy = [[SpecialEnemy alloc] initWithHealth:[health integerValue] andCoins:kEnemyTwoCoins andDamage:[damage integerValue] andWithGameScene:self];
    [self addChild:specialEnemy];
}

-(void)sumEnemyDestroyed{
    self.enemiesDestroyed ++;
    self.currendEnemiesForDestroed = [NSString  stringWithFormat:@"Destroyed: %ld/%ld", self.enemiesDestroyed, self.enemiesForDestroyed];
    self.numberOfEnemiesForDestroed.text = self.currendEnemiesForDestroed;
        if (self.enemiesDestroyed == self.enemiesForDestroyed) {
            SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
            SKScene * gameOverScene = [[GameOverForLevel alloc] initWithSize:self.size hasWon:YES score:self.scoreForLevel andTime:self.levelTime.text ];
            [self.view presentScene:gameOverScene transition: reveal];
        }
}


-(void)enemyShootingPlayer:(Enemy*) enemy  {
    ;
    if ([enemy isMemberOfClass:[SpecialEnemy class]]) {
        SpecialEnemy* specialEnemy = (SpecialEnemy*)enemy;
        SpecialEnemyWeapon* weapon = [[SpecialEnemyWeapon alloc]initWithEnemy:specialEnemy];
        [weapon weaponActionsOnTheGameScene:self];
        [self addChild:weapon];
    }
    else {
       EnemiesWeapon* weapon = [[EnemiesWeapon alloc]initWithEnemy:enemy];
        [weapon weaponActionsOnTheGameScene:self];
        [self addChild:weapon];
    }
    
    
}


-(void)updateEnemy {
   
    NSMutableArray* enemies = [NSMutableArray array];
    [self enumerateChildNodesWithName:enemyName usingBlock:^(SKNode* node, BOOL* stop){
        [enemies addObject:node];
    }];
    if ([enemies count] < self.numberOfEnemiesOnScreen ) {
        NSInteger minKind = 1;
        NSInteger maxKind = 3;
        NSInteger kindOfEnemy = arc4random() % (maxKind - minKind) + minKind;
        
        if ((kindOfEnemy == 1 ) && (0 < self.numberOfEnemiesTypeOneForLevel)) {
            self.numberOfEnemiesTypeOneForLevel--;
            [self addEnemy];
        }
        if ((kindOfEnemy == 2 ) && (0 < self.numberOfEnemiesTypeTwoForLevel)) {
            self.numberOfEnemiesTypeTwoForLevel--;
            [self addSpecialEnemy];
        }

        if ((self.numberOfEnemiesTypeOneForLevel == 0) && (self.numberOfEnemiesTypeTwoForLevel == 0)) {
            
            SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
            SKScene * gameOverScene = [[GameOverForLevel alloc] initWithSize:self.size hasWon:NO score:self.scoreForLevel andTime:self.levelTime.text ];
            [self.view presentScene:gameOverScene transition: reveal];

        }
    }
}

#pragma mark update

-(void)update:(CFTimeInterval)currentTime {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifications:) name:@"pauseGame" object:nil];
    if (self.paused == YES) {
        return;
    }
    [self updateEnemy];    
    static NSInteger enemiesShootTime;
    enemiesShootTime++;
    if (enemiesShootTime == 30) {
        enemiesShootTime = 0;
        __weak GameScene* weakSelf = self;
        [self enumerateChildNodesWithName:enemyName usingBlock:^(SKNode* node, BOOL* stop){
            [weakSelf enemyShootingPlayer:(Enemy*)node];
        }];
    }    
    self.currentTime = [self.levelStartDate timeIntervalSinceNow];
    
}

@end