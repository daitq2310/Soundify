//
//  HistoryViewController.h
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "Common.h"
#import "AddToPlaylistViewController.h"
#import "TracksOfGenre.h"
#import "HistoryDB.h"
#import "ListSongCell.h"
#import <UIImageView+WebCache.h>
#import "PlayingViewController.h"


@interface HistoryViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchInHistoryScreen;
@property (weak, nonatomic) IBOutlet UITableView *tblHistory;

@property RLMResults *resultHistoryDb;
@property RLMResults *searchResult;
@property BOOL connection;

@property NSMutableArray *playingArray;
@property NSMutableArray *playingResult;
@property NSMutableArray *playingSearchArray;
@property NSMutableArray *playingSearchResult;

@property UIBarButtonItem *deleteButton;
@property UIBarButtonItem *rightButton;

@end
