
#import <SpriteKit/SpriteKit.h>
#import "LevelInfo.h"

@interface MapScene : SKScene
@property (nonatomic, readonly) NSInteger choosenLevel;
@property (nonatomic, strong) LevelInfo* level;
+(instancetype) sharedInstance;
-(NSString*)generateGetParameters;
-(void)goToLevel:(NSInteger)level;
-(void)changeScene;
-(void)updateLevelInfoWithLevel:(NSInteger)level;
@end
