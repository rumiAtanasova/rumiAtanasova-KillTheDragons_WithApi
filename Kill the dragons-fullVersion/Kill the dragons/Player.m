
#import "Player.h"
#import "GameScene.h"
#import "MapScene.h"
#import "Common.h"
#import "ProgressBar.h"


@interface Player ()
@property (strong, nonatomic) NSMutableArray* walkingFrame;
@property (strong, nonatomic) NSMutableArray* stayingFrame;
@property (strong, nonatomic) NSMutableArray* shootingFrame;
@property (strong, nonatomic) NSMutableArray* shieldOnFrame;
@property (nonatomic, strong) NSMutableArray* shieldOffFrame;
@property (nonatomic, strong) NSMutableArray* shieldedFrame;
@property (strong, nonatomic) ProgressBar* progress;
@property (nonatomic, readwrite) NSInteger numberOfHits;
@property (nonatomic, readwrite) NSInteger health;
@property (nonatomic, strong) SKSpriteNode* shield;
@property (nonatomic) BOOL isShielded;


@end


static const CGFloat kMaxPlayerHealthProgress = 100;

@implementation Player
- (instancetype)initWithImageNamed:(NSString *)name andScene:(GameScene*)scene
{
    self = [super initWithImageNamed:name];
    if (self) {
        self.zPosition = 10;
        self.position = CGPointMake(scene.size.width/2, self.size.height/2 + scene.size.height * kPlayerPosition);
        self.name = playerName;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = playerCategory;
        self.physicsBody.contactTestBitMask = enemyWeaponCategory;
        self.physicsBody.collisionBitMask = enemyWeaponCategory;
        self.walkingFrame = [NSMutableArray array];
        self.stayingFrame = [NSMutableArray array];        
        [self setupProgressBar];
        [self setupAnimationsWithAtlasName:@"stay" andFrame:self.stayingFrame];
        [self startAnimationWithKey: stayAnimationKey andFrame:self.stayingFrame andTimePerFrame:stayingTimePerFrame];
        
        
    }
    return self;
    
}
-(void)initHealth:(NSInteger)health {
    self.health = health;
}


#pragma mark animations and moves
- (void) setupAnimationsWithAtlasName:(NSString*)atlasName andFrame:(NSMutableArray*) frame {
    SKTextureAtlas* atlas = [SKTextureAtlas atlasNamed:atlasName];
    NSMutableArray* imageNames = [NSMutableArray array];
    imageNames = (NSMutableArray*)[atlas textureNames];
    imageNames = (NSMutableArray*)[imageNames sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    for (NSString* fileName in imageNames) {
        SKTexture* tempTexture = [atlas textureNamed:fileName];
        if (tempTexture) {
            [frame addObject:tempTexture];
        }
    }
}


- (void) startAnimationWithKey:(NSString*) key andFrame:(NSMutableArray*)frame andTimePerFrame:(CGFloat)time {
    if (![self actionForKey:key]) {
        [self runAction: [SKAction repeatActionForever:[SKAction animateWithTextures:frame timePerFrame:time resize:YES restore:NO]] withKey:key];
    }
}

- (void) stopAnimationWithKey:(NSString*) key {
    [self removeActionForKey:key];
}

- (void) startWalkingAnimation {
    if ([self actionForKey:stayAnimationKey]) {
        [self stopAnimationWithKey:stayAnimationKey];
    }
    [self setupAnimationsWithAtlasName:@"walking" andFrame:self.walkingFrame];
    [self startAnimationWithKey:walkingAnimationKey andFrame:self.walkingFrame andTimePerFrame:walkingTimePerFrame];
    
}
-(void) startStayingAnimation {
    if ([self actionForKey:moveActionKey] && [self actionForKey:walkingAnimationKey]) {
        [self stopAnimationWithKey:moveActionKey];
        [self stopAnimationWithKey:walkingAnimationKey];
    }
    [self startAnimationWithKey:stayAnimationKey andFrame:self.stayingFrame andTimePerFrame: stayingTimePerFrame];
}



- (void) movingPlayerAnimationWithSceneSize:(CGSize)size andDirection:(NSInteger) direction {
    SKAction* moveAction;
    if (direction == 0) {
        moveAction = [SKAction repeatActionForever:[SKAction moveTo:CGPointMake(size.width - self.size.width/2, self.position.y) duration:5]];
    }
    else {
        moveAction = [SKAction repeatActionForever:[SKAction moveTo:CGPointMake(self.size.width/3, self.position.y) duration:5]];
    }
    [self runAction:moveAction withKey:moveActionKey];
    
}


#pragma mark life bar

- (void)changingPlayerLifeBar {
    const CGFloat changingLifeWith = kMaxPlayerHealthProgress / self.health;
    self.numberOfHits++;
    CGFloat changingLifeBar = kMaxPlayerHealthProgress - changingLifeWith * self.numberOfHits;
    SKSpriteNode* bac = (SKSpriteNode*) [self childNodeWithName:progressBackgroundName];
    self.progress = (ProgressBar*)[bac childNodeWithName:progressBarName];
    [self.progress setProgress:changingLifeBar];
    if (changingLifeBar <= 0) {
        SKAction* waitAction = [SKAction waitForDuration:0.3];
        [self runAction:[SKAction sequence:@[waitAction, [SKAction removeFromParent]]]];
        
    }
}

-(void)setupProgressBar {
    SKSpriteNode* progressBackground = [SKSpriteNode spriteNodeWithImageNamed:@"progressBackground"];
    progressBackground.zPosition = 1;
    progressBackground.name = progressBackgroundName;
    self.progress = [[ProgressBar alloc]init];
    self.progress.zPosition = 2;
    progressBackground.position = CGPointMake(0, -self.size.height/2);
    [progressBackground addChild:self.progress];
    [self addChild:progressBackground];
}



@end
