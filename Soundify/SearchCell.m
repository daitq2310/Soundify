//
//  SearchCell.m
//  Soundify
//
//  Created by Quang Dai on 10/14/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) displayTrackFromDbResult: (NSObject *) resultDb
                            index: (NSUInteger) index
{
    NSString *strArtwork = [Common strDataFromDbResults:resultDb value:@"artworkUrl" indexAt:index];
    NSURL *artworkUrl = [NSURL URLWithString:strArtwork];
    
    NSString *strTitle = [Common strDataFromDbResults:resultDb value:@"title" indexAt:index];
    
    NSString *strArtist = [Common strDataFromDbResults:resultDb value:@"artist" indexAt:index];
    
    NSInteger intScore = [Common intDataFromDbResults:resultDb value:@"score" indexAt:index];
    
    NSInteger intDuration = [Common intDataFromDbResults:resultDb value:@"duration" indexAt:index];
    int duration = (int) intDuration / 1000;
    
    @try {
        [_imvTrack sd_setImageWithURL:artworkUrl placeholderImage:[UIImage imageNamed:kImagePlaceHolder]];
    } @catch (NSException *exception) {
        _imvTrack.image = [UIImage imageNamed:kImagePlaceHolder];
    }
    
    _lblTitle.text = strTitle;
    _lblArtist.text = strArtist;
    _lblScore.text = [Common abbreviateNumber:(int) intScore];
    
    NSString *strDuration = [Common timeFormatted:(int) duration];
    _lblDuration.text = strDuration;
    _lblDuration.layer.cornerRadius = 2.0f;
    _lblDuration.layer.masksToBounds = TRUE;
    CGFloat lblTextWidth = [_lblDuration.text sizeWithAttributes:@{NSFontAttributeName: _lblDuration.font}].width;
    [_lblDuration addConstraint:[NSLayoutConstraint constraintWithItem:_lblDuration
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute: NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:lblTextWidth + 5]];
    
    [_btnMore addTarget:self action:@selector(btnMoreTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_btnMore setImage:[[UIImage imageNamed:@"button_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _btnMore.tintColor = kDefaultBlueColor;
    _btnMore.tag = index;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *backgroundColor = _lblDuration.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    _lblDuration.backgroundColor = backgroundColor;
}

- (IBAction)btnMoreTouchUpInside:(id)sender {
}

@end
