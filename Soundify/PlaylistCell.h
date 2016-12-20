//
//  PlaylistCell.h
//  Soundify
//
//  Created by Quang Dai on 9/29/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imvPlaylist;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaylistName;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfTracks;

@end
