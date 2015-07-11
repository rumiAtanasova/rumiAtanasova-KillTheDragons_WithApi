
#import "LevelInfo.h"
#import "UserInfo.h"
#import "Connection.h"
#import "MapScene.h"

@interface LevelInfo ()

@property (nonatomic, readwrite) NSInteger levelNumber;
@property (nonatomic, strong) NSArray* enemiesTypes;
@property (nonatomic, strong) NSMutableArray* backgroundsForLevels;
@property (nonatomic, readwrite) NSInteger playerHealth;
@property (nonatomic)  NSDictionary* jsonData;


@end

@implementation LevelInfo

+(instancetype) sharedInstance {
    static LevelInfo* instance = nil;
    static dispatch_once_t token;
    if (instance == nil) {
        dispatch_once (&token, ^{
            instance = [[super alloc]init];
        });
    }
    return instance;
}

+(instancetype)alloc {
    return [LevelInfo sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak LevelInfo *wealSelf = self;
        self.levelNumber = [MapScene sharedInstance].choosenLevel ;
        [[Connection sharedInstance] sendingGetReqestForPath:@"levelManager" withParameters:[[MapScene sharedInstance] generateGetParameters] withCompletionHandler:^(NSDictionary* jsonObjest){
            wealSelf.enemiesTypes = jsonObjest[@"enemies"];
            NSNumber* health = jsonObjest[@"userHealth"];
            wealSelf.playerHealth = [health integerValue];
        }];     
        
    }
    return self;
}

-(NSMutableArray*)backgroundsForLevels {
    if (_backgroundsForLevels == nil) {
        self.backgroundsForLevels = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            [self.backgroundsForLevels addObject:[NSString stringWithFormat:@"background%d.jpg", i+1]];
        }
    }
    return _backgroundsForLevels;
}

-(NSString*) backgroundForChoosenLevel:(NSInteger)level {
    return [self.backgroundsForLevels objectAtIndex:level-1];
}

-(NSArray*)giveEnemmiesTtypes {    
    return self.enemiesTypes;
    
}

-(void) endForLevelWithScore:(NSInteger) score  {
    //when level finish
    NSDictionary* json = @{@"userId" : [UserInfo sharedInstance].userId,
                           @"level" :  [NSString stringWithFormat:@"%ld", self.levelNumber],
                           @"score" :  [NSString stringWithFormat:@"%ld", score] };
    
    [[Connection sharedInstance] sendingPostReqestFor:@"levelManager" withDictionary:json withCompletionHandler:^ (NSDictionary* jsonDict) {
        NSLog(@"%@", json);
    }];
}



@end
