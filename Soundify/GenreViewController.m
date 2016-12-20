//
//  GenreViewController.m
//  Soundify
//
//  Created by Quang Dai on 9/29/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "GenreViewController.h"

@interface GenreViewController ()

@end

@implementation GenreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _tblGenre.delegate = self;
    _tblGenre.dataSource = self;
    _tblGenre.tableFooterView = [[UIView alloc] init];
    
    
    _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_sessionConfiguration];
    
    _playingVC = [PlayingViewController shareInstance];
    
    [self.navigationItem setTitle:[NSString stringWithFormat:kSoundCloudGenreTitle]];
    [self readResource];
    [self getGenreFromDb];
    
    
    [self getTracks];
    
    //Location of Realm Database
    NSLog(@"%@",[RLMRealmConfiguration defaultConfiguration].fileURL);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
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




#pragma mark - Genres.json
- (void) readResource {
    NSError *jsonError;
    NSString *path = [[NSBundle mainBundle] pathForResource:kSoundCloudGenresJsonName ofType:@"json"];
    
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&jsonError];
    
    NSData *objectData = [content dataUsingEncoding:NSUTF8StringEncoding];
    _jsonGenreArray = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers
                                                        error:&jsonError];
    for (NSDictionary *jsonDictionary in _jsonGenreArray) {
        [GenreDB createDbWithJsonDictionary:jsonDictionary];
        
        
    }
}

- (void) getGenreFromDb {
    _resultsDb = [GenreDB allObjects];
}

- (void) getTracks {
    for (NSDictionary *dictData in _resultsDb) {
        NSString *strGenreCode = dictData[@"genreCode"];
        NSString *strGenreName = dictData[@"genreName"];
        NSString *strGetTrackURL = [NSString stringWithFormat:kSoundCloudGetMusicOfGenre, strGenreCode];
        [_sessionManager GET:strGetTrackURL parameters:@{@"limit": @(kSoundCloudLimitNumber), @"client_id" : kSoundCloudClientID} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *link = responseObject[@"collection"];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                for (NSDictionary *dictionaryData in link) {
                    [TracksOfGenre createTrackDbWithDictionaryData:dictionaryData[@"track"]
                                                   DictionaryScore:dictionaryData[@"score"]
                                                         genreName:strGenreName];
                    
                }
                
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tblGenre reloadData];
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error) {
                
            }
        }];
    }
}










#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_jsonGenreArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GenreCell *genreCell = [tableView dequeueReusableCellWithIdentifier:@"GenreCell"];
    
    if (!genreCell) {
        genreCell = [[NSBundle mainBundle] loadNibNamed:@"GenreCell" owner:nil options:nil].firstObject;
        _dictGenreData = [_jsonGenreArray objectAtIndex:indexPath.row];
        
        NSString *getGenre = _dictGenreData[@"genre"];
        genreCell.lblGenre.text = [NSString stringWithFormat:@"%@", getGenre];
        
        RLMResults *genreDb = [[TracksOfGenre objectsWithPredicate:[NSPredicate predicateWithFormat:@"genreName == %@", getGenre]] sortedResultsUsingProperty:@"score" ascending:NO];
        
        NSString *strArtwork = [NSString stringWithFormat:@"%@", [[genreDb valueForKey:@"artworkUrl"] firstObject]];
        @try {
            [genreCell.imvGenre sd_setImageWithURL:[NSURL URLWithString:strArtwork] placeholderImage:[UIImage imageNamed:kImagePlaceHolder]];
        }
        @catch (NSException *exception) {
            genreCell.imvGenre.image = [UIImage imageNamed:kImagePlaceHolder];
        }
        
    }
    return genreCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ListSongViewController *listSongVC = [[ListSongViewController alloc] init];
    listSongVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ListSongViewController"];
    
    
    NSDictionary *dictGenreData = [_jsonGenreArray objectAtIndex:indexPath.row];
    
    listSongVC.genreName = dictGenreData[@"genre"];
    listSongVC.genreCode = dictGenreData[@"code"];
    
    [[self navigationController] pushViewController:listSongVC animated:YES];
    
    [_tblGenre deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
