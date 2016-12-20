//
//  ListSongViewController.m
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "ListSongViewController.h"


@interface ListSongViewController ()

@end

@implementation ListSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tblListSong.delegate = self;
    _tblListSong.dataSource = self;
    _tblListSong.tableFooterView = [[UIView alloc] init];

    _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_sessionConfiguration];
    
    _playingVC = [PlayingViewController shareInstance];
    [[self navigationItem] setTitle:_genreName];
    

    _connection = [Common isInternetConnected];
    
    if (_connection == YES) {
        _waitingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _waitingIndicator.frame = CGRectMake(round((self.view.frame.size.width - 25) / 2), round((self.view.frame.size.height - 25) / 2), 25, 25);
        
        [self.view addSubview:_waitingIndicator];
        [_waitingIndicator startAnimating];
        [self getTracks];
    }
    
    _offset = 0;
    [TracksOfGenre deleLoadMoreTrackDb];
    [_tblListSong reloadData];
    
    
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tblListSong addSubview:_refreshControl];
    
    [_tblListSong addInfiniteScrollingWithActionHandler:^{
        [self loadMore];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self showButtonPlaying];
    [self getTrackFromGenreName:_genreName];
}

- (void) showButtonPlaying {
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    if (_playingVC.isPlaying == YES) {
        for (int i = 1; i < 33; i++) {
            [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i]]];
        }
        
        UIImage *imageAnimation = [UIImage animatedImageWithImages:imageArray duration:2.0f];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:imageAnimation style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTouchUpInside:)];
        
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}

- (IBAction) rightBarButtonTouchUpInside:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [_playingVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:_playingVC animated:NO];
}



- (void) refreshView:(UIRefreshControl *) refresh {
    _offset = 0;
    [TracksOfGenre deleLoadMoreTrackDb];
    [_tblListSong reloadData];
    [_refreshControl endRefreshing];
}





#pragma mark - Database
- (void) getTrackFromGenreName: (NSString *) genreName {
    _resultTrackGenreDb = [[TracksOfGenre objectsWithPredicate:[NSPredicate predicateWithFormat: @"genreName = %@", genreName]] sortedResultsUsingProperty:@"score" ascending:NO];
    
    _playingResult = [[NSMutableArray alloc] init];
    _playingArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < [_resultTrackGenreDb count]; i++) {
        Playing *playing = [[Playing alloc] initWithResultDb:_resultTrackGenreDb atIndex:i];
        [_playingResult addObject:playing];
    }
    _playingArray = _playingResult;
}






#pragma mark - Get Track Of Genre
- (void) getTracks {
    NSString *strGetTrackURL = [NSString stringWithFormat:kSoundCloudGetMusicOfGenre, _genreCode];
    [_sessionManager GET:strGetTrackURL parameters:@{@"limit": @(kSoundCloudLimitNumber), @"client_id" : kSoundCloudClientID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *link = responseObject[@"collection"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            for (NSDictionary *dictionaryData in link) {
                [TracksOfGenre createTrackDbWithDictionaryData:dictionaryData[@"track"]
                                               DictionaryScore:dictionaryData[@"score"]
                                                     genreName:_genreName];
                
                [TracksOfGenre updateTrackDbWithDictionaryData:dictionaryData[@"track"]
                                               DictionaryScore:dictionaryData[@"score"]
                                                     genreName:_genreName];
            }
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tblListSong reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
        }
    }];
}






#pragma mark - Loadmore
- (void) loadMore {
    _offset = kSoundCloudOffset;
    
    NSString *strGetTrackURL = [NSString stringWithFormat:kSoundCloudGetMusicOfGenre, _genreCode];
    
    [_sessionManager GET:strGetTrackURL parameters:@{@"limit": @(kSoundCloudLimitNumber), @"offset": @(_offset), @"client_id" : kSoundCloudClientID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *link = responseObject[@"collection"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            for (NSDictionary *dictData in link) {
                [TracksOfGenre loadMoreTrackDbWithDictionaryData:dictData[@"track"]
                                                 DictionaryScore:dictData[@"score"]
                                                       genreName:_genreName
                                                        loadMore:YES];
                
            }
            
            [_tblListSong.infiniteScrollingView stopAnimating];
            [_refreshControl endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tblListSong reloadData];
                [self getTrackFromGenreName:_genreName];
            });
            _offset += kSoundCloudOffset;
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
        }
    }];
    
}









