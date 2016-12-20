//
//  PlaylistDB.m
//  Soundify
//
//  Created by Quang Dai on 10/6/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "PlaylistDB.h"

@implementation PlaylistDB

+ (NSString *) primaryKey {
    return @"playlistLocation";
}

+ (void)createDbWithPlaylistName:(NSString *)playlistName {
    RLMRealm *realmInsert = [RLMRealm defaultRealm];
    @try {
        [realmInsert beginWriteTransaction];
        PlaylistDB *information = [[PlaylistDB alloc] init];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyy HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *createdDate = [dateFormatter dateFromString:strDate];
        
        information.playlistLocation = [[NSUUID UUID] UUIDString];
        information.playlistName = playlistName;
        information.createdDate = createdDate;
        
        [realmInsert addObject:information];
        
        NSString *primaryKey = information.playlistLocation;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [PlaylistDB objectForPrimaryKey:primaryKey];
        });
        
    } @catch (NSException *exception) {
        
    }
    
    
    [realmInsert commitWriteTransaction];
}

+ (void)removePlaylistWithPlaylistName:(NSString *)playlistName {
    
}

+ (void)editPlaylistNameWithPlaylistName:(NSString *)playlistName {
    RLMRealm *realmUpdate = [RLMRealm defaultRealm];
    [realmUpdate beginWriteTransaction];
    
    [self createOrUpdateInRealm:realmUpdate withValue:@{@"playlistName" : playlistName}];
    
    [realmUpdate commitWriteTransaction];
}
@end
