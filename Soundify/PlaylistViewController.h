//
//  PlaylistViewController.h
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "SongsOfPlaylistViewController.h"
#import "PlaylistDB.h"
#import "GenreDB.h"
#import "PlaylistCell.h"
#import "PlayingViewController.h"
#import <UIImageView+WebCache.h>

@interface PlaylistViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchInPlaylistScreen;
@property (weak, nonatomic) IBOutlet UITableView *tblPlaylist;


@property RLMResults *resultDb;
@property RLMResults *searchResult;
@property BOOL connection;

@property PlayingViewController *playingVC;

@end
