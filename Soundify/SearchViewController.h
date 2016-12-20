//
//  SearchViewController.h
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "TracksOfGenre.h"
#import "SearchStorage.h"
#import "Suggestion.h"
#import "Common.h"
#import "SuggestCell.h"
#import "SearchCell.h"
#import <UIImageView+WebCache.h>
#import <Reachability.h>
#import <AFNetworking.h>
#import <SVPullToRefresh.h>
#import "HistoryDB.h"
#import "PlayingViewController.h"
#import "Playing.h"


@interface SearchViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchInSearchScreen;
@property (weak, nonatomic) IBOutlet UITableView *tblResultTrack;
@property (weak, nonatomic) IBOutlet UITableView *tblSuggestResultTrack;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property NSURLSessionConfiguration *sessionConfiguration;
@property AFHTTPSessionManager *sessionManager;

@property RLMResults *resultSearching;

@property NSInteger offset;

@property UIActivityIndicatorView  *waitingIndicator;
@property BOOL connection;
@property BOOL loading;

@property PlayingViewController *playingVC;

@property NSMutableArray *suggestArray;
@property NSMutableArray *playingArray;
@property NSMutableArray *playingResult;

@end
