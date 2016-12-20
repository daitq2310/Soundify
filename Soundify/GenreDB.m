//
//  GenreDB.m
//  Soundify
//
//  Created by Quang Dai on 10/9/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "GenreDB.h"

@implementation GenreDB

+ (NSString *) primaryKey {
    return @"genreName";
}


+ (void) createDbWithJsonDictionary:(NSDictionary *)jsonDictionary
{
    RLMRealm *realmInsert = [RLMRealm defaultRealm];
    @try {
        [realmInsert beginWriteTransaction];
        GenreDB *information = [[GenreDB alloc] init];
        
        information.genreName = jsonDictionary[@"genre"];
        information.genreCode = jsonDictionary[@"code"];
        
        [realmInsert addObject:information];
        
        NSString *primaryKey = information.genreName;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [GenreDB objectForPrimaryKey:primaryKey];
        });
        
    } @catch (NSException *exception) {
        
    }
    
    [realmInsert commitWriteTransaction];
}


@end
