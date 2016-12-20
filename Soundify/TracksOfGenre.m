//
//  TracksOfGenre.m
//  Soundify
//
//  Created by Quang Dai on 10/4/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "TracksOfGenre.h"

@implementation TracksOfGenre
+ (NSString *) primaryKey {
    return @"trackIdAndGenreName";
}

+ (void) createTrackDbWithDictionaryData: (NSDictionary *) dictionaryData
                         DictionaryScore: (NSDictionary *) dictionaryScore
                               genreName: (NSString *) genreName
{
    RLMRealm *realmInsert = [RLMRealm defaultRealm];
    @try {
        [realmInsert beginWriteTransaction];
        TracksOfGenre *information = [[TracksOfGenre alloc] init];
        
        NSString *strId = dictionaryData[@"id"];
        
        NSString *strTitle = dictionaryData[@"title"];
        
        NSString *strArtist = dictionaryData[@"user"][@"username"];
        
        NSString *strArtwork = dictionaryData[@"artwork_url"];
        
        NSString *strStream = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
        
        NSString *strDuration = dictionaryData[@"duration"];
        NSInteger intDuration = [strDuration integerValue];
        
        NSString *strScore = [NSString stringWithFormat:@"%@", dictionaryScore];
        NSInteger intScore = [strScore integerValue];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyy HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *createdDate = [dateFormatter dateFromString:strDate];
        
        NSString *trackIdAndGenreName = [NSString stringWithFormat:@"%@ %@", strId, genreName];
        
        information.trackIdAndGenreName = trackIdAndGenreName;
        information.trackId = [strId integerValue];
        information.title = strTitle;
        information.artist = strArtist;
        information.artworkUrl = strArtwork;
        information.streamUrl = strStream;
        information.duration = intDuration;
        information.score = intScore;
        information.genreName = genreName;
        information.createdDate = createdDate;
        
        [realmInsert addObject:information];
        
        NSString *primaryKey = information.trackIdAndGenreName;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [TracksOfGenre objectForPrimaryKey:primaryKey];
        });
        
    } @catch (NSException *exception) {
        
    }
    
    
    [realmInsert commitWriteTransaction];
    
}

+ (void) updateTrackDbWithDictionaryData: (NSDictionary *) dictionaryData
                         DictionaryScore: (NSDictionary *) dictionaryScore
                               genreName: (NSString *) genreName
{
    RLMRealm *realmUpdate = [RLMRealm defaultRealm];
    [realmUpdate beginWriteTransaction];
    
    NSString *strId = dictionaryData[@"id"];
    
    NSString *strTitle = dictionaryData[@"title"];
    
    NSString *strArtist = dictionaryData[@"user"][@"username"];
    
    NSString *strArtwork = dictionaryData[@"artwork_url"];
    
    NSString *strStream = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
    
    NSString *strDuration = dictionaryData[@"duration"];
    NSInteger intDuration = [strDuration integerValue];
    
    NSString *strScore = [NSString stringWithFormat:@"%@", dictionaryScore];
    NSInteger intScore = [strScore integerValue];
    
    NSString *trackIdAndGenreName = [NSString stringWithFormat:@"%@ %@", strId, genreName];
    
    [self createOrUpdateInRealm:realmUpdate withValue:@{@"trackIdAndGenreName" : trackIdAndGenreName,
                                                        @"trackId" : @([strId integerValue]),
                                                        @"title" : strTitle,
                                                        @"artist" : strArtist,
                                                        @"artworkUrl" : strArtwork,
                                                        @"streamUrl" : strStream,
                                                        @"duration" : @(intDuration),
                                                        @"score" : @(intScore),
                                                        @"genreName" : genreName}];
    
    [realmUpdate commitWriteTransaction];
}


+ (void) loadMoreTrackDbWithDictionaryData: (NSDictionary *) dictionaryData
                           DictionaryScore: (NSDictionary *) dictionaryScore
                                 genreName: (NSString *) genreName
                                  loadMore: (BOOL) loadMore
{
    RLMRealm *realmInsert = [RLMRealm defaultRealm];
    @try {
        [realmInsert beginWriteTransaction];
        TracksOfGenre *information = [[TracksOfGenre alloc] init];
        
        NSString *strId = dictionaryData[@"id"];
        
        NSString *strTitle = dictionaryData[@"title"];
        
        NSString *strArtist = dictionaryData[@"user"][@"username"];
        
        NSString *strArtwork = dictionaryData[@"artwork_url"];
        
        NSString *strStream = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
        
        NSString *strDuration = dictionaryData[@"duration"];
        NSInteger intDuration = [strDuration integerValue];
        
        NSString *strScore = [NSString stringWithFormat:@"%@", dictionaryScore];
        NSInteger intScore = [strScore integerValue];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyy HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *createdDate = [dateFormatter dateFromString:strDate];
        
        NSString *trackIdAndGenreName = [NSString stringWithFormat:@"%@ %@", strId, genreName];
        
        information.trackIdAndGenreName = trackIdAndGenreName;
        information.trackId = [strId integerValue];
        information.title = strTitle;
        information.artist = strArtist;
        information.artworkUrl = strArtwork;
        information.streamUrl = strStream;
        information.duration = intDuration;
        information.score = intScore;
        information.genreName = genreName;
        information.createdDate = createdDate;
        information.loadMore = loadMore;
        
        [realmInsert addObject:information];
        
        NSString *primaryKey = information.trackIdAndGenreName;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [TracksOfGenre objectForPrimaryKey:primaryKey];
        });
        
    } @catch (NSException *exception) {
        
    }
    
    
    [realmInsert commitWriteTransaction];
}

+ (void) deleteTrackDbWithDictionaryData: (NSDictionary *) dictionaryData
                         DictionaryScore: (NSDictionary *) dictionaryScore
                               genreName: (NSString *) genreName
{
    RLMRealm *realmDelete = [RLMRealm defaultRealm];
    [realmDelete beginWriteTransaction];
    
    NSString *strId = dictionaryData[@"id"];
    
    NSString *trackIdAndGenreName = [NSString stringWithFormat:@"%@ %@", strId, genreName];
    
    [realmDelete deleteObject:[TracksOfGenre objectForPrimaryKey:trackIdAndGenreName]];
    
    
    
    [realmDelete commitWriteTransaction];
}

+ (void) deleLoadMoreTrackDb {
    RLMRealm *realmDelete = [RLMRealm defaultRealm];
    [realmDelete beginWriteTransaction];
    
    [realmDelete deleteObjects:[TracksOfGenre objectsWhere:@"loadMore = YES"]];
    
    [realmDelete commitWriteTransaction];

}




@end
