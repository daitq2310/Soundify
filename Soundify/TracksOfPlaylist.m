//
//  TracksOfPlaylist.m
//  Soundify
//
//  Created by Quang Dai on 10/8/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "TracksOfPlaylist.h"

@implementation TracksOfPlaylist

+ (NSString *)primaryKey {
    return @"trackIdAndPlaylistLocation";
}

+ (void) createDbWithTrackIdAndPlaylistLocation: (NSString *) trackIdAndPlaylistLocation
                                        trackId: (NSInteger ) trackId
                                          title: (NSString *) title
                                         artist: (NSString *) artist
                                     artworkUrl: (NSString *) artworkUrl
                                      streamUrl: (NSString *) streamUrl
                                       duration: (NSInteger ) duration
                                          score: (NSInteger ) score
                                      addedDate: (NSDate *) addedDate
                                   playlistName: (NSString *) playlistName
                               playlistLocation: (NSString *) playlistLocation
{
    RLMRealm *realmInsert = [RLMRealm defaultRealm];
    @try {
        [realmInsert beginWriteTransaction];
        TracksOfPlaylist *information = [[TracksOfPlaylist alloc] init];
        
        information.trackIdAndPlaylistLocation = trackIdAndPlaylistLocation;
        information.trackId = trackId;
        information.title = title;
        information.artist = artist;
        information.artworkUrl = artworkUrl;
        information.streamUrl = streamUrl;
        information.duration = duration;
        information.score = score;
        information.addedDate = addedDate;
        information.playlistName = playlistName;
        information.playlistLocation = playlistLocation;
        
        [realmInsert addObject:information];
        
    } @catch (NSException *exception) {
        
    }
    
    
    [realmInsert commitWriteTransaction];
}

+ (void) deleteAllTrackOfPlaylistName: (NSString *) playlistName
                     playlistLocation: (NSString *) playlistLocation {
    RLMRealm *realmDelete = [RLMRealm defaultRealm];
    
    [realmDelete beginWriteTransaction];
    
    [realmDelete deleteObjects:[TracksOfPlaylist objectsWithPredicate:[NSPredicate predicateWithFormat:@"playlistName == %@ AND playlistLocation == %@", playlistName, playlistLocation]]];
    
    [realmDelete commitWriteTransaction];
}

+ (void) deleteTrackOfPlaylistWithTrackId: (NSInteger) trackId
                             playlistName: (NSString *) playlistName
                         playlistLocation: (NSString *) playlistLocation {
    RLMRealm *realmDelete = [RLMRealm defaultRealm];
    
    [realmDelete beginWriteTransaction];
    
    [realmDelete deleteObjects:[TracksOfPlaylist objectsWithPredicate:[NSPredicate predicateWithFormat:@"trackId == %ld AND playlistName == %@ AND playlistLocation == %@", trackId, playlistName, playlistLocation]]];
    
    [realmDelete commitWriteTransaction];
}

@end
