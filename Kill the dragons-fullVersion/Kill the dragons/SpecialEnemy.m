

#import "SpecialEnemy.h"
#import "Common.h"

@interface SpecialEnemy ()
@property (nonatomic, strong) NSDictionary* atlases;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger damage;

@end

static const NSInteger kProgressBackgroundHeight = -40;

@implementation SpecialEnemy

- (instancetype)initWithHealth:(NSInteger)health andCoins:(NSInteger)coins andDamage:(NSInteger)damage andWithGameScene:(GameScene *)scene
{
    self = [super initWithHealth:health andCoins:coins andDamage:damage andWithGameScene:scene];
    if (self) {
        self.type = 2;
        self.damage = damage;
    }
    return self;
}
-(CGPoint)progrssBackgroundPosition {
    CGPoint backgroundPosition = CGPointMake(0, kProgressBackgroundHeight);
    return backgroundPosition;
}


- (NSString*)setupAtlasName:(NSString *)atlasKind {
    NSString* atlasName = [self.atlases[atlasKind] objectAtIndex:0];
    return atlasName;
}

-(NSDictionary*)atlases {
    if (_atlases == nil) {
        NSMutableArray* bigAtlases = [NSMutableArray array];
        NSMutableArray* smallAtlases = [NSMutableArray array];
        [bigAtlases addObject:@"blackDragons"];
        [smallAtlases addObject:@"blackSmallDragons"];
        self.atlases = @{@"bigAtlases":bigAtlases, @"smallAtlases":smallAtlases};
    }
    return _atlases;
}

@end
