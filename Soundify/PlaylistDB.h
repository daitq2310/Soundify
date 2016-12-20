//
//  PlaylistDB.h
//  Soundify
//
//  Created by Quang Dai on 10/6/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <Realm/Realm.h>

@interface PlaylistDB : RLMObject

@property NSString *playlistLocation;
@property NSString *playlistName;
@property NSDate *createdDate;

+ (NSString *) primaryKey;
+ (void) createDbWithPlaylistName: (NSString *) playlistName;
+ (void) removePlaylistWithPlaylistName: (NSString *) playlistName;
+ (void) editPlaylistNameWithPlaylistName: (NSString *) playlistName;

@end
