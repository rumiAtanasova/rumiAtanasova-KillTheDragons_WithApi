

#import "Controllers.h"

@implementation Controllers
- (instancetype)initWithImageNamed:(NSString *)name
{
    self = [super initWithImageNamed:name];
    if (self) {
        self.isTouched = NO;
        self.zPosition = 20;
        self.alpha = 0.5;
    }
    return self;
}

@end
