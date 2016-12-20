//
//  SuggestCell.h
//  Soundify
//
//  Created by Quang Dai on 10/13/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "Constant.h"
#import <UIImageView+WebCache.h>

@interface SuggestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblSuggestResult;
@property (weak, nonatomic) IBOutlet UIImageView *imvSuggestResult;

@end
