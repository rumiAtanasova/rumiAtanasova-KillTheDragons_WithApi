
#import <Foundation/Foundation.h>

@interface LevelsBonuses : NSObject
-(NSMutableArray*)bonusesForLevel:(NSInteger)level;
-(NSString*)bonusImageForType:(NSInteger)type;

@end
