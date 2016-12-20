//
//  SongsOfPlaylistViewController.m
//  Soundify
//
//  Created by Quang Dai on 9/29/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "SongsOfPlaylistViewController.h"

@interface SongsOfPlaylistViewController ()

@end

@implementation SongsOfPlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tblSongOfPlaylist.delegate = self;
    _tblSongOfPlaylist.dataSource = self;
    _searchInSongOfPlaylist.delegate = self;
    _tblSongOfPlaylist.tableFooterView = [[UIView alloc] init];
    
    _playingVC = [PlayingViewController shareInstance];
    
    _connection = [Common isInternetConnected];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", _playlistName]];
    [self getDataFromDb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
;
- (void) viewWillAppear:(BOOL)animated {
    [self getDataFromDb];
    [_tblSongOfPlaylist reloadData];
    [self showButtonPlaying];
}


- (void) showButtonPlaying {
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    _deleteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kImageDelete] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonTouchUpInside:)];
    
    for (int i = 1; i < 33; i++) {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i]]];
    }
    
    UIImage *imageAnimation = [UIImage animatedImageWithImages:imageArray duration:2.0f];
    
    _rightButton = [[UIBarButtonItem alloc] initWithImage:imageAnimation style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTouchUpInside:)];
    
    if ([_resultDb count] <= 0) {
        self.navigationItem.rightBarButtonItem = nil;
        if (_playingVC.isPlaying == YES) {
            self.navigationItem.rightBarButtonItem = _rightButton;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    } else {
        if (_playingVC.isPlaying == YES) {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_deleteButton, _rightButton, nil];
        } else {
            self.navigationItem.rightBarButtonItem = _deleteButton;
        }
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

- (IBAction) deleteButtonTouchUpInside:(id)sender {
    [TracksOfPlaylist deleteAllTrackOfPlaylistName:_playlistName playlistLocation:_playlistLocation];
    _searchInSongOfPlaylist.hidden = YES;
    [_searchInSongOfPlaylist endEditing:YES];
    [_tblSongOfPlaylist reloadData];
    
    if ([_resultDb count] <= 0) {
        self.navigationItem.rightBarButtonItem = nil;
        if (_playingVC.isPlaying == YES) {
            self.navigationItem.rightBarButtonItem = _rightButton;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
        _searchInSongOfPlaylist.hidden = YES;
    } else {
        if (_playingVC.isPlaying == YES) {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_deleteButton, _rightButton, nil];
        } else {
            self.navigationItem.rightBarButtonItem = _deleteButton;
        }
    }
    
}


#pragma mark - Get Track from DB
- (void) getDataFromDb {
    
    _resultDb = [[TracksOfPlaylist objectsWithPredicate:[NSPredicate predicateWithFormat:@"playlistName == %@ AND playlistLocation == %@", _playlistName, _playlistLocation]] sortedResultsUsingProperty:@"addedDate" ascending:NO];
    
    if ([_resultDb count] <= 0) {
        _searchInSongOfPlaylist.hidden = YES;
    } else {
        _searchInSongOfPlaylist.hidden = NO;
    }
    
    _playingArray = [[NSMutableArray alloc] init];
    _playingResult = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_resultDb count]; i++) {
        Playing *playing = [[Playing alloc] initWithResultDb:_resultDb atIndex:i];
        [_playingResult addObject:playing];
    }
    _playingArray = _playingResult;
}





