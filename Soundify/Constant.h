//
//  Constant.h
//  Soundify
//
//  Created by Quang Dai on 9/30/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


//SoundCloudAPI
#define kSoundCloudClientID                             @"a453dc1eaf606c2c7c95e263e0c4f385"
#define kSoundCloudGetMusicOfGenre                      @"https://api-v2.soundcloud.com/charts?kind=top&genre=%@"
#define kSoundCloudSuggestion                           @"https://api.soundcloud.com/search/suggest"
#define kSoundCloudSearchTrack                          @"https://api-v2.soundcloud.com/search/tracks"
#define kSoundCloudStream                               @"https://api.soundcloud.com/tracks/%@/stream?client_id=%@"
#define kSoundCloudGenresJsonName                       @"Genres"



#define kSoundCloudOffset                               30
#define kSoundCloudLimitNumber                          50
#define kSoundCloudNumber1                              1
#define kSoundCloudLimitSuggestion                      20



//Color
#define kDefaultBlueColor           [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
#define kLightGreyColor             [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]
#define kGreyColor                  [UIColor colorWithRed:97.0f/255.0f green:97.0f/255.0f blue:97.0f/255.0f alpha:1.0f]




//Image
#define kImagePlaceHolder                               @"placeholder"
#define kImageButtonPlay                                @"play_playing"
#define kImageButtonPause                               @"pause_playing"
#define kImageUser                                      @"user_icon"
#define kImageTrack                                     @"track_icon"
#define kImageCreatePlaylist                            @"add_playlist_icon"
#define kImageDelete                                    @"delete_icon"


//Button
#define kAddButton                                      @"Add to Playlist"
#define kCancelButton                                   @"Cancel"
#define kDeleteButton                                   @"Delete History"
#define kRemoveButton                                   @"Remove"
#define kReviewAppButton                                @"Review App"
#define kShareAppButton                                 @"Share App"
#define kContactSupportButton                           @"Contact Support"




//Title
#define kSoundCloudGenreTitle                           @"Genres"
#define kSoundCloudSearchTitle                          @"Search"
#define kSoundCloudHistoryTitle                         @"History"
#define kSoundCloudPlaylistTitle                        @"Playlist"
#define kSoundCloudMoreTitle                            @"More"
#define kSoundCloudAddToPlaylistTitle                   @"Add to Playlist"



//AppDelegate
#define APPDELEGATE                                     ((AppDelegate *)[UIApplication sharedApplication].delegate)
#endif /* Constant_h */
