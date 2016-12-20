//
//  PlayingViewController.m
//  Soundify
//
//  Created by Quang Dai on 10/1/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "PlayingViewController.h"

#define kImageShuffleButtonON               @"shuffle_playing_on"
#define kImageShuffleButtonOFF              @"shuffle_playing_off"
#define kImageRepeatButtonON                @"repeat_playing_on"
#define kImageRepeatButtonOFF               @"repeat_playing_off"
#define kImageNextButton                    @"next_playing"
#define kImagePreviousButton                @"previous_playing"


@interface PlayingViewController ()

@end

@implementation PlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self playTrackWithTrackId:_strIdPlaying atIndex:_indexOfTrack];
    
    [_btnPlay setImage:[[UIImage imageNamed:kImageButtonPause] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPlay.tintColor = kDefaultBlueColor;
    
    [_btnNext setImage:[[UIImage imageNamed:kImageNextButton] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnNext.tintColor = kDefaultBlueColor;
    
    [_btnPrevious setImage:[[UIImage imageNamed:kImagePreviousButton] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPrevious.tintColor = kDefaultBlueColor;

    _playingTrackId = [[NSMutableArray alloc] init];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    for (int i = 0; i < [_playingArray count]; i++) {
        Playing *playing = [_playingArray objectAtIndex:i];
        [_playingTrackId addObject:@(playing.trackId)];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

+ (PlayingViewController *) shareInstance {
    static PlayingViewController *shareInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstace = [[PlayingViewController alloc] init];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        shareInstace = [storyboard instantiateViewControllerWithIdentifier:@"PlayingViewController"];
    });
    
    return shareInstace;
}














#pragma mark - Play Track
- (void) playTrackWithTrackId: (NSString *) trackId atIndex: (NSInteger) index {
    Playing *playing = [_playingArray objectAtIndex:index];
    
    _btnPlay.selected = NO;
    [_btnPlay setImage:[[UIImage imageNamed:kImageButtonPause] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPlay.tintColor = kDefaultBlueColor;
    
    _strArtwork = playing.artworkUrl;
    _strTitle = playing.title;
    _strArtist = playing.artist;
    _intRemainingTime = playing.duration;
    _intScore = playing.score;
    
    NSString *remainingTime = [NSString stringWithFormat:@"-%@", [Common timeFormatted: (int) _intRemainingTime / 1000]];
    
    @try {
        [_imvArtWork sd_setImageWithURL:[NSURL URLWithString:_strArtwork] placeholderImage:[UIImage imageNamed:kImagePlaceHolder]];
    } @catch (NSException *exception) {
        _imvArtWork.image = [UIImage imageNamed:kImagePlaceHolder];
    }
    
    _lblTitle.text = _strTitle;
    _lblUserName.text = _strArtist;
    _lblRemainingTime.text = remainingTime;
    _sliderRun.value = 0.f;

    
    _strStream = [NSString stringWithFormat:kSoundCloudStream, trackId, kSoundCloudClientID];
    NSURL *streamUrl = [NSURL URLWithString:_strStream];

    [self streamTrackWithUrl:streamUrl];
    
    NSInteger intTrackId = [_strIdPlaying integerValue];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyy HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *createdDate = [dateFormatter dateFromString:strDate];
    
    [HistoryDB updateHistoryDbWithTrackId:intTrackId
                                    title:_strTitle
                                   artist:_strArtist
                               artworkUrl:_strArtwork
                                streamUrl:_strStream
                                 duration:_intRemainingTime
                                    score:_intScore
                              createdDate:createdDate];
    
}

- (void) streamTrackWithUrl: (NSURL *) streamUrl {
    _nowPlayerItem = [[AVPlayerItem alloc] initWithURL:streamUrl];
    
    if (_avPlayer == nil) {
        _avPlayer = [[AVPlayer alloc]initWithPlayerItem:_nowPlayerItem];
        
        [_avPlayer addObserver:self
                    forKeyPath:@"currentItem"
                       options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                       context:nil];
        
        [_avPlayer addObserver:self
                    forKeyPath:@"rate"
                       options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                       context:nil];

    } else {
        
        [_avPlayer replaceCurrentItemWithPlayerItem:_nowPlayerItem];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:_nowPlayerItem];
    
    [_avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    [_avPlayer addObserver:self forKeyPath:@"playbackBufferEmpty" options:0 context:nil];
    [_avPlayer addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:0 context:nil];
    
    [_avPlayer play];
    
    [self sliderValueChange];
    _isPlaying = YES;

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _nowPlayerItem) {
        if ([keyPath isEqualToString:@"status"]) {
            if (_nowPlayerItem.status == AVPlayerItemStatusFailed) {
                NSLog(@"AVPlayerItemStatusFailed");
            } else if (_nowPlayerItem.status == AVPlayerItemStatusReadyToPlay){
                NSLog(@"AVPlayerItemStatusReadyToPlay");
            } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
 
            } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
                if (_nowPlayerItem.playbackLikelyToKeepUp || _nowPlayerItem.playbackBufferFull) {
                    [self playbackLikelyToKeepUp];
                }
            }
        }
    } else if ([keyPath isEqualToString:@"currentItem.loadedTimeRanges"]) {
        
        NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
        if (timeRanges && ![timeRanges isKindOfClass:[NSNull class]] && [timeRanges count] > 0) {
            _lblPlayedTime.text = @"--:--";
            _lblRemainingTime.text = @"--:--";
            _sliderRun.value = 0;
        }
    }
}


- (void)playbackLikelyToKeepUp {
    if (_nowPlayerItem.playbackLikelyToKeepUp || _nowPlayerItem.playbackBufferFull) {
        [self play];
        
    }
}

- (void) sliderValueChange {
    CMTime interval = CMTimeMake(33, 1000);  // 30fps
    _playbackObserver = [_avPlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
        
        CGFloat playedTime = CMTimeGetSeconds(time);
        
        CMTime endTime = CMTimeConvertScale (_avPlayer.currentItem.asset.duration, _avPlayer.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        
        CGFloat remainingTime = _intRemainingTime / 1000 - playedTime;
        
        if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
            NSString *strSecond = [Common timeFormatted:(int) playedTime];
            NSString *strRemainingTime = [Common timeFormatted:(int) remainingTime];
            
            _lblPlayedTime.text = strSecond;
            _lblRemainingTime.text = [NSString stringWithFormat:@"-%@", strRemainingTime];
            double normalizedTime = (double) _avPlayer.currentTime.value / (double) endTime.value;
            _sliderRun.value = normalizedTime;
        }
    }];
}

- (void) itemDidFinishPlaying: (NSNotification *) notification {
    _lblPlayedTime.text = @"--:--";
    _lblRemainingTime.text = @"--:--";
    Playing *lastPlaying = [_playingArray objectAtIndex:[_playingArray count] - 1];
    NSString *lastTrackId = [NSString stringWithFormat:@"%ld", lastPlaying.trackId];
    if (_btnShuffle.selected) {
        NSInteger randomIndex = arc4random() % [_playingArray count];
        Playing *nowPlaying = [_playingArray objectAtIndex:randomIndex];
        NSInteger trackIdNow = nowPlaying.trackId;
        _strIdPlaying = [NSString stringWithFormat:@"%ld", trackIdNow];
        [self playTrackWithTrackId:_strIdPlaying atIndex:randomIndex];
    } else {
        if ([[NSString stringWithString:_strIdPlaying] isEqualToString:lastTrackId]) {
            Playing *firstPlaying = [_playingArray objectAtIndex:0];
            NSString *firstTrackId = [NSString stringWithFormat:@"%ld", firstPlaying.trackId];
            _strIdPlaying = [NSString stringWithFormat:@"%@", firstTrackId];
            [self playTrackWithTrackId:_strIdPlaying atIndex:0];
        }
        else {
            NSInteger trackIdLocation = [_playingTrackId indexOfObject:@([_strIdPlaying integerValue])];
            Playing *nextPlaying = [_playingArray objectAtIndex:trackIdLocation + 1];
            NSString *strTrackIdNow = [NSString stringWithFormat:@"%ld", nextPlaying.trackId];
            _strIdPlaying = [NSString stringWithFormat:@"%@", strTrackIdNow];
            [self playTrackWithTrackId:_strIdPlaying atIndex:trackIdLocation + 1];
        }
    }
    
    [_btnPlay setImage:[[UIImage imageNamed:kImageButtonPause] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPlay.tintColor = kDefaultBlueColor;
}


- (void) remoteControlReceivedWithEvent:(UIEvent *)event{
    Playing *topPlaying = [_playingArray objectAtIndex:0];
    NSString *topTrackId = [NSString stringWithFormat:@"%ld", topPlaying.trackId];
    
    Playing *lastPlaying = [_playingArray objectAtIndex:[_playingArray count] - 1];
    NSString *lastTrackId = [NSString stringWithFormat:@"%ld", lastPlaying.trackId];
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (self.btnPlay.selected) {
                    [self play];
                } else {
                    [self pause];
                }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                if (_btnShuffle.selected) {
                    NSInteger randomIndex = arc4random() % [_playingArray count];
                    Playing *nowPlaying = [_playingArray objectAtIndex:randomIndex];
                    NSInteger trackIdNow = nowPlaying.trackId;
                    _strIdPlaying = [NSString stringWithFormat:@"%ld", trackIdNow];
                    [self playTrackWithTrackId:_strIdPlaying atIndex:randomIndex];
                } else {
                    if ([[NSString stringWithString:topTrackId] isEqualToString:_strIdPlaying]) {
                        Playing *lastPlaying = [_playingArray objectAtIndex:[_playingArray count] - 1];
                        NSString *lastTrackId = [NSString stringWithFormat:@"%ld", lastPlaying.trackId];
                        _strIdPlaying = [NSString stringWithFormat:@"%@", lastTrackId];
                        [self playTrackWithTrackId:_strIdPlaying atIndex:[_playingArray count] - 1];
                        
                    } else {
                        NSInteger trackIdLocation = [_playingTrackId indexOfObject:@([_strIdPlaying integerValue])];
                        Playing *prePlaying = [_playingArray objectAtIndex:trackIdLocation - 1];
                        NSString *strTrackIdNow = [NSString stringWithFormat:@"%ld", prePlaying.trackId];
                        _strIdPlaying = [NSString stringWithFormat:@"%@", strTrackIdNow];
                        [self playTrackWithTrackId:_strIdPlaying atIndex:trackIdLocation - 1];
                    }
                }
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                if (_btnShuffle.selected) {
                    NSInteger randomIndex = arc4random() % [_playingArray count];
                    Playing *nowPlaying = [_playingArray objectAtIndex:randomIndex];
                    NSInteger trackIdNow = nowPlaying.trackId;
                    _strIdPlaying = [NSString stringWithFormat:@"%ld", trackIdNow];
                    [self playTrackWithTrackId:_strIdPlaying atIndex:randomIndex];
                } else {
                    if ([[NSString stringWithString:_strIdPlaying] isEqualToString:lastTrackId]) {
                        Playing *firstPlaying = [_playingArray objectAtIndex:0];
                        NSString *firstTrackId = [NSString stringWithFormat:@"%ld", firstPlaying.trackId];
                        _strIdPlaying = [NSString stringWithFormat:@"%@", firstTrackId];
                        [self playTrackWithTrackId:_strIdPlaying atIndex:0];
                    }
                    else {
                        NSInteger trackIdLocation = [_playingTrackId indexOfObject:@([_strIdPlaying integerValue])];
                        Playing *nextPlaying = [_playingArray objectAtIndex:trackIdLocation + 1];
                        NSString *strTrackIdNow = [NSString stringWithFormat:@"%ld", nextPlaying.trackId];
                        _strIdPlaying = [NSString stringWithFormat:@"%@", strTrackIdNow];
                        [self playTrackWithTrackId:_strIdPlaying atIndex:trackIdLocation + 1];
                    }
                }
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                [self play];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                [self pause];
                break;
                
            default:
                break;
        }
    }
    
    [_btnPlay setImage:[[UIImage imageNamed:kImageButtonPause] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPlay.tintColor = kDefaultBlueColor;
}








#pragma mark - Button Track Control
- (IBAction)btnPreviousTouchUpInSide:(id)sender {
    _lblPlayedTime.text = @"--:--";
    _lblRemainingTime.text = @"--:--";
    
    Playing *topPlaying = [_playingArray objectAtIndex:0];
    NSString *topTrackId = [NSString stringWithFormat:@"%ld", topPlaying.trackId];
    if (_btnShuffle.selected) {
        NSInteger randomIndex = arc4random() % [_playingArray count];
        Playing *nowPlaying = [_playingArray objectAtIndex:randomIndex];
        NSInteger trackIdNow = nowPlaying.trackId;
        _strIdPlaying = [NSString stringWithFormat:@"%ld", trackIdNow];
        [self playTrackWithTrackId:_strIdPlaying atIndex:randomIndex];
    } else {
        if ([[NSString stringWithString:topTrackId] isEqualToString:_strIdPlaying]) {
            Playing *lastPlaying = [_playingArray objectAtIndex:[_playingArray count] - 1];
            NSString *lastTrackId = [NSString stringWithFormat:@"%ld", lastPlaying.trackId];
            _strIdPlaying = [NSString stringWithFormat:@"%@", lastTrackId];
            [self playTrackWithTrackId:_strIdPlaying atIndex:[_playingArray count] - 1];

        } else {
            NSInteger trackIdLocation = [_playingTrackId indexOfObject:@([_strIdPlaying integerValue])];
            Playing *prePlaying = [_playingArray objectAtIndex:trackIdLocation - 1];
            NSString *strTrackIdNow = [NSString stringWithFormat:@"%ld", prePlaying.trackId];
            _strIdPlaying = [NSString stringWithFormat:@"%@", strTrackIdNow];
            [self playTrackWithTrackId:_strIdPlaying atIndex:trackIdLocation - 1];
        }
    }
    
    [_btnPlay setImage:[[UIImage imageNamed:kImageButtonPause] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPlay.tintColor = kDefaultBlueColor;

}

- (IBAction)btnPlayTouchUpInSide:(id)sender {
    if (_btnPlay.selected) {
        [self play];
    } else {
        [self pause];
    }
}

- (void) play {
    _btnPlay.selected = NO;
    [_btnPlay setImage:[[UIImage imageNamed:kImageButtonPause] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPlay.tintColor = kDefaultBlueColor;
    [_avPlayer play];
}

- (void) pause {
    _btnPlay.selected = YES;
    [_btnPlay setImage:[[UIImage imageNamed:kImageButtonPlay] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPlay.tintColor = kDefaultBlueColor;
    [_avPlayer pause];
}

- (IBAction)btnNextTouchUpInSide:(id)sender {
    _lblPlayedTime.text = @"--:--";
    _lblRemainingTime.text = @"--:--";
    
    Playing *lastPlaying = [_playingArray objectAtIndex:[_playingArray count] - 1];
    NSString *lastTrackId = [NSString stringWithFormat:@"%ld", lastPlaying.trackId];
    if (_btnShuffle.selected) {
        NSInteger randomIndex = arc4random() % [_playingArray count];
        Playing *nowPlaying = [_playingArray objectAtIndex:randomIndex];
        NSInteger trackIdNow = nowPlaying.trackId;
        _strIdPlaying = [NSString stringWithFormat:@"%ld", trackIdNow];
        [self playTrackWithTrackId:_strIdPlaying atIndex:randomIndex];
    } else {
        if ([[NSString stringWithString:_strIdPlaying] isEqualToString:lastTrackId]) {
            Playing *firstPlaying = [_playingArray objectAtIndex:0];
            NSString *firstTrackId = [NSString stringWithFormat:@"%ld", firstPlaying.trackId];
            _strIdPlaying = [NSString stringWithFormat:@"%@", firstTrackId];
            [self playTrackWithTrackId:_strIdPlaying atIndex:0];
        }
        else {
            NSInteger trackIdLocation = [_playingTrackId indexOfObject:@([_strIdPlaying integerValue])];
            Playing *nextPlaying = [_playingArray objectAtIndex:trackIdLocation + 1];
            NSString *strTrackIdNow = [NSString stringWithFormat:@"%ld", nextPlaying.trackId];
            _strIdPlaying = [NSString stringWithFormat:@"%@", strTrackIdNow];
            [self playTrackWithTrackId:_strIdPlaying atIndex:trackIdLocation + 1];
        }
    }
    
    [_btnPlay setImage:[[UIImage imageNamed:kImageButtonPause] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPlay.tintColor = kDefaultBlueColor;

}

- (IBAction)btnRepeatTouchUpInSide:(id)sender {
    if (_btnRepeat.selected) {
        _btnRepeat.selected = NO;
        [_btnRepeat setImage:[UIImage imageNamed:kImageRepeatButtonOFF] forState:UIControlStateNormal];
    } else {
        _btnRepeat.selected = YES;
        [_btnRepeat setImage:[[UIImage imageNamed:kImageRepeatButtonON] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _btnRepeat.tintColor = kDefaultBlueColor;
    }
}

- (IBAction)btnShuffleTouchUpInSide:(id)sender {
    if (_btnShuffle.selected) {
        _btnShuffle.selected = NO;
        [_btnShuffle setImage:[UIImage imageNamed:kImageShuffleButtonOFF] forState:UIControlStateNormal];
    } else {
        _btnShuffle.selected = YES;
        [_btnShuffle setImage:[[UIImage imageNamed:kImageShuffleButtonON] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _btnShuffle.tintColor = kDefaultBlueColor;
    }
}

- (IBAction)btnPullDownTouchUpInSide:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)sliderRunValueChanged:(id)sender {
    CGFloat currentTime = CMTimeGetSeconds(_nowPlayerItem.duration) * (_sliderRun.value - _sliderRun.minimumValue) / (_sliderRun.maximumValue - _sliderRun.minimumValue);
    [_avPlayer seekToTime:CMTimeMakeWithSeconds(currentTime, 1.0f)];
}

- (IBAction)sliderRunTouchDown:(id)sender {
    [_btnPlay setImage:[[UIImage imageNamed:kImageButtonPlay] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPlay.tintColor = kDefaultBlueColor;
    [_avPlayer pause];
}

- (IBAction)sliderRunTouchUpInside:(id)sender {
    [_btnPlay setImage:[[UIImage imageNamed:kImageButtonPause] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnPlay.tintColor = kDefaultBlueColor;
    [_avPlayer play];
}


@end
