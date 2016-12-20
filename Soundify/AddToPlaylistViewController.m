//
//  AddToPlaylistViewController.m
//  Soundify
//
//  Created by Quang Dai on 10/8/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "AddToPlaylistViewController.h"


#define kErrorText                          @"Error"
#define kChoosePlaylist                     @"Please choose Playlist"
#define kTrackExists                        @"Track already exists"
#define kCreateNewPlaylistText              @"New Playlist..."
#define kNewPlaylistText                    @"New Playlist"
#define kEnterPlaylistNameText              @"Enter a name for this playlist."
#define kPlaylistsText                      @"Playlists"


@interface AddToPlaylistViewController ()

@end

@implementation AddToPlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tblAdd.delegate = self;
    _tblAdd.dataSource = self;
    _tblAdd.tableFooterView = [[UIView alloc] init];
    
    
    [self.navigationItem setTitle:[NSString stringWithFormat:kSoundCloudAddToPlaylistTitle]];
    [self buttonOfNavigation];
    [self getDataFromDb];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [_tblAdd reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}






#pragma mark - navigation bar
- (void) buttonOfNavigation {
    self. navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonTouchUpInside:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonTouchUpInside:)];
}

- (IBAction) rightBarButtonTouchUpInside:(id)sender {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyy HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *addedDate = [dateFormatter dateFromString:strDate];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trackId == %ld AND playlistLocation == %@", _trackId, _playlistLocation];
    RLMResults *resultsFromTrackOfPlaylist = [TracksOfPlaylist objectsWithPredicate:predicate];
    
        if (_playlistName == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:kErrorText
                                                                       message:kChoosePlaylist
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction: [UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleCancel
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     
                                                 }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    if ([resultsFromTrackOfPlaylist count] == 0) {
        
        NSString *trackIdAndPlaylistLocation = [NSString stringWithFormat:@"%ld %@", _trackId, _playlistLocation];
        [TracksOfPlaylist createDbWithTrackIdAndPlaylistLocation:trackIdAndPlaylistLocation
                                                         trackId:_trackId
                                                           title:_strTitle
                                                          artist:_strArtist
                                                      artworkUrl:_strArtworkUrl
                                                       streamUrl:_strStreamUrl
                                                        duration:_intDuration
                                                           score:_intScore
                                                       addedDate:addedDate
                                                    playlistName:_playlistName
                                                playlistLocation:_playlistLocation];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController popViewControllerAnimated:NO];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:kErrorText
                                                                       message:kTrackExists
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction: [UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleCancel
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     
                                                 }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
}

- (IBAction) leftBarButtonTouchUpInside:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Get Data from PlaylistDB
- (void) getDataFromDb {
    _resultDb = [[PlaylistDB allObjects] sortedResultsUsingProperty:@"createdDate" ascending:NO];
}





#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        return [_resultDb count];
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
            playlistCell.lblGenre.text = [NSString stringWithFormat:kNewPlaylistText];
        }
        playlistCell.accessoryType = UITableViewCellAccessoryNone;
        return  playlistCell;
    } else if (indexPath.section == 1) {
        ListPlaylistCell *listPlaylistCell = [tableView dequeueReusableCellWithIdentifier:@"ListPlaylistCell"];
        if (!listPlaylistCell) {
            listPlaylistCell = [[NSBundle mainBundle] loadNibNamed:@"ListPlaylistCell" owner:nil options:nil].firstObject;
            
            listPlaylistCell.lblListPlaylist.text = kPlaylistsText;
            listPlaylistCell.lblListPlaylist.textColor = kDefaultBlueColor;
            listPlaylistCell.backgroundColor = kLightGreyColor;
        }
        listPlaylistCell.userInteractionEnabled = NO;
        return listPlaylistCell;
    } else {
        PlaylistCell *playlistCell = [tableView dequeueReusableCellWithIdentifier:@"PlaylistCell"];
        if (!playlistCell) {
            playlistCell = [[NSBundle mainBundle] loadNibNamed:@"PlaylistCell" owner:nil options:nil].firstObject;
            
            NSString *playlistName = [Common strDataFromDbResults:_resultDb value:@"playlistName" indexAt:indexPath.row];
            NSString *playlistLocation = [Common strDataFromDbResults:_resultDb value:@"playlistLocation" indexAt:indexPath.row];
            
            RLMResults *trackOfPlaylist = [TracksOfPlaylist objectsWithPredicate:[NSPredicate predicateWithFormat:@"playlistName == %@ AND playlistLocation == %@", playlistName, playlistLocation]];
            
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
        }
        
        playlistCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  playlistCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Playlist" message: kEnterPlaylistNameText preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [_tblAdd reloadData];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (alert.textFields[0].text.length > 0) {
                [PlaylistDB createDbWithPlaylistName:alert.textFields[0].text];
            }
            
            [_tblAdd reloadData];
        }]];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
    if (indexPath.section == 2) {
        NSArray *playlistArray = [_resultDb valueForKey:@"playlistName"];
        _playlistName = [playlistArray objectAtIndex:indexPath.row];
        _playlistLocation = [Common strDataFromDbResults:_resultDb value:@"playlistLocation" indexAt:indexPath.row];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_resultDb count] > 0) {
        if (indexPath.section == 2) {
            NSIndexPath *oldIndex = [_tblAdd indexPathForSelectedRow];
            [_tblAdd cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
            [_tblAdd cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 1) {
        return 50;
    } else {
        return 70;
    }
}

@end
