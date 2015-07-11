

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong, readonly) NSString* userId;
+(instancetype) sharedInstance;
-(void) changeProfilPassword:(NSString*)currentPassword withNewPassword: (NSString*)newPassword withEmail: (NSString*) email andNotifications:(BOOL)notifications;
- (instancetype)initWithId: (NSString*) userId;

@end
