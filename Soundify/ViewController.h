//
//  ViewController.h
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListSongViewController.h"
#import "GenreCell.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblGenre;

@end

