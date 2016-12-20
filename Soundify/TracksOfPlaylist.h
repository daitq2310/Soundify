//
//  TracksOfPlaylist.h
//  Soundify
//
//  Created by Quang Dai on 10/8/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <Realm/Realm.h>

@interface TracksOfPlaylist : RLMObject

@property NSString *trackIdAndPlaylistLocation;
@property NSInteger trackId;
@property NSString *title;
@property NSString *artist;
@property NSString *artworkUrl;
@property NSString *streamUrl;
@property NSInteger duration;
@property NSInteger score;
@property NSDate *addedDate;
@property NSString *playlistName;
@property NSString *playlistLocation;


//Queries
+ (void) createDbWithTrackIdAndPlaylistLocation: (NSString *) trackIdAndPlaylistLocation
                                        trackId: (NSInteger) trackId
                                          title: (NSString *) title
                                         artist: (NSString *) artist
                                     artworkUrl: (NSString *) artworkUrl
                                      streamUrl: (NSString *) streamUrl
                                       duration: (NSInteger) duration
                                          score: (NSInteger) score
                                      addedDate: (NSDate *) addedDate
                                   playlistName: (NSString *) playlistName
                               playlistLocation: (NSString *) playlistLocation;

+ (void) deleteAllTrackOfPlaylistName: (NSString *) playlistName
                     playlistLocation: (NSString *) playlistLocation;

+ (void) deleteTrackOfPlaylistWithTrackId: (NSInteger) trackId
                             playlistName: (NSString *) playlistName
                         playlistLocation: (NSString *) playlistLocation;

@end
