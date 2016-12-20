//
//  TracksOfGenre.h
//  Soundify
//
//  Created by Quang Dai on 10/4/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <Realm/Realm.h>
#import "Common.h"
#import "Constant.h"

@interface TracksOfGenre : RLMObject

@property NSString *trackIdAndGenreName;
@property NSInteger trackId;
@property NSString *title;
@property NSString *artist;
@property NSString *artworkUrl;
@property NSString *streamUrl;
@property NSInteger duration;
@property NSInteger score;
@property NSString *genreName;
@property NSDate *createdDate;
@property BOOL loadMore;


//Queries
+ (void) createTrackDbWithDictionaryData: (NSDictionary *) dictionaryData
                         DictionaryScore: (NSDictionary *) dictionaryScore
                               genreName: (NSString *) genreName;

+ (void) updateTrackDbWithDictionaryData: (NSDictionary *) dictionaryData
                         DictionaryScore: (NSDictionary *) dictionaryScore
                               genreName: (NSString *) genreName;

+ (void) loadMoreTrackDbWithDictionaryData: (NSDictionary *) dictionaryData
                           DictionaryScore: (NSDictionary *) dictionaryScore
                                 genreName: (NSString *) genreName
                                  loadMore: (BOOL) loadMore;

+ (void) deleteTrackDbWithDictionaryData: (NSDictionary *) dictionaryData
                         DictionaryScore: (NSDictionary *) dictionaryScore
                               genreName: (NSString *) genreName;

+ (void) deleLoadMoreTrackDb;


@end
