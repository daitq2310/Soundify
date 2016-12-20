//
//  SearchStorage.m
//  Soundify
//
//  Created by Quang Dai on 10/14/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "SearchStorage.h"

@implementation SearchStorage

+ (NSString *) primaryKey {
    return @"trackId";
}

+ (void) createSearchStorageWithDictionaryData: (NSDictionary *) dictionaryData
{
    RLMRealm *realmInsert = [RLMRealm defaultRealm];
    @try {
        [realmInsert beginWriteTransaction];
        SearchStorage *information = [[SearchStorage alloc] init];
        
        NSString *strId = dictionaryData[@"id"];
        
        NSString *strTitle = dictionaryData[@"title"];
        
        NSString *strArtist = dictionaryData[@"user"][@"username"];
        
        NSString *strArtwork = dictionaryData[@"artwork_url"];
        
        NSString *strStream = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
        
        NSString *strDuration = dictionaryData[@"duration"];
        NSInteger intDuration = [strDuration integerValue];
        
        NSString *strScore = [NSString stringWithFormat:@"%@", dictionaryData[@"playback_count"]];
        NSInteger intScore = [strScore integerValue];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyy HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *createdDate = [dateFormatter dateFromString:strDate];
      
        information.trackId = [strId integerValue];
        information.title = strTitle;
        information.artist = strArtist;
        information.artworkUrl = strArtwork;
        information.streamUrl = strStream;
        information.duration = intDuration;
        information.score = intScore;
        information.createdDate = createdDate;
        
        [realmInsert addObject:information];
        
        NSInteger primaryKey = information.trackId;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [SearchStorage objectForPrimaryKey:@(primaryKey)];
        });
        
    } @catch (NSException *exception) {
        
    }
    
    
    [realmInsert commitWriteTransaction];
    
}

+ (void) loadMoreSearchStorageWithDictionaryData: (NSDictionary *) dictionaryData
                                        loadMore: (BOOL) loadMore
{
    RLMRealm *realmInsert = [RLMRealm defaultRealm];
    @try {
        [realmInsert beginWriteTransaction];
        SearchStorage *information = [[SearchStorage alloc] init];
        
        NSString *strId = dictionaryData[@"id"];
        
        NSString *strTitle = dictionaryData[@"title"];
        
        NSString *strArtist = dictionaryData[@"user"][@"username"];
        
        NSString *strArtwork = dictionaryData[@"artwork_url"];
        
        NSString *strStream = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
        
        NSString *strDuration = dictionaryData[@"duration"];
        NSInteger intDuration = [strDuration integerValue];
        
        NSString *strScore = [NSString stringWithFormat:@"%@", dictionaryData[@"playback_count"]];
        NSInteger intScore = [strScore integerValue];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyy HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *createdDate = [dateFormatter dateFromString:strDate];
        
        information.trackId = [strId integerValue];
        information.title = strTitle;
        information.artist = strArtist;
        information.artworkUrl = strArtwork;
        information.streamUrl = strStream;
        information.duration = intDuration;
        information.score = intScore;
        information.createdDate = createdDate;
        information.loadMore = loadMore;
        
        [realmInsert addObject:information];
        
        NSInteger primaryKey = information.trackId;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [SearchStorage objectForPrimaryKey:@(primaryKey)];
        });
        
    } @catch (NSException *exception) {
        
    }
    
    
    [realmInsert commitWriteTransaction];
}

+ (void) deleteAllSearchResult
{
    RLMRealm *realmDelete = [RLMRealm defaultRealm];
    [realmDelete beginWriteTransaction];
    
    [realmDelete deleteObjects:[SearchStorage allObjects]];
    
    
    [realmDelete commitWriteTransaction];
}

+ (void) deleteLoadMore
{
    RLMRealm *realmDelete = [RLMRealm defaultRealm];
    [realmDelete beginWriteTransaction];
    
    [realmDelete deleteObjects:[SearchStorage objectsWhere:@"loadMore = YES"]];
    
    [realmDelete commitWriteTransaction];
}
@end
