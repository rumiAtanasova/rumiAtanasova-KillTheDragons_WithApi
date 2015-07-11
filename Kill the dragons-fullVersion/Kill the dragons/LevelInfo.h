

#import <Foundation/Foundation.h>


@interface LevelInfo : NSObject
@property (nonatomic, readonly) NSInteger levelNumber;
@property (nonatomic, readonly) NSInteger playerHealth;

+(instancetype) sharedInstance;
-(NSString*) backgroundForChoosenLevel:(NSInteger)level;
-(void) endForLevelWithScore:(NSInteger) score;
-(NSArray*)giveEnemmiesTtypes;
@end
