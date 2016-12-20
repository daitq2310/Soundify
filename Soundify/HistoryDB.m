//
//  HistoryDB.m
//  Soundify
//
//  Created by Quang Dai on 10/14/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "HistoryDB.h"

@implementation HistoryDB

+ (NSString *)primaryKey {
    return @"trackId";
}

+ (void) createHistoryDbWithTrackId: (NSInteger) trackId
                              title: (NSString *) title
                             artist: (NSString *) artist
                         artworkUrl: (NSString *) artworkUrl
                          streamUrl: (NSString *) streamUrl
                           duration: (NSInteger) duration
                              score: (NSInteger) score
                        createdDate: (NSDate *) createdDate
{
    RLMRealm *realmInsert = [RLMRealm defaultRealm];
        @try {
            [realmInsert beginWriteTransaction];
            HistoryDB *information = [[HistoryDB alloc] init];
            information.trackId = trackId;
            information.title = title;
            information.artist = artist;
            information.artworkUrl = artworkUrl;
            information.streamUrl = streamUrl;
            information.duration = duration;
            information.score = score;
            information.createdDate = createdDate;
    
            [realmInsert addObject:information];
    
            NSInteger primaryKey = information.trackId;
    
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [HistoryDB objectForPrimaryKey:@(primaryKey)];
            });
    
        } @catch (NSException *exception) {
            
        }
    
        [realmInsert commitWriteTransaction];
}

+ (void) updateHistoryDbWithTrackId: (NSInteger) trackId
                              title: (NSString *) title
                             artist: (NSString *) artist
                         artworkUrl: (NSString *) artworkUrl
                          streamUrl: (NSString *) streamUrl
                           duration: (NSInteger) duration
                              score: (NSInteger) score
                        createdDate: (NSDate *) createdDate
{
    RLMRealm *realmUpdate = [RLMRealm defaultRealm];
        [realmUpdate beginWriteTransaction];
    
        [self createOrUpdateInRealm:realmUpdate withValue:@{@"trackId" : @(trackId),
                                                            @"title" : title,
                                                            @"artist" : artist,
                                                            @"artworkUrl" : artworkUrl,
                                                            @"streamUrl" : streamUrl,
                                                            @"duration" : @(duration),
                                                            @"score" : @(score),
                                                            @"createdDate" : createdDate}];
    
        [realmUpdate commitWriteTransaction];
}

+ (void) deleteAllHistory {
    RLMRealm *realmDelete = [RLMRealm defaultRealm];
    
    [realmDelete beginWriteTransaction];
    
    [realmDelete deleteObjects:[HistoryDB allObjects]];
    
    [realmDelete commitWriteTransaction];
}

+ (void) deleteTrackHistoryWithTrackId: (NSInteger) trackId {
    RLMRealm *realmDelete = [RLMRealm defaultRealm];
    
    [realmDelete beginWriteTransaction];
    
    [realmDelete deleteObjects:[HistoryDB objectsWithPredicate:[NSPredicate predicateWithFormat:@"trackId == %ld", trackId]]];
    
    [realmDelete commitWriteTransaction];
}

@end
