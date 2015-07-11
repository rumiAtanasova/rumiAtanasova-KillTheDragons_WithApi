

#import "UserInfo.h"
#import "Connection.h"


@interface UserInfo ()

@property (nonatomic, strong, readwrite) NSString* userId;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* userPasswpord;
@property (nonatomic, strong) NSString* userEmail;
@property (nonatomic) BOOL allowNotification;
@property (nonatomic, strong) NSString* getRequestParameter;
@end


@implementation UserInfo

+(instancetype) sharedInstance {
    static UserInfo* instance = nil;
    static dispatch_once_t token;
    if (instance == nil) {
        dispatch_once (&token, ^{
            instance = [[super alloc]init];
        });
    }
    return instance;
}

+(instancetype)alloc {
    return [UserInfo sharedInstance];
}



- (instancetype)initWithId: (NSString*) userId
{
    self = [super init];
    if (self) {
        self.userId = userId;
    }
    return self;
}


-(void) changeProfilPassword:(NSString*)currentPassword withNewPassword: (NSString*)newPassword withEmail: (NSString*) email andNotifications:(BOOL)notifications {
    if (newPassword != nil && [newPassword length] >= 6 && newPassword!=currentPassword) {
        self.userPasswpord = newPassword;
    }
    else {
        self.userPasswpord = currentPassword;
    }
    self.userEmail = email;
    self.allowNotification = notifications;
    NSNumber* boolAnswer;
    if (self.allowNotification == YES) {
        boolAnswer = @YES;
    }
    else {
        boolAnswer = @NO;
    }
    NSDictionary* postDict = @{@"userId" : self.userId,
                               @"password" : self.userPasswpord,
                               @"email" : self.userEmail,
                               @"allowNotification" : boolAnswer};
    [[Connection sharedInstance] sendingPostReqestFor:@"userInfoManager" withDictionary:postDict withCompletionHandler:^(NSDictionary* jsonObject){
        
    }];
    
}




@end

