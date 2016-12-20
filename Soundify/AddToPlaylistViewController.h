//
//  AddToPlaylistViewController.h
//  Soundify
//
//  Created by Quang Dai on 10/8/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistCell.h"
#import "ListPlaylistCell.h"
#import "PlaylistDB.h"
#import "TracksOfPlaylist.h"
#import "Constant.h"
#import "Common.h"
#import <UIImageView+WebCache.h>
#import "GenreCell.h"

@interface AddToPlaylistViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblAdd;

@property RLMResults *resultDb;
@property BOOL connection;

@property NSInteger trackId;
@property NSString *strArtist;
@property NSString *strTitle;
@property NSInteger intScore;
@property NSString *strArtworkUrl;
@property NSString *strStreamUrl;
@property NSInteger intDuration;
@property NSString *playlistName;

@property NSString *playlistLocation;

@end
