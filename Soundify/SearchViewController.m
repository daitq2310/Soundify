//
//  SearchViewController.m
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:[NSString stringWithFormat:kSoundCloudSearchTitle]];
    
    
    _tblResultTrack.delegate = self;
    _tblResultTrack.dataSource = self;
    _tblResultTrack.tableFooterView = [[UIView alloc] init];
    _tblResultTrack.hidden = YES;
    
    _tblSuggestResultTrack.delegate = self;
    _tblSuggestResultTrack.dataSource = self;
    _tblSuggestResultTrack.tableFooterView = [[UIView alloc] init];
    _tblSuggestResultTrack.hidden = YES;
    
    
    [self removeAllSuggestionData];
    [SearchStorage deleteAllSearchResult];
    
    _playingVC = [PlayingViewController shareInstance];
    
    _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_sessionConfiguration];
    
    _connection = [Common isInternetConnected];
    
    _offset = 0;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tblResultTrack addSubview:_refreshControl];
    
    [_tblResultTrack addInfiniteScrollingWithActionHandler:^{
        [self loadMoreSearchResultWithKeyWord:_searchInSearchScreen.text];
    }];
    
    [self getTrackFromSearchDb];
}

- (void) refreshView:(UIRefreshControl *) refresh {
    _offset = 0;
    [SearchStorage deleteLoadMore];
    [_tblResultTrack reloadData];
    [_refreshControl endRefreshing];
}

- (void) loadingIndicator {
    _waitingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _waitingIndicator.frame = CGRectMake(round((self.view.frame.size.width - 25) / 2), round((self.view.frame.size.height - 25) / 2), 25, 25);
    
    [self.view addSubview:_waitingIndicator];
    [_waitingIndicator startAnimating];
    _loading = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self showButtonPlaying];
    
    
    _playingArray = [[NSMutableArray alloc] init];
    _playingResult = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_resultSearching count]; i++) {
        Playing *playing = [[Playing alloc] initWithResultDb:_resultSearching atIndex:i];
        [_playingResult addObject:playing];
    }
    _playingArray = _playingResult;
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





#pragma mark - Get Suggestion
- (void) getSuggestionWithKeyWord: (NSString *) keyword {
    _tblSuggestResultTrack.hidden = YES;
    _tblResultTrack.hidden = YES;
    
    NSString *strGetTrackUrl = kSoundCloudSuggestion;
    [self loadingIndicator];
    [_sessionManager GET:strGetTrackUrl parameters:@{@"q": keyword,
                                                     @"limit": @(kSoundCloudLimitSuggestion),
                                                     @"client_id" : kSoundCloudClientID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                         
                                                         NSDictionary *resultInfo = responseObject[@"suggestions"];
                                                         
                                                         NSMutableArray *suggestionResult = [[NSMutableArray alloc]init];
                                                         
                                                         for (NSDictionary *dictData in resultInfo) {
                                                             Suggestion *suggestion = [[Suggestion alloc]initWithJsonDict:dictData];
                                                             [suggestionResult addObject:suggestion];
                                                         }
                                                         _suggestArray = suggestionResult;
                                                         
                                                         if ([resultInfo count] <= 0) {
                                                             [_waitingIndicator stopAnimating];
                                                         }
                                                         _tblSuggestResultTrack.hidden = NO;
                                                         
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [_tblSuggestResultTrack reloadData];
                                                         });
                                                         
                                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                         if (error) {
                                                             
                                                         }
                                                     }];
}






#pragma mark - get Search Result
- (void) getSearchResultWithKeyWord: (NSString *) keyword {
    [SearchStorage deleteAllSearchResult];
    _tblSuggestResultTrack.hidden = YES;
    _tblResultTrack.hidden = NO;
    
    NSString *strGetTrackUrl = kSoundCloudSearchTrack;
    
    
    [_sessionManager GET:strGetTrackUrl parameters:@{@"q": keyword,
                                                     @"limit": @(kSoundCloudLimitNumber),
                                                     @"offset": @(0),
                                                     @"client_id" : kSoundCloudClientID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                         
                                                         NSDictionary *resultInfo = responseObject[@"collection"];
                                                        
                                                             for (NSDictionary *dictData in resultInfo) {
                                                                 [SearchStorage createSearchStorageWithDictionaryData:dictData];
                                                                 
                                                             }
                                                         if ([resultInfo count] <= 0) {
                                                             [_waitingIndicator stopAnimating];
                                                         }
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [_tblResultTrack reloadData];
                                                         });
                                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                         if (error) {
                                                             
                                                         }
                                                     }];
    
}





