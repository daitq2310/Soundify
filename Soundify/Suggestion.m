//
//  Suggestion.m
//  Soundify
//
//  Created by Quang Dai on 10/23/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "Suggestion.h"

@implementation Suggestion

- (instancetype) initWithJsonDict:(NSDictionary *)jsonDictionary;
{
    self = [self init];
    
    if (self) {
        
        NSString *strQuery = jsonDictionary[@"query"];
        strQuery = [strQuery stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
        strQuery = [strQuery stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
        
        _query = strQuery;
        _kind = jsonDictionary[@"kind"];
        _soundCloudId = [jsonDictionary[@"id"] integerValue];
        _score = [jsonDictionary[@"id"] integerValue];
    }
    
    return self;
}


@end
