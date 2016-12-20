//
//  ListSongCell.h
//  Soundify
//
//  Created by Quang Dai on 9/29/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "Constant.h"
#import <UIImageView+WebCache.h>

@interface ListSongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imvSong;
@property (weak, nonatomic) IBOutlet UILabel *lblSongName;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UILabel *lblArtist;

@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UIImageView *imvScore;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;

- (void) displayTrackFromDbResult: (NSObject *) resultDb
                            index: (NSUInteger) index;

@end
