

#import "GameOverForLevel.h"
#import "MapScene.h"
#import "Background.h"
#import "LevelInfo.h"
#import "GameScene.h"
#import "GameViewController.h"

static const NSInteger kLabelFontSize = 35;
static const NSInteger kMessageLabelYPosition = 60;
static const NSInteger kLevelLabelYPosition = 120;
static const NSInteger kLooseGameScore = 0;
static const NSInteger kGameLevels = 6;

@interface GameOverForLevel ()
@property (nonatomic, strong) SKSpriteNode* mapButton;
@property (nonatomic, strong) SKSpriteNode* levelButton;
@property (nonatomic, strong) SKSpriteNode* facebookButton;
@property (nonatomic) NSInteger finishLevel;
@property (nonatomic) NSInteger levelScore;
@property (nonatomic) BOOL publish;


@end

@implementation GameOverForLevel

- (instancetype)initWithSize:(CGSize)size hasWon:(BOOL)hasWon score:(NSInteger)score andTime:(NSString*)time
{
    self = [super initWithSize:size];
    if (self) {
        self.finishLevel = [MapScene sharedInstance].choosenLevel ;
        
        Background* background = [Background generateBackgroundWithImage:@"gameOver.jpg"];
        [self addChild:background];
        SKSpriteNode* levelOverImage = [[SKSpriteNode alloc] initWithImageNamed:@"levelOver"];
        levelOverImage.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild: levelOverImage];
        [self addScoreLabelTimeLabelAndLevelLabelWithResult:hasWon andParent:levelOverImage score:score andTime:time];
        [self messageLabelWithResult:hasWon andParent:levelOverImage];
        [self addingLevelButtonWithParent:levelOverImage andResult:hasWon];
        self.mapButton = [GameOverForLevel addButtonWithParent:levelOverImage andPosition:CGPointMake(-160, -120) andImageName:@"mapButton1"];
        self.mapButton.name = @"mapButton";
        self.facebookButton = [GameOverForLevel addButtonWithParent:levelOverImage andPosition:CGPointMake(0, -120) andImageName:@"Facebook"];
        self.facebookButton.name = @"facebook";
        self.levelScore = score;
        if (!hasWon) {
            self.levelScore = kLabelFontSize;
        }
        [[MapScene sharedInstance].level endForLevelWithScore:self.levelScore];
        if (self.levelScore > kLabelFontSize) {
            [[MapScene sharedInstance] updateLevelInfoWithLevel:self.finishLevel+1];
        }
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    SKSpriteNode* touchedNode = (SKSpriteNode*)[self nodeAtPoint:[touch locationInNode:self]];
    if ([touchedNode.name isEqualToString:self.facebookButton.name]) {
        NSString* message = [NSString stringWithFormat:@"Just scored %ld points on Kill The Dragons!", self.levelScore];
        NSDictionary* userInfo = [NSDictionary dictionaryWithObject:message forKey:@"text"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"facebook" object:self userInfo:userInfo];      
        
    }
    if ([touchedNode.name isEqualToString: self.mapButton.name]) {
        SKTransition *reveal = [SKTransition fadeWithDuration:1];
        [self.view presentScene:[MapScene sharedInstance] transition: reveal];
    }
    if ([touchedNode.name isEqualToString: self.levelButton.name] && [self.levelButton.name isEqualToString:@"nextButton"]) {
        [[MapScene sharedInstance] goToLevel:self.finishLevel + 1];
        [self.view presentScene:[MapScene sharedInstance] transition: nil];
        
    }
    if ([touchedNode.name isEqualToString: self.levelButton.name] && [self.levelButton.name isEqualToString:@"againButton"]) {
        [self.view presentScene:[MapScene sharedInstance] transition: nil];
        [[MapScene sharedInstance] goToLevel:self.finishLevel];
    }
}

#pragma mark adding scene components

-(void)addingLevelButtonWithParent:(SKSpriteNode*)parent andResult:(BOOL)result{
    NSString* levelButtonImageName;
    NSString* levelButtonName;
    if (result && self.finishLevel < kGameLevels) {
        levelButtonImageName = @"nextButton";
        levelButtonName =@"nextButton";
    }
    else {
        levelButtonImageName = @"againButton";
        levelButtonName = @"againButton";
    }   
    
    self.levelButton = [GameOverForLevel addButtonWithParent:parent andPosition:CGPointMake(160, -120) andImageName:levelButtonImageName];
    self.levelButton.name = levelButtonName;
}

+(SKSpriteNode*)addButtonWithParent:(SKSpriteNode*)parent andPosition:(CGPoint)position andImageName:(NSString*)name {
    SKSpriteNode* button = [SKSpriteNode spriteNodeWithImageNamed:name];
    button.position = position;
    [parent addChild:button];
    return button;
}

-(void)messageLabelWithResult:(BOOL)result andParent:(SKSpriteNode*)parent {
    NSString* message;
    static NSInteger fontSize = 15;
    if (result == YES) {
        if (self.finishLevel != kGameLevels) {
            message = @"You unlocked next level";
            
        }
        else {
            message = @"Congratulations, you Won!!!";
            fontSize = 25;
        }
    }
    else {
        message = @"Sorry, try again";
    }
    SKLabelNode* messageLabel = [GameOverForLevel generateLabelWithPosition:CGPointMake(0,  kMessageLabelYPosition) andText:message];
    messageLabel.fontSize = fontSize;
    [parent addChild:messageLabel];
}

-(void)addScoreLabelTimeLabelAndLevelLabelWithResult:(BOOL)result andParent:(SKSpriteNode*)parent score:(NSInteger)score andTime:(NSString*)time {
    if (result == NO) {
        score = kLooseGameScore;
        time = @"Time: 0:00:00";
    }
    SKLabelNode* scoreLabel = [GameOverForLevel generateLabelWithPosition:CGPointMake(0, 0) andText:[NSString stringWithFormat:@"Score: %ld", score]];
    [parent addChild:scoreLabel];
    
    SKLabelNode* timeLabel = [GameOverForLevel generateLabelWithPosition:CGPointMake(scoreLabel.position.x, scoreLabel.position.y - scoreLabel.frame.size.height*2) andText:time];
    [parent addChild:timeLabel];
    
    
    NSString* level = [NSString stringWithFormat:@"Level %ld", self.finishLevel];
    SKLabelNode* levelLabel = [GameOverForLevel generateLabelWithPosition:CGPointMake(0, kLevelLabelYPosition)  andText:level];
    levelLabel.fontSize = kLabelFontSize;
    [parent addChild:levelLabel];
}

+(SKLabelNode*) generateLabelWithPosition:(CGPoint)position andText:(NSString*) text {
    SKLabelNode* label = [SKLabelNode labelNodeWithFontNamed:@"SnellRoundhand-Bold"];
    label.position = position;
    label.fontColor = [SKColor blackColor];
    label.fontSize = kLabelFontSize;
    label.text = text;
    return label;
}



@end
