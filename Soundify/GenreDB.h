//
//  GenreDB.h
//  Soundify
//
//  Created by Quang Dai on 10/9/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <Realm/Realm.h>

@interface GenreDB : RLMObject

@property NSString *genreName;
@property NSString *genreCode;

+ (NSString *) primaryKey;

+ (void) createDbWithJsonDictionary : (NSDictionary *) jsonDictionary;

@end
