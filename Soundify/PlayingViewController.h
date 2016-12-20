//
//  PlayingViewController.h
//  Soundify
//
//  Created by Quang Dai on 10/1/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "Common.h"
#import "TracksOfGenre.h"
#import "HistoryViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <UIImageView+WebCache.h>
#import <MarqueeLabel.h>
#import "Playing.h"

@interface PlayingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imvArtWork;
@property (weak, nonatomic) IBOutlet UISlider *sliderRun;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayedTime;
@property (weak, nonatomic) IBOutlet UILabel *lblRemainingTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnRepeat;
@property (weak, nonatomic) IBOutlet UIButton *btnShuffle;
@property (weak, nonatomic) IBOutlet UIButton *btnPullDown;


//Action
- (IBAction)sliderRunValueChanged:(id)sender;
- (IBAction)sliderRunTouchDown:(id)sender;
- (IBAction)sliderRunTouchUpInside:(id)sender;

- (IBAction)btnPreviousTouchUpInSide:(id)sender;
- (IBAction)btnPlayTouchUpInSide:(id)sender;
- (IBAction)btnNextTouchUpInSide:(id)sender;
- (IBAction)btnRepeatTouchUpInSide:(id)sender;
- (IBAction)btnShuffleTouchUpInSide:(id)sender;
- (IBAction)btnPullDownTouchUpInSide:(id)sender;


@property AVPlayer *avPlayer;
@property AVPlayerItem *nowPlayerItem;

@property NSString *genreName;
@property NSString *strId;
@property NSString *strArtist;
@property NSString *strTitle;
@property NSString *strArtwork;
@property NSString *strStream;
@property NSString *strRemainingTime;
@property NSInteger intRemainingTime;
@property NSInteger intScore;
@property NSString *strIdPlaying;

@property NSMutableArray *playingArray;
@property NSMutableArray *playingTrackId;
@property NSInteger indexOfTrack;

@property id playbackObserver;

+ (PlayingViewController *)shareInstance;
- (void) playTrackWithTrackId: (NSString *) trackId atIndex: (NSInteger) index;
@property BOOL isPlaying;






@end
