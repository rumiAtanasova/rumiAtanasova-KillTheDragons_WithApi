

#import "Connection.h"


@interface Connection ()
@property (nonatomic, strong) NSDictionary* jsonData;
@property (nonatomic) NSInteger statusCode;
@end


@implementation Connection

+(instancetype) sharedInstance {
    static Connection* instance = nil;
    static dispatch_once_t token;
    if (instance == nil) {
        dispatch_once (&token, ^{
            instance = [[super alloc]init];
        });
    }
    return instance;
}

+(instancetype)alloc {
    return [Connection sharedInstance];
}

-(NSInteger) checkStausCode {
    return self.statusCode;
}

-(void) sendingPostReqestFor:(NSString*)path withDictionary:(NSDictionary* )dictionary withCompletionHandler:(void (^) (NSDictionary* jsonObject))block{
    NSString* serverURl = @"http://192.168.7.45:8080/";
    NSString* fullServerURL = [serverURl stringByAppendingString:path];
    NSURL* url = [NSURL URLWithString:fullServerURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSError* errorOne = nil;
    NSData* myData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&errorOne];
    if (!errorOne) {
        NSURLSessionUploadTask* uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:myData completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                       NSDictionary* jsonDict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                                       
                                                                       self.statusCode = [(NSHTTPURLResponse *) response statusCode];
                                                                       
                                                                       if ([(NSHTTPURLResponse *) response statusCode] == 200) {
                                                                            NSString *response = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSASCIIStringEncoding];
                                                                                NSLog(@"%@", response);
                                                                        }
                                                                       else {
                                                                           NSString *response = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSASCIIStringEncoding];
                                                                           NSLog(@"%@", response);
                                                                       }
                                                                       
                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                           block (jsonDict);
                                                                       });
                                                                   }];
        [uploadTask resume];
    }    
}

-(void) sendingGetReqestForPath:(NSString*)path withParameters:(NSString* )parameters withCompletionHandler:(void (^) (NSDictionary* jsonObject))block {
    NSString* serverURl = @"http://192.168.7.45:8080/";
   NSString* fullServerURL = [[serverURl stringByAppendingString:path] stringByAppendingString:parameters];
   // NSString* fullServerURL = [[serverURl stringByAppendingString:path] stringByAppendingString:[NSString stringWithFormat:@"?userId=%@",parameters]];
    NSURL* url = [NSURL URLWithString:fullServerURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask* downloadData = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^ (NSData *data,NSURLResponse *response,NSError *error){
        NSDictionary* jsonDict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block (jsonDict);
        });

    }];
    [downloadData resume];
    

}

-(void) sendingGetReqestForLeaderBoardWithParameters:(NSString* )parameters withCompletionHandler:(void (^) (NSArray* jsonObject)) block{
    NSString* serverURl = @"http://192.168.7.45:8080/leaderBoard";
    NSString* fullServerURL = [serverURl stringByAppendingString:parameters];    
    NSURL* url = [NSURL URLWithString:fullServerURL];
    NSURLSessionDataTask* downloadData = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^ (NSData *data,NSURLResponse *response,NSError *error){
        NSArray* jsonArray  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block (jsonArray);
        });
    }];
    [downloadData resume];
}






@end
