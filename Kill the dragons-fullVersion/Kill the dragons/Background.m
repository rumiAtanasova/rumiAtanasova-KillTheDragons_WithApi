
#import "Background.h"

@implementation Background
+ (instancetype)generateBackgroundWithImage:(NSString*)image {
    Background* background = [[Background alloc]initWithImageNamed:image];
    background.anchorPoint = CGPointMake(0, 0);
    background.name = @"background";
    background.zPosition = -1;
    background.position = CGPointMake(0, 0);
    return background;
}

@end
