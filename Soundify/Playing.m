//
//  Playing.m
//  Soundify
//
//  Created by Quang Dai on 10/31/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "Playing.h"

@implementation Playing

- (instancetype) initWithResultDb: (NSObject *) resultDb atIndex: (NSInteger) index {
    self = [self init];
    
    if (self) {
        
        NSString *strId = [Common strDataFromDbResults:resultDb value:@"trackId" indexAt:index];
        
        _trackId = [Common intDataFromDbResults:resultDb value:@"trackId" indexAt:index];
        
        _title = [Common strDataFromDbResults:resultDb value:@"title" indexAt:index];
        
        _artist = [Common strDataFromDbResults:resultDb value:@"artist" indexAt:index];
        
        NSString *strArtwork = [Common strDataFromDbResults:resultDb value:@"artworkUrl" indexAt:index];
        _artworkUrl = [Common convertUrlOfTrack:strArtwork];
        
        _streamUrl = [NSString stringWithFormat:kSoundCloudStream, strId, kSoundCloudClientID];
        
        _duration = [Common intDataFromDbResults:resultDb value:@"duration" indexAt:index];
        
        _score = [Common intDataFromDbResults:resultDb value:@"score" indexAt:index];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyy HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *createdDate = [dateFormatter dateFromString:strDate];
        _createdDate = createdDate;
    }
    
    return self;
}
@end