#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_searchInSongOfPlaylist.text isEqualToString:@""]) {
        return [_resultDb count];
    } else {
        return [_searchResult count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_searchInSongOfPlaylist.text isEqualToString:@""]) {
        ListSongCell *listSongCell = [tableView dequeueReusableCellWithIdentifier:@"ListSongCell"];
        if (!listSongCell) {
            listSongCell = [[NSBundle mainBundle] loadNibNamed:@"ListSongCell" owner:self options:nil].firstObject;
            [listSongCell displayTrackFromDbResult:_resultDb index:indexPath.row];
            
            [listSongCell.btnMore addTarget:self action:@selector(btnMoreTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            listSongCell.btnMore.tag = indexPath.row;
        }
        
        return listSongCell;
    } else {
        ListSongCell *listSongCell = [tableView dequeueReusableCellWithIdentifier:@"ListSongCell"];
        if (!listSongCell) {
            listSongCell = [[NSBundle mainBundle] loadNibNamed:@"ListSongCell" owner:self options:nil].firstObject;
            [listSongCell displayTrackFromDbResult:_searchResult index:indexPath.row];
            
            [listSongCell.btnMore addTarget:self action:@selector(btnMoreTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            listSongCell.btnMore.tag = indexPath.row;
        }
        
        _playingSearchArray = [[NSMutableArray alloc] init];
        _playingSearchResult = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [_searchResult count]; i++) {
            Playing *playing = [[Playing alloc] initWithResultDb:_searchResult atIndex:i];
            [_playingSearchResult addObject:playing];
        }
        _playingSearchArray = _playingSearchResult;
        
        return listSongCell;
    }
}

- (IBAction)btnMoreTouchUpInside:(id)sender {
    if ([_searchInSongOfPlaylist.text isEqualToString:@""]) {
        UIButton *senderButton = (UIButton *) sender;
        
        NSString *strArtwork = [Common strDataFromDbResults:_resultDb
                                                      value:@"artworkUrl"
                                                    indexAt:senderButton.tag];
        
        NSString *strId = [Common strDataFromDbResults:_resultDb value:@"trackId" indexAt:senderButton.tag];
        NSInteger intId = [strId intValue];
        
        NSString *strTitle = [Common strDataFromDbResults:_resultDb value:@"title" indexAt:senderButton.tag];
        
        NSString *strArtist = [Common strDataFromDbResults:_resultDb value:@"artist" indexAt:senderButton.tag];
        
        NSString *strStreamUrl = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
        
        NSInteger intDuration = [Common intDataFromDbResults:_resultDb
                                                       value:@"duration"
                                                     indexAt:senderButton.tag];
        
        NSInteger intScore = [Common intDataFromDbResults:_resultDb value:@"score" indexAt:senderButton.tag];
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:kCancelButton style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:kAddButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
            AddToPlaylistViewController *addVC = [[AddToPlaylistViewController alloc] init];
            addVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AddToPlaylistViewController"];
            
            
            
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
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:kRemoveButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [TracksOfPlaylist deleteTrackOfPlaylistWithTrackId:intId
                                                  playlistName:_playlistName
                                              playlistLocation:_playlistLocation];
            [_tblSongOfPlaylist reloadData];
            
            if ([_resultDb count] <= 0) {
                self.navigationItem.rightBarButtonItem = nil;
                if (_playingVC.isPlaying == YES) {
                    self.navigationItem.rightBarButtonItem = _rightButton;
                } else {
                    self.navigationItem.rightBarButtonItem = nil;
                }
                _searchInSongOfPlaylist.hidden = YES;
            } else {
                if (_playingVC.isPlaying == YES) {
                    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_deleteButton, _rightButton, nil];
                } else {
                    self.navigationItem.rightBarButtonItem = _deleteButton;
                }
            }
            
            
        }]];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
    } else {
        UIButton *senderButton = (UIButton *) sender;
        
        NSString *strArtwork = [Common strDataFromDbResults:_searchResult
                                                      value:@"artworkUrl"
                                                    indexAt:senderButton.tag];
        
        NSString *strId = [Common strDataFromDbResults:_searchResult value:@"trackId" indexAt:senderButton.tag];
        NSInteger intId = [strId intValue];
        
        NSString *strTitle = [Common strDataFromDbResults:_searchResult value:@"title" indexAt:senderButton.tag];
        
        NSString *strArtist = [Common strDataFromDbResults:_searchResult value:@"artist" indexAt:senderButton.tag];
        
        NSString *strStreamUrl = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
        
        NSInteger intDuration = [Common intDataFromDbResults:_searchResult
                                                       value:@"duration"
                                                     indexAt:senderButton.tag];
        
        NSInteger intScore = [Common intDataFromDbResults:_searchResult value:@"score" indexAt:senderButton.tag];
        
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [actionSheet addAction:[UIAlertAction actionWithTitle:kCancelButton style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:kAddButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
            AddToPlaylistViewController *addVC = [[AddToPlaylistViewController alloc] init];
            addVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AddToPlaylistViewController"];
            
            
            
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
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:kRemoveButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [TracksOfPlaylist deleteTrackOfPlaylistWithTrackId:intId
                                                  playlistName:_playlistName
                                              playlistLocation:_playlistLocation];
            [_tblSongOfPlaylist reloadData];
        }]];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_connection == YES) {
        if ([_searchInSongOfPlaylist.text isEqualToString:@""]) {
            [_playingVC.playingArray removeAllObjects];
            [_playingVC.playingTrackId removeAllObjects];
      
            NSString *strId = [Common strDataFromDbResults:_resultDb value:@"trackId" indexAt:indexPath.row];
            
            NSString *strTitle = [Common strDataFromDbResults:_resultDb value:@"title" indexAt:indexPath.row];
         
            _playingVC.strId = [NSString stringWithString:strId];
            _playingVC.strTitle = strTitle;
            
            _playingVC.indexOfTrack = indexPath.row;
            _playingVC.playingArray = _playingArray;
            
            [_tblSongOfPlaylist deselectRowAtIndexPath:indexPath animated:YES];
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromTop;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            
            if (![_playingVC.strIdPlaying isEqual: _playingVC.strId]) {
                _playingVC.strIdPlaying = _playingVC.strId;
                _playingVC.sliderRun.value = 0.f;
                _playingVC.lblPlayedTime.text = @"--:--";
                _playingVC.lblRemainingTime.text = @"--:--";
                [_playingVC playTrackWithTrackId:_playingVC.strIdPlaying atIndex:indexPath.row];
            }
            
            [_playingVC setHidesBottomBarWhenPushed:YES];
            
        } else {
            [_playingVC.playingArray removeAllObjects];
            [_playingVC.playingTrackId removeAllObjects];
   
            NSString *strId = [Common strDataFromDbResults:_searchResult value:@"trackId" indexAt:indexPath.row];
            
            NSString *strTitle = [Common strDataFromDbResults:_searchResult value:@"title" indexAt:indexPath.row];
            
            _playingVC.strId = [NSString stringWithString:strId];
            _playingVC.strTitle = strTitle;
            
            _playingVC.indexOfTrack = indexPath.row;
            _playingVC.playingArray = _playingSearchArray;
            
            [_tblSongOfPlaylist deselectRowAtIndexPath:indexPath animated:YES];
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromTop;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            
            if (![_playingVC.strIdPlaying isEqual: _playingVC.strId]) {
                _playingVC.strIdPlaying = _playingVC.strId;
                _playingVC.sliderRun.value = 0.f;
                _playingVC.lblPlayedTime.text = @"--:--";
                _playingVC.lblRemainingTime.text = @"--:--";
                [_playingVC playTrackWithTrackId:_playingVC.strIdPlaying atIndex:indexPath.row];
            }
            
            [_playingVC setHidesBottomBarWhenPushed:YES];
            
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Internet connection has been lost" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self.navigationController pushViewController:_playingVC animated:NO];
}

- (void) searchTrackWithKeyword: (NSString *) keyword {
    _searchResult = [[TracksOfPlaylist objectsWithPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND playlistName == %@ and playlistLocation == %@", keyword, _playlistName, _playlistLocation]] sortedResultsUsingProperty:@"score" ascending:NO];
}






#pragma mark - Search Bar
- (void) dismissKeyboard {
    [_searchInSongOfPlaylist endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![_searchInSongOfPlaylist.text isEqualToString:@""]) {
        [self searchTrackWithKeyword:_searchInSongOfPlaylist.text];
        [_tblSongOfPlaylist reloadData];
    } else {
        [_tblSongOfPlaylist reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchInSongOfPlaylist endEditing:YES];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchInSongOfPlaylist resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchInSongOfPlaylist endEditing:YES];
}@end