#pragma mark - Loadmore
- (void) loadMoreSearchResultWithKeyWord: (NSString *) keyword {
    _tblSuggestResultTrack.hidden = YES;
    _tblResultTrack.hidden = NO;
    
    NSString *strGetTrackUrl = kSoundCloudSearchTrack;
    
    _offset = kSoundCloudOffset;
    
    [_sessionManager GET:strGetTrackUrl parameters:@{@"q": keyword,
                                                     @"limit": @(kSoundCloudLimitNumber),
                                                     @"offset": @(_offset),
                                                     @"client_id" : kSoundCloudClientID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                         
                                                         NSDictionary *resultInfo = responseObject[@"collection"];
                                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                                             for (NSDictionary *dictData in resultInfo) {
                                                                 [SearchStorage loadMoreSearchStorageWithDictionaryData:dictData loadMore:YES];
                                                                 
                                                             }
                                                             
                                                             [_tblResultTrack.infiniteScrollingView stopAnimating];
                                                             [_refreshControl endRefreshing];
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [_tblResultTrack reloadData];
                                                             });
                                                             _offset += kSoundCloudOffset;
                                                             
                                                         });
                                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                         if (error) {
                                                             
                                                         }
                                                     }];
}







#pragma mark - Database
- (void) getTrackFromSearchDb {
    _resultSearching = [SearchStorage allObjects];
}







