
#import "MagicFog.h"
#import "GameScene.h"
#import "Common.h"

@implementation MagicFog

- (instancetype)initWithGameScene:(GameScene*)scene
{
    self = [super init];
    if (self) {
        self = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"magic" ofType:@"sks"]];
        self.name = magicFogName;
        self.hidden = NO;
    }
    return self;
}



@end