#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_resultTrackGenreDb count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [_waitingIndicator stopAnimating];
    ListSongCell *listSongCell = [tableView dequeueReusableCellWithIdentifier:@"ListSongCell"];
    
    if (!listSongCell) {
        listSongCell = [[NSBundle mainBundle] loadNibNamed:@"ListSongCell" owner:nil options:nil].firstObject;
        [listSongCell displayTrackFromDbResult:_resultTrackGenreDb index:indexPath.row];
        [listSongCell.btnMore addTarget:self action:@selector(btnMoreTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        listSongCell.btnMore.tag = indexPath.row;
    }
    listSongCell.lblDuration.backgroundColor = [UIColor blackColor];
    [listSongCell setHighlighted:YES animated:YES];
    return listSongCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_connection == YES) {
        
        [_playingVC.playingArray removeAllObjects];
        [_playingVC.playingTrackId removeAllObjects];

        NSString *strId = [Common strDataFromDbResults:_resultTrackGenreDb value:@"trackId" indexAt:indexPath.row];

        NSString *strTitle = [Common strDataFromDbResults:_resultTrackGenreDb value:@"title" indexAt:indexPath.row];

        _playingVC.indexOfTrack = indexPath.row;
        _playingVC.playingArray = _playingArray;
        
        
        _playingVC.strId = [NSString stringWithString:strId];
        _playingVC.strTitle = strTitle;
    
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [_playingVC setHidesBottomBarWhenPushed:YES];
        
        if (![_playingVC.strIdPlaying isEqual: _playingVC.strId]) {
            _playingVC.strIdPlaying = _playingVC.strId;
            _playingVC.sliderRun.value = 0.f;
            _playingVC.lblPlayedTime.text = @"--:--";
            _playingVC.lblRemainingTime.text = @"--:--";
            [_playingVC playTrackWithTrackId:_playingVC.strIdPlaying atIndex:indexPath.row];
        }
        
        [self.navigationController pushViewController:_playingVC animated:NO];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Internet connection has been lost" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [_tblListSong deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (IBAction)btnMoreTouchUpInside:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:kCancelButton style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:kAddButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIButton *senderButton = (UIButton *) sender;
        
        
        AddToPlaylistViewController *addVC = [[AddToPlaylistViewController alloc] init];
        addVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AddToPlaylistViewController"];
        
        NSString *strArtwork = [Common strDataFromDbResults:_resultTrackGenreDb
                                                      value:@"artworkUrl"
                                                    indexAt:senderButton.tag];
        
        NSString *strId = [Common strDataFromDbResults:_resultTrackGenreDb value:@"trackId" indexAt:senderButton.tag];
        NSInteger intId = [strId intValue];
        
        NSString *strTitle = [Common strDataFromDbResults:_resultTrackGenreDb value:@"title" indexAt:senderButton.tag];
        
        NSString *strArtist = [Common strDataFromDbResults:_resultTrackGenreDb value:@"artist" indexAt:senderButton.tag];
        
        NSString *strStreamUrl = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
        
        NSInteger intDuration = [Common intDataFromDbResults:_resultTrackGenreDb
                                                       value:@"duration"
                                                     indexAt:senderButton.tag];
        
        NSInteger intScore = [Common intDataFromDbResults:_resultTrackGenreDb value:@"score" indexAt:senderButton.tag];
        
        addVC.trackId = intId;
        addVC.strArtist = strArtist;
        addVC.strTitle = strTitle;
        addVC.intScore = intScore;
        addVC.strArtworkUrl = strArtwork;
        addVC.strStreamUrl = strStreamUrl;
        addVC.intDuration = (int) intDuration;
        
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [addVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:addVC animated:NO];
        
        
        
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



@end
