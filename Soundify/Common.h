//
//  Common.h
//  Soundify
//
//  Created by Quang Dai on 10/3/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability.h>
#import "Constant.h"
#import <UIKit/UIKit.h>

@interface Common : NSObject

//Convert Big Number
+ (NSString *) abbreviateNumber:(int) num;
+ (NSString *) floatToString:(float) val;


//Check internet connection
+ (BOOL) isInternetConnected;


//Convert milisecond
+ (NSString *) timeFormatted:(int) totalSeconds;


//Convert URL
+ (NSString *) convertUrlOfTrack:(NSString *) artWorkUrl;
+ (NSString *) revertUrlOfTrack:(NSString *) artWorkUrl;

//Data from Database
+ (NSInteger) intDataFromDbResults:(NSObject *) resultDb value:(NSString *) value indexAt:(NSUInteger) index;
+ (NSString *) strDataFromDbResults:(NSObject *) resultDb value:(NSString *) value indexAt:(NSUInteger) index;


@end
