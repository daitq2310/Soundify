//
//  ListSongViewController.h
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "PlayingViewController.h"
#import "HistoryViewController.h"
#import "AddToPlaylistViewController.h"
#import "ListSongCell.h"
#import "Common.h"
#import "TracksOfGenre.h"
#import <AFNetworking.h>
#import <UIActivityIndicatorView+AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <SVPullToRefresh.h>
#import "GenreDB.h"
#import "HistoryDB.h"
#import "Playing.h"


@interface ListSongViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblListSong;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property NSMutableArray *playingArray;
@property NSMutableArray *playingResult;

@property NSURLSessionConfiguration *sessionConfiguration;
@property AFHTTPSessionManager *sessionManager;

@property BOOL connection;

@property UIActivityIndicatorView *waitingIndicator;
@property RLMResults *resultTrackGenreDb;

@property NSInteger offset;
@property NSString *genreName;
@property NSString *genreCode;

@property PlayingViewController *playingVC;
@end
