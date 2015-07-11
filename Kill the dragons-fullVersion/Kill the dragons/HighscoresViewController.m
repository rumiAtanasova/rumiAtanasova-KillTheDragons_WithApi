//
//  HighscoresViewController.m
//  Kill the dragons
//
//  Created by User-03 on 6/26/15.
//  Copyright (c) 2015 Rumyana Atanasova. All rights reserved.
//

#import "HighscoresViewController.h"
#import "HighscoreTableViewCell.h"
#import "Connection.h"
#import "UserInfo.h"


@interface HighscoresViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray* leaderboard;

@end

@implementation HighscoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"HighscoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"highscoreCell"];
    
    __weak HighscoresViewController* weakSelf = self;
    
    [[Connection sharedInstance]sendingGetReqestForLeaderBoardWithParameters:[NSString stringWithFormat:@"?userId=%@", [UserInfo sharedInstance].userId] withCompletionHandler:^(NSArray *jsonObject) {
        weakSelf.leaderboard = [NSArray arrayWithArray:jsonObject];
        [weakSelf updateTableView];

    }];
}


-(void) updateTableView {
    [self.tableView reloadData];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.leaderboard count];
    
}

-(HighscoreTableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"highscoreCell";
    
    
    HighscoreTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.idLabel.text = [self.leaderboard[indexPath.row][@"position"]stringValue];
    cell.userLabel.text = self.leaderboard[indexPath.row][@"username"];
    cell.scoreLabel.text = [self.leaderboard[indexPath.row][@"score"]stringValue];
    
    return cell;
}
@end
