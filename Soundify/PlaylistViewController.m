//
//  PlaylistViewController.m
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "PlaylistViewController.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tblPlaylist.delegate = self;
    _tblPlaylist.dataSource = self;
    _tblPlaylist.tableFooterView = [[UIView alloc] init];
    [self.navigationItem setTitle:[NSString stringWithFormat:kSoundCloudPlaylistTitle]];
    [self getDataFromDb];
    _playingVC = [PlayingViewController shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [_tblPlaylist reloadData];
    [self showButtonPlaying];
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





#pragma mark - Get Data from PlaylistDB
- (void) getDataFromDb {
    _resultDb = [[PlaylistDB allObjects] sortedResultsUsingProperty:@"createdDate" ascending:NO];
}





#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if ([_searchInPlaylistScreen.text isEqualToString:@""]) {
            return [_resultDb count];
        } else {
            return [_searchResult count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GenreCell *playlistCell = [tableView dequeueReusableCellWithIdentifier:@"GenreCell"];
        if (!playlistCell) {
            playlistCell = [[NSBundle mainBundle] loadNibNamed:@"GenreCell" owner:nil options:nil].firstObject;
            
            playlistCell.imvGenre.image = [UIImage imageNamed:kImageCreatePlaylist];
            playlistCell.imvGenre.image = [playlistCell.imvGenre.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [playlistCell.imvGenre setTintColor:kDefaultBlueColor];
            [playlistCell.lblGenre setFont:[UIFont systemFontOfSize:20]];
            playlistCell.lblGenre.text = [NSString stringWithFormat:@"New Playlist..."];
        }
        playlistCell.accessoryType = UITableViewCellAccessoryNone;
        return  playlistCell;
    } else {
        if ([_searchInPlaylistScreen.text isEqualToString:@""]) {
            PlaylistCell *playlistCell = [tableView dequeueReusableCellWithIdentifier:@"PlaylistCell"];
            if (!playlistCell) {
                playlistCell = [[NSBundle mainBundle] loadNibNamed:@"PlaylistCell" owner:nil options:nil].firstObject;
                
                NSString *playlistName = [Common strDataFromDbResults:_resultDb value:@"playlistName" indexAt:indexPath.row];
                
                NSString *playlistLocation = [Common strDataFromDbResults:_resultDb value:@"playlistLocation" indexAt:indexPath.row];
                
                RLMResults *trackOfPlaylist = [[TracksOfPlaylist objectsWithPredicate:[NSPredicate predicateWithFormat:@"playlistName == %@ AND playlistLocation == %@", playlistName, playlistLocation]] sortedResultsUsingProperty:@"addedDate" ascending:YES];
                
                NSString *srtArtwork = [[trackOfPlaylist valueForKey:@"artworkUrl"] lastObject];
                NSURL *artworkUrl = [NSURL URLWithString:srtArtwork];
                
                @try {
                    [playlistCell.imvPlaylist sd_setImageWithURL:artworkUrl placeholderImage:[UIImage imageNamed:kImagePlaceHolder]];
                } @catch (NSException *exception) {
                    playlistCell.imvPlaylist.image = [UIImage imageNamed:kImagePlaceHolder];
                }
                
                playlistCell.lblPlaylistName.text = playlistName;
                
                if ([trackOfPlaylist count] > 1) {
                    playlistCell.lblNumberOfTracks.text = [NSString stringWithFormat:@"%ld Tracks", [trackOfPlaylist count]];
                } else {
                    playlistCell.lblNumberOfTracks.text = [NSString stringWithFormat:@"%ld Track", [trackOfPlaylist count]];
                }
                
                playlistCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return  playlistCell;
        } else {
            PlaylistCell *playlistCell = [tableView dequeueReusableCellWithIdentifier:@"PlaylistCell"];
            if (!playlistCell) {
                playlistCell = [[NSBundle mainBundle] loadNibNamed:@"PlaylistCell" owner:nil options:nil].firstObject;
                
                NSString *playlistName = [Common strDataFromDbResults:_searchResult value:@"playlistName" indexAt:indexPath.row];
                
                NSString *playlistLocation = [Common strDataFromDbResults:_searchResult value:@"playlistLocation" indexAt:indexPath.row];
                
                RLMResults *trackOfPlaylist = [[TracksOfPlaylist objectsWithPredicate:[NSPredicate predicateWithFormat:@"playlistName == %@ AND playlistLocation == %@", playlistName, playlistLocation]] sortedResultsUsingProperty:@"addedDate" ascending:YES];
                
                NSString *srtArtwork = [[trackOfPlaylist valueForKey:@"artworkUrl"] lastObject];
                NSURL *artworkUrl = [NSURL URLWithString:srtArtwork];
                
                @try {
                    [playlistCell.imvPlaylist sd_setImageWithURL:artworkUrl placeholderImage:[UIImage imageNamed:kImagePlaceHolder]];
                } @catch (NSException *exception) {
                    playlistCell.imvPlaylist.image = [UIImage imageNamed:kImagePlaceHolder];
                }
                
                playlistCell.lblPlaylistName.text = playlistName;
                
                if ([trackOfPlaylist count] > 1) {
                    playlistCell.lblNumberOfTracks.text = [NSString stringWithFormat:@"%ld Tracks", [trackOfPlaylist count]];
                } else {
                    playlistCell.lblNumberOfTracks.text = [NSString stringWithFormat:@"%ld Track", [trackOfPlaylist count]];
                }
                
                playlistCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return  playlistCell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Playlist" message:@"Enter a name for this playlist." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [_tblPlaylist reloadData];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (alert.textFields[0].text.length > 0) {
                [PlaylistDB createDbWithPlaylistName:alert.textFields[0].text];
            }
            
            [_tblPlaylist reloadData];
        }]];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    } else {
        if ([_searchInPlaylistScreen.text isEqualToString:@""]) {
            SongsOfPlaylistViewController *songOfPlaylistVC = [[SongsOfPlaylistViewController alloc] init];
            songOfPlaylistVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SongsOfPlaylistViewController"];
            [[self navigationController] pushViewController:songOfPlaylistVC animated:YES];
            PlaylistCell *playlistCell = [tableView dequeueReusableCellWithIdentifier:@"PlaylistCell"];
            if (!playlistCell) {
                playlistCell = [[NSBundle mainBundle] loadNibNamed:@"PlaylistCell" owner:nil options:nil].firstObject;
                
                NSArray *playlistArray = [_resultDb valueForKey:@"playlistName"];
                playlistCell.lblPlaylistName.text = [NSString stringWithFormat:@"%@", [playlistArray objectAtIndex:indexPath.row]];
                playlistCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                NSString *playlistLocation = [Common strDataFromDbResults:_resultDb value:@"playlistLocation" indexAt:indexPath.row];
                songOfPlaylistVC.playlistLocation = playlistLocation;
            }
            
            NSString *playlistName = playlistCell.lblPlaylistName.text;
            songOfPlaylistVC.playlistName = playlistName;
        } else {
            SongsOfPlaylistViewController *songOfPlaylistVC = [[SongsOfPlaylistViewController alloc] init];
            songOfPlaylistVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SongsOfPlaylistViewController"];
            [[self navigationController] pushViewController:songOfPlaylistVC animated:YES];
            PlaylistCell *playlistCell = [tableView dequeueReusableCellWithIdentifier:@"PlaylistCell"];
            if (!playlistCell) {
                playlistCell = [[NSBundle mainBundle] loadNibNamed:@"PlaylistCell" owner:nil options:nil].firstObject;
                
                NSArray *playlistArray = [_searchResult valueForKey:@"playlistName"];
                playlistCell.lblPlaylistName.text = [NSString stringWithFormat:@"%@", [playlistArray objectAtIndex:indexPath.row]];
                playlistCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                NSString *playlistLocation = [Common strDataFromDbResults:_searchResult value:@"playlistLocation" indexAt:indexPath.row];
                songOfPlaylistVC.playlistLocation = playlistLocation;
            }
            
            NSString *playlistName = playlistCell.lblPlaylistName.text;
            songOfPlaylistVC.playlistName = playlistName;
        }
    }
    [self dismissKeyboard];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissKeyboard];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void) tapToDismiss {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void) searchPlaylistWithKeyword: (NSString *) keyword {
    _searchResult = [[PlaylistDB objectsWithPredicate:[NSPredicate predicateWithFormat:@"playlistName CONTAINS[c] %@", keyword]] sortedResultsUsingProperty:@"createdDate" ascending:NO];
}





#pragma mark - Search Bar
- (void) dismissKeyboard {
    [_searchInPlaylistScreen endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![_searchInPlaylistScreen.text isEqualToString:@""]) {
        [self searchPlaylistWithKeyword:_searchInPlaylistScreen.text];
        [_tblPlaylist reloadData];
    } else {
        [_tblPlaylist reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchInPlaylistScreen endEditing:YES];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchInPlaylistScreen resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchInPlaylistScreen endEditing:YES];
}


@end
