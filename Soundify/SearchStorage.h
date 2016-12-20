//
//  SearchStorage.h
//  Soundify
//
//  Created by Quang Dai on 10/14/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <Realm/Realm.h>
#import "Common.h"
#import "Constant.h"

@interface SearchStorage : RLMObject

@property NSInteger trackId;
@property NSString *title;
@property NSString *artist;
@property NSString *artworkUrl;
@property NSString *streamUrl;
@property NSInteger duration;
@property NSInteger score;
@property NSDate *createdDate;
@property BOOL loadMore;

+ (void) createSearchStorageWithDictionaryData: (NSDictionary *) dictionaryData;

+ (void) loadMoreSearchStorageWithDictionaryData: (NSDictionary *) dictionaryData
                                        loadMore: (BOOL) loadMore;

+ (void) deleteAllSearchResult;

+ (void) deleteLoadMore;

@end