#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tblSuggestResultTrack) {
        return [_suggestArray count];
    } else {
        return [_resultSearching count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tblSuggestResultTrack) {
        [_waitingIndicator stopAnimating];
        SuggestCell *suggestCell = [tableView dequeueReusableCellWithIdentifier:@"SuggestCell"];
        if (!suggestCell) {
            suggestCell = [[[NSBundle mainBundle] loadNibNamed:@"SuggestCell" owner:nil options:nil] firstObject];
            
            Suggestion *suggestion = [_suggestArray objectAtIndex:indexPath.row];
            NSString *strSuggestion = suggestion.query;
            NSString *strKind = suggestion.kind;
            
            suggestCell.lblSuggestResult.text = strSuggestion;
            
            if ([strKind isEqualToString:@"user"]) {
                suggestCell.imvSuggestResult.image = [UIImage imageNamed:kImageUser];
                suggestCell.imvSuggestResult.image = [suggestCell.imvSuggestResult.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [suggestCell.imvSuggestResult setTintColor:kGreyColor];
            } else {
                suggestCell.imvSuggestResult.image = [UIImage imageNamed:kImageTrack];
                suggestCell.imvSuggestResult.image = [suggestCell.imvSuggestResult.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [suggestCell.imvSuggestResult setTintColor:kGreyColor];
            }
        }
        return suggestCell;
    } else {
        [_waitingIndicator stopAnimating];
        SearchCell *searchCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        if (!searchCell) {
            searchCell = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil].firstObject;
            [searchCell displayTrackFromDbResult:_resultSearching index:indexPath.row];
            [searchCell.btnMore addTarget:self action:@selector(btnMoreTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            searchCell.btnMore.tag = indexPath.row;
        }
        
        _playingArray = [[NSMutableArray alloc] init];
        _playingResult = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [_resultSearching count]; i++) {
            Playing *playing = [[Playing alloc] initWithResultDb:_resultSearching atIndex:i];
            [_playingResult addObject:playing];
        }
        _playingArray = _playingResult;
        
        return searchCell;
    }
}

- (IBAction)btnMoreTouchUpInside:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:kCancelButton style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:kAddButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIButton *senderButton = (UIButton *) sender;
        
        
        AddToPlaylistViewController *addVC = [[AddToPlaylistViewController alloc] init];
        addVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AddToPlaylistViewController"];
        
        NSString *strArtwork = [Common strDataFromDbResults:_resultSearching
                                                      value:@"artworkUrl"
                                                    indexAt:senderButton.tag];
        
        NSString *strId = [Common strDataFromDbResults:_resultSearching value:@"trackId" indexAt:senderButton.tag];
        NSInteger intId = [strId intValue];
        
        NSString *strTitle = [Common strDataFromDbResults:_resultSearching value:@"title" indexAt:senderButton.tag];
        
        NSString *strArtist = [Common strDataFromDbResults:_resultSearching value:@"artist" indexAt:senderButton.tag];
        
        NSString *strStreamUrl = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
        
        NSInteger intDuration = [Common intDataFromDbResults:_resultSearching
                                                       value:@"duration"
                                                     indexAt:senderButton.tag];
        
        NSInteger intScore = [Common intDataFromDbResults:_resultSearching value:@"score" indexAt:senderButton.tag];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tblSuggestResultTrack) {
        SuggestCell *cell = [_tblSuggestResultTrack cellForRowAtIndexPath:indexPath];
        NSString *cellText = cell.lblSuggestResult.text;
        _searchInSearchScreen.text = cellText;
        _tblSuggestResultTrack.hidden = YES;
        _tblResultTrack.hidden = NO;
        [self getSearchResultWithKeyWord:_searchInSearchScreen.text];
        [self getTrackFromSearchDb];
        [_tblResultTrack reloadData];
        [self dismissKeyboard];
        [self loadingIndicator];
        [_tblSuggestResultTrack deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        if (_connection == YES) {
            [_playingVC.playingArray removeAllObjects];
            [_playingVC.playingTrackId removeAllObjects];

            NSString *strId = [Common strDataFromDbResults:_resultSearching value:@"trackId" indexAt:indexPath.row];
     
            NSString *strTitle = [Common strDataFromDbResults:_resultSearching value:@"title" indexAt:indexPath.row];

            _playingVC.indexOfTrack = indexPath.row;
            _playingVC.playingArray = _playingArray;

            
            _playingVC.strTitle = strTitle;
            _playingVC.strId = [NSString stringWithString:strId];
            
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
        [_tblResultTrack deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissKeyboard];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tblSuggestResultTrack) {
        return 50;
    } else {
        return 60;
    }
}

- (void) removeAllSuggestionData {
    [_suggestArray removeAllObjects];
    [_tblResultTrack reloadData];
}





#pragma mark - Search Bar
- (void) dismissKeyboard {
    [_searchInSearchScreen endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    if (![_searchInSearchScreen.text isEqualToString:@""]) {
        _tblSuggestResultTrack.hidden = NO;
    } else {
        _tblSuggestResultTrack.hidden = YES;
        _tblResultTrack.hidden = YES;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (_loading == YES) {
        [_waitingIndicator stopAnimating];
    }
    if (![_searchInSearchScreen.text isEqualToString:@""]) {
        [self getSuggestionWithKeyWord:_searchInSearchScreen.text];
        _loading = YES;
    } else {
        [SearchStorage deleteAllSearchResult];
        [self removeAllSuggestionData];
        _tblResultTrack.hidden = YES;
        _tblSuggestResultTrack.hidden = YES;
        [_tblResultTrack reloadData];
        [_tblSuggestResultTrack reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _tblSuggestResultTrack.hidden = YES;
    _tblResultTrack.hidden = NO;
    [_searchInSearchScreen endEditing:YES];
    [self getSearchResultWithKeyWord:_searchInSearchScreen.text];
    [self getTrackFromSearchDb];
    
    if ([_suggestArray count] <= 0) {
        _tblSuggestResultTrack.hidden = YES;
        _tblResultTrack.hidden = YES;
        [_waitingIndicator stopAnimating];
    } else {
        _tblResultTrack.hidden = NO;
    }
  
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchInSearchScreen resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchInSearchScreen endEditing:YES];
    _tblSuggestResultTrack.hidden = YES;
    _tblResultTrack.hidden = NO;
    [_waitingIndicator stopAnimating];
}

@end
