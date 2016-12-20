//
//  GenreViewController.h
//  Soundify
//
//  Created by Quang Dai on 9/29/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "GenreCell.h"
#import "Common.h"
#import "ListSongViewController.h"
#import "GenreDB.h"
#import "TracksOfGenre.h"
#import <UIImageView+WebCache.h>
#import <Realm/Realm.h>
#import <Reachability.h>
#import "PlayingViewController.h"

@interface GenreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tblGenre;
@property NSMutableArray *jsonGenreArray;
@property BOOL connection;

@property NSDictionary *dictGenreData;
@property NSDictionary *link;

@property NSURLSessionConfiguration *sessionConfiguration;
@property AFHTTPSessionManager *sessionManager;

@property RLMResults *resultsDb;

@property PlayingViewController *playingVC;

@end
