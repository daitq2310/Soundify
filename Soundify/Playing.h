//
//  Playing.h
//  Soundify
//
//  Created by Quang Dai on 10/31/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Constant.h"

@interface Playing : NSObject

@property NSInteger trackId;
@property NSString *title;
@property NSString *artist;
@property NSString *artworkUrl;
@property NSString *streamUrl;
@property NSInteger duration;
@property NSInteger score;
@property NSDate *createdDate;

- (instancetype) initWithResultDb: (NSObject *) resultDb atIndex: (NSInteger) index;
@end
