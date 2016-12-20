//
//  Suggestion.h
//  Soundify
//
//  Created by Quang Dai on 10/23/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Suggestion : NSObject

@property NSString *query;
@property NSString *kind;
@property NSInteger soundCloudId;
@property NSInteger score;

- (instancetype) initWithJsonDict: (NSDictionary *) jsonDictionary;


@end
