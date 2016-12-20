//
//  HistoryDB.h
//  Soundify
//
//  Created by Quang Dai on 10/14/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <Realm/Realm.h>

@interface HistoryDB : RLMObject

@property NSInteger trackId;
@property NSString *title;
@property NSString *artist;
@property NSString *artworkUrl;
@property NSString *streamUrl;
@property NSInteger duration;
@property NSInteger score;
@property NSDate *createdDate;


+ (void) createHistoryDbWithTrackId: (NSInteger) trackId
                              title: (NSString *) title
                             artist: (NSString *) artist
                         artworkUrl: (NSString *) artworkUrl
                          streamUrl: (NSString *) streamUrl
                           duration: (NSInteger) duration
                              score: (NSInteger) score
                        createdDate: (NSDate *) createdDate;

+ (void) updateHistoryDbWithTrackId: (NSInteger) trackId
                              title: (NSString *) title
                             artist: (NSString *) artist
                         artworkUrl: (NSString *) artworkUrl
                          streamUrl: (NSString *) streamUrl
                           duration: (NSInteger) duration
                              score: (NSInteger) score
                        createdDate: (NSDate *) createdDate;

+ (void) deleteAllHistory;

+ (void) deleteTrackHistoryWithTrackId: (NSInteger) trackId;
@end
