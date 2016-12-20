//
//  Common.m
//  Soundify
//
//  Created by Quang Dai on 10/3/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (NSString *)abbreviateNumber:(int)num {
    
    NSString *abbrevNum;
    float number = (float)num;
    
    //Prevent numbers smaller than 1000 to return NULL
    if (num >= 1000) {
        NSArray *abbrev = @[@"K", @"M", @"B"];
        
        for (int i = (int) abbrev.count-1; i >= 0; i--) {
            
            // Convert array index to "1000", "1000000", etc
            int size = pow(10,(i+1)*3);
            
            if(size <= number) {
                // Removed the round and dec to make sure small numbers are included like: 1.1K instead of 1K
                number = number/size;
                NSString *numberString = [self floatToString:number];
                
                // Add the letter for the abbreviation
                abbrevNum = [NSString stringWithFormat:@"%@%@", numberString, [abbrev objectAtIndex:i]];
            }
            
        }
    } else {
        
        // Numbers like: 999 returns 999 instead of NULL
        abbrevNum = [NSString stringWithFormat:@"%d", (int)number];
    }
    
    return abbrevNum;
}

+ (NSString *) floatToString:(float) val {
    NSString *ret = [NSString stringWithFormat:@"%.1f", val];
    unichar c = [ret characterAtIndex:[ret length] - 1];
    
    while (c == 48) { // 0
        ret = [ret substringToIndex:[ret length] - 1];
        c = [ret characterAtIndex:[ret length] - 1];
        
        //After finding the "." we know that everything left is the decimal number, so get a substring excluding the "."
        if(c == 46) { // .
            ret = [ret substringToIndex:[ret length] - 1];
        }
    }
    
    return ret;
}

+ (BOOL) isInternetConnected {
    Reachability *netReachability = [Reachability reachabilityWithHostName: @"www.google.com"];
    NetworkStatus hostStatus = [netReachability currentReachabilityStatus];
    BOOL netConnection = NO;
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"Access Not Available");
            netConnection = NO;
            break;
        }
        case ReachableViaWWAN:
        {
            netConnection = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            netConnection = YES;
            break;
        }
    }
    return netConnection;
}

+ (NSString *) timeFormatted:(int) totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    } else {
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
}

+ (NSString *) convertUrlOfTrack:(NSString *) artWorkUrl {
    NSString *resultArtWorkUrl = [artWorkUrl stringByReplacingOccurrencesOfString:@"large" withString:@"t250x250"];
    return resultArtWorkUrl;
}

+ (NSString *) revertUrlOfTrack:(NSString *) artWorkUrl {
    NSString *resultArtWorkUrl = [artWorkUrl stringByReplacingOccurrencesOfString:@"t250x250" withString:@"large"];
    return resultArtWorkUrl;
}

+ (NSInteger) intDataFromDbResults:(NSObject *) resultDb value:(NSString *) value indexAt:(NSUInteger) index {
    NSArray *array = [resultDb valueForKey:value];
    NSString *string = [NSString stringWithFormat:@"%@", [array objectAtIndex:index]];
    NSInteger integer = [string integerValue];
    return integer;
}

+ (NSString *) strDataFromDbResults:(NSObject *) resultDb value:(NSString *) value indexAt:(NSUInteger) index {
    NSArray *array = [resultDb valueForKey:value];
    NSString *string = [NSString stringWithFormat:@"%@", [array objectAtIndex:index]];
    return string;
}

@end
