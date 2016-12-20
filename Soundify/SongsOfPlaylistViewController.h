//
//  SongsOfPlaylistViewController.h
//  Soundify
//
//  Created by Quang Dai on 9/29/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "Common.h"
#import "ListSongCell.h"
#import "TracksOfPlaylist.h"
#import "TracksOfGenre.h"
#import "HistoryDB.h"
#import <UIImageView+WebCache.h>
#import "PlayingViewController.h"

@interface SongsOfPlaylistViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchInSongOfPlaylist;
@property (weak, nonatomic) IBOutlet UITableView *tblSongOfPlaylist;

@property RLMResults *resultDb;
@property RLMResults *searchResult;
@property BOOL connection;

@property NSString *playlistName;
@property NSString *playlistLocation;
@property UIBarButtonItem *deleteButton;
@property UIBarButtonItem *rightButton;

@property NSMutableArray *playingArray;
@property NSMutableArray *playingResult;
@property NSMutableArray *playingSearchArray;
@property NSMutableArray *playingSearchResult;

@property PlayingViewController *playingVC;
@end
