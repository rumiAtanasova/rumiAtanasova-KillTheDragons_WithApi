

#import <Foundation/Foundation.h>

@interface Connection : NSObject

+(instancetype) sharedInstance;

-(void) sendingPostReqestFor:(NSString*)path withDictionary:(NSDictionary*)dictionary withCompletionHandler:(void (^) (NSDictionary* jsonObject))block;
-(void) sendingGetReqestForPath:(NSString*)path withParameters:(NSString* )parameters withCompletionHandler:(void (^) (NSDictionary* jsonObject))block;
-(void) sendingGetReqestForLeaderBoardWithParameters:(NSString* )parameters withCompletionHandler:(void (^) (NSArray* jsonObject)) block;
-(NSInteger) checkStausCode;

@end
