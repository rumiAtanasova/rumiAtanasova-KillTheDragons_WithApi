

#import "ProgressBar.h"
#import "Common.h"

@implementation ProgressBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = progressBarName;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.dynamic = NO;
        self.maskNode = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(50, 4)];
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithImageNamed:@"progress"];

        [self addChild:sprite];
        SKSpriteNode* newMask = (SKSpriteNode*)self.maskNode;
        newMask.position = CGPointMake(0, 0);
        
    }
    return self;
}

-(void) setProgress:(CGFloat)progress {
    SKSpriteNode* newMask = (SKSpriteNode*)self.maskNode;
    newMask.size = CGSizeMake(progress, 4);
    newMask.position = CGPointMake(-25, 0);
}

@end
