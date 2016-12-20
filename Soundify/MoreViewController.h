//
//  MoreViewController.h
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "Common.h"
#import "PlayingViewController.h"
#import <MessageUI/MessageUI.h>

@interface MoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblMore;

@property PlayingViewController *playingVC;
@end
