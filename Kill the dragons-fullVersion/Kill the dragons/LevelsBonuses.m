
#import "LevelsBonuses.h"

@interface LevelsBonuses ()
@property (nonatomic, strong) NSMutableArray* bonuses;
@property (nonatomic, strong) NSMutableArray* bonusesImages;
@end

@implementation LevelsBonuses


-(NSMutableArray*)bonusesForLevel:(NSInteger)level {
    return [self.bonuses objectAtIndex:level];
}
-(NSString*)bonusImageForType:(NSInteger)type {
    return [self.bonusesImages objectAtIndex:type];
}

-(NSMutableArray*)bonusesImages {
    if (_bonusesImages == nil) {
        self.bonusesImages = [NSMutableArray array];
        [self.bonusesImages addObject:@"coinsBonus"];
        [self.bonusesImages addObject:@"magicWeaponBonus"];
        
    }
    return _bonusesImages;
}

-(NSMutableArray*)bonuses {
    if (_bonuses == nil) {
        self.bonuses = [NSMutableArray array];
        [self.bonuses addObject:[NSMutableArray arrayWithArray:@[@2]]];
        [self.bonuses addObject:[NSMutableArray arrayWithArray:@[@2, @2]]];
        [self.bonuses addObject:[NSMutableArray arrayWithArray:@[@4, @3]]];
        [self.bonuses addObject:[NSMutableArray arrayWithArray:@[@4, @3]]];
        [self.bonuses addObject:[NSMutableArray arrayWithArray:@[@4, @3]]];
        [self.bonuses addObject:[NSMutableArray arrayWithArray:@[@4, @3]]];
    }
    return _bonuses;
}




@end
