#import "GameViewController.h"
#import "GameScene.h"
#import "MapScene.h"
#import "GameOverForLevel.h"
#import "MenuViewController.h"



@implementation GameViewController



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(facebookConnection:) name:@"facebook" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitButton:) name:@"exit" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(errorAlertView:) name:@"error" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.ignoresSiblingOrder = YES;
    //    skView.showsPhysics = YES;
    
    MapScene* scene = [[MapScene alloc]initWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(void)facebookConnection:(NSNotification*)notification {
    NSDictionary* data = [notification userInfo];
    NSString* text = (NSString*)[data objectForKey:@"text"];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])  {
        SLComposeViewController *fbPost = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbPost setInitialText:data[@"text"]];
        [fbPost addImage:[UIImage imageNamed:@"shareImage.png"]];
        [self presentViewController:fbPost animated:YES completion:nil];
        [fbPost setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }
    
}

-(void)exitButton:(NSNotification*)notification {
    NSDictionary* data = [notification userInfo];
    NSString* text = (NSString*)[data objectForKey:@"text"];
    MenuViewController* menuViewController = [[MenuViewController alloc]init];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)errorAlertView:(NSNotification*)notification {   
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Something went wrong!" message:@"No connection!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
