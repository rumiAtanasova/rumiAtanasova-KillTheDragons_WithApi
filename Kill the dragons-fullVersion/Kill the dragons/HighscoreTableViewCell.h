//
//  HighscoreTableViewCell.h
//  Kill the dragons
//
//  Created by User-03 on 6/27/15.
//  Copyright (c) 2015 Rumyana Atanasova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighscoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


@end
