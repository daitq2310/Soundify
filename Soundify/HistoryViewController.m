//
//  HistoryViewController.m
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController () {
    PlayingViewController *playingVC;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:[NSString stringWithFormat:kSoundCloudHistoryTitle]];
    _tblHistory.delegate = self;
    _tblHistory.dataSource = self;
    _tblHistory.tableFooterView = [[UIView alloc] init];
    
    playingVC = [PlayingViewController shareInstance];
    
    
    
    [self getDataFromHistoryDb];
    _connection = [Common isInternetConnected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [self getDataFromHistoryDb];
    [_tblHistory reloadData];
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
    
    if ([_resultHistoryDb count] <= 0) {
        self.navigationItem.rightBarButtonItem = nil;
        if (playingVC.isPlaying == YES) {
            self.navigationItem.rightBarButtonItem = _rightButton;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    } else {
        if (playingVC.isPlaying == YES) {
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
    [playingVC setHidesBottomBarWhenPushed:YES];

    [self.navigationController pushViewController:playingVC animated:NO];
}

- (IBAction) deleteButtonTouchUpInside:(id)sender {
    [HistoryDB deleteAllHistory];
    [_tblHistory reloadData];
    [_searchInHistoryScreen endEditing:YES];
    
    if ([_resultHistoryDb count] <= 0) {
        self.navigationItem.rightBarButtonItem = nil;
        if (playingVC.isPlaying == YES) {
            self.navigationItem.rightBarButtonItem = _rightButton;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    } else {
        if (playingVC.isPlaying == YES) {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_deleteButton, _rightButton, nil];
        } else {
            self.navigationItem.rightBarButtonItem = _deleteButton;
        }
    }
    
    _searchInHistoryScreen.hidden = YES;
}





#pragma mark - Get Data from DB
- (void) getDataFromHistoryDb {
    _resultHistoryDb = [[HistoryDB allObjects] sortedResultsUsingProperty:@"createdDate" ascending:NO];
    
    if ([_resultHistoryDb count] <= 0) {
        _searchInHistoryScreen.hidden = YES;
    } else {
        _searchInHistoryScreen.hidden = NO;
    }
    
    _playingResult = [[NSMutableArray alloc] init];
    _playingArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_resultHistoryDb count]; i++) {
        Playing *playing = [[Playing alloc] initWithResultDb:_resultHistoryDb atIndex:i];
        [_playingResult addObject:playing];
    }
    _playingArray = _playingResult;
}





#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_searchInHistoryScreen.text isEqualToString:@""]) {
        return [_resultHistoryDb count];
    } else {
        return [_searchResult count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_searchInHistoryScreen.text isEqualToString:@""]) {
        ListSongCell *listSongCell = [tableView dequeueReusableCellWithIdentifier:@"ListSongCell"];
        
        if (!listSongCell) {
            
            listSongCell = [[NSBundle mainBundle] loadNibNamed:@"ListSongCell" owner:nil options:nil].firstObject;
            
            [listSongCell displayTrackFromDbResult:_resultHistoryDb index:indexPath.row];
            
            [listSongCell.btnMore addTarget:self action:@selector(btnMoreTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
            listSongCell.btnMore.tag = indexPath.row;
            [_tblHistory refreshControl];
        }
        return listSongCell;
    } else {
        ListSongCell *listSongCell = [tableView dequeueReusableCellWithIdentifier:@"ListSongCell"];
        
        if (!listSongCell) {
            
            listSongCell = [[NSBundle mainBundle] loadNibNamed:@"ListSongCell" owner:nil options:nil].firstObject;
            
            [listSongCell displayTrackFromDbResult:_searchResult index:indexPath.row];
            
            [listSongCell.btnMore addTarget:self action:@selector(btnMoreTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
            listSongCell.btnMore.tag = indexPath.row;
            [_tblHistory refreshControl];
        }
        _playingSearchResult = [[NSMutableArray alloc] init];
        _playingSearchArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [_searchResult count]; i++) {
            Playing *playing = [[Playing alloc] initWithResultDb:_searchResult atIndex:i];
            [_playingSearchResult addObject:playing];
        }
        _playingSearchArray = _playingSearchResult;
        
        return listSongCell;
    }
    
}

- (IBAction)btnMoreTouchUpInSide:(id)sender {
    if ([_searchInHistoryScreen.text isEqualToString:@""]) {
        
        UIButton *senderButton = (UIButton *) sender;
        
        NSString *strArtwork = [Common strDataFromDbResults:_resultHistoryDb
                                                      value:@"artworkUrl"
                                                    indexAt:senderButton.tag];
        
        NSString *strId = [Common strDataFromDbResults:_resultHistoryDb value:@"trackId" indexAt:senderButton.tag];
        NSInteger intId = [strId intValue];
        
        NSString *strTitle = [Common strDataFromDbResults:_resultHistoryDb value:@"title" indexAt:senderButton.tag];
        
        NSString *strArtist = [Common strDataFromDbResults:_resultHistoryDb value:@"artist" indexAt:senderButton.tag];
        
        NSString *strStreamUrl = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
        
        NSInteger intDuration = [Common intDataFromDbResults:_resultHistoryDb
                                                       value:@"duration"
                                                     indexAt:senderButton.tag];
        
        NSInteger intScore = [Common intDataFromDbResults:_resultHistoryDb value:@"score" indexAt:senderButton.tag];
        
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
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:kDeleteButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HistoryDB deleteTrackHistoryWithTrackId:intId];
            [_tblHistory reloadData];
            if ([_resultHistoryDb count] <= 0) {
                self.navigationItem.rightBarButtonItem = nil;
                if (playingVC.isPlaying == YES) {
                    self.navigationItem.rightBarButtonItem = _rightButton;
                } else {
                    self.navigationItem.rightBarButtonItem = nil;
                }
                _searchInHistoryScreen.hidden = YES;
            } else {
                if (playingVC.isPlaying == YES) {
                    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_deleteButton, _rightButton, nil];
                } else {
                    self.navigationItem.rightBarButtonItem = _deleteButton;
                }
            }
        }]];
        
        
        [self dismissKeyboard];
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
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:kDeleteButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HistoryDB deleteTrackHistoryWithTrackId:intId];
            [_tblHistory reloadData];
            
            if ([_resultHistoryDb count] <= 0) {
                self.navigationItem.rightBarButtonItem = nil;
                if (playingVC.isPlaying == YES) {
                    self.navigationItem.rightBarButtonItem = _rightButton;
                } else {
                    self.navigationItem.rightBarButtonItem = nil;
                }
                _searchInHistoryScreen.hidden = YES;
            } else {
                if (playingVC.isPlaying == YES) {
                    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_deleteButton, _rightButton, nil];
                } else {
                    self.navigationItem.rightBarButtonItem = _deleteButton;
                }
            }
            
        }]];
        
        
        [self dismissKeyboard];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissKeyboard];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    if (_connection == YES) {
        [playingVC.playingArray removeAllObjects];
        [playingVC.playingTrackId removeAllObjects];
        
        if ([_searchInHistoryScreen.text isEqualToString:@""]) {
            
            NSString *strId = [Common strDataFromDbResults:_resultHistoryDb value:@"trackId" indexAt:indexPath.row];
            
            NSString *strTitle = [Common strDataFromDbResults:_resultHistoryDb value:@"title" indexAt:indexPath.row];
            
            playingVC.indexOfTrack = indexPath.row;
            playingVC.playingArray = _playingArray;

            
            playingVC.strId = [NSString stringWithString:strId];
            playingVC.strTitle = strTitle;
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromTop;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            [playingVC setHidesBottomBarWhenPushed:YES];
            
            if (![playingVC.strIdPlaying isEqual: playingVC.strId]) {
                playingVC.strIdPlaying = playingVC.strId;
                playingVC.sliderRun.value = 0.f;
                playingVC.lblPlayedTime.text = @"--:--";
                playingVC.lblRemainingTime.text = @"--:--";
                [playingVC playTrackWithTrackId:playingVC.strIdPlaying atIndex:indexPath.row];
            }
            
            [self.navigationController pushViewController:playingVC animated:NO];
        } else {
            
            NSString *strId = [Common strDataFromDbResults:_searchResult value:@"trackId" indexAt:indexPath.row];

            NSString *strTitle = [Common strDataFromDbResults:_searchResult value:@"title" indexAt:indexPath.row];
            
            playingVC.indexOfTrack = indexPath.row;
            playingVC.playingArray = _playingSearchArray;

            
            playingVC.strId = [NSString stringWithString:strId];
            playingVC.strTitle = strTitle;
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromTop;
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            [playingVC setHidesBottomBarWhenPushed:YES];
            
            if (![playingVC.strIdPlaying isEqual: playingVC.strId]) {
                playingVC.strIdPlaying = playingVC.strId;
                playingVC.sliderRun.value = 0.f;
                playingVC.lblPlayedTime.text = @"--:--";
                playingVC.lblRemainingTime.text = @"--:--";
                [playingVC playTrackWithTrackId:playingVC.strIdPlaying atIndex:indexPath.row];
            }
            
            [self.navigationController pushViewController:playingVC animated:NO];
        }
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Internet connection has been lost" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [_tblHistory deselectRowAtIndexPath:indexPath animated:NO];
}

- (void) searchHistoryWithKeyword: (NSString *) keyword {
    _searchResult = [[HistoryDB objectsWithPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS [c]%@", keyword]] sortedResultsUsingProperty:@"score" ascending:NO];
}






#pragma mark - Search Bar
- (void) dismissKeyboard {
    [_searchInHistoryScreen endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![_searchInHistoryScreen.text isEqualToString:@""]) {
        [self searchHistoryWithKeyword:_searchInHistoryScreen.text];
        [_tblHistory reloadData];
    } else {
        [_tblHistory reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchInHistoryScreen endEditing:YES];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchInHistoryScreen resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchInHistoryScreen endEditing:YES];
}
@end
