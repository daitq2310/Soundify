//
//  MoreViewController.m
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreCell.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tblMore.delegate = self;
    _tblMore.dataSource = self;
    _tblMore.tableFooterView = [[UIView alloc] init];
    [self.navigationItem setTitle:[NSString stringWithFormat:kSoundCloudMoreTitle]];
    _playingVC = [PlayingViewController shareInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [self showButtonPlaying];
}


- (void) showButtonPlaying {
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    if (_playingVC.isPlaying == YES) {
        for (int i = 1; i < 33; i++) {
            [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d", i]]];
        }
        
        UIImage *imageAnimation = [UIImage animatedImageWithImages:imageArray duration:2.0f];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:imageAnimation style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTouchUpInside:)];
        
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}

- (IBAction) rightBarButtonTouchUpInside:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [_playingVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:_playingVC animated:NO];
}






#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
    if (!moreCell) {
        moreCell = [[NSBundle mainBundle] loadNibNamed:@"MoreCell" owner:nil options:nil].firstObject;
        if (indexPath.row % 3 == 0) {
            moreCell.imvIcon.image = [UIImage imageNamed:@"review_icon"];
            moreCell.imvIcon.image = [moreCell.imvIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [moreCell.imvIcon setTintColor:kDefaultBlueColor];
            moreCell.lblIconName.text = [NSString stringWithFormat:kReviewAppButton];
        }
        if (indexPath.row % 3 == 1) {
            moreCell.imvIcon.image = [UIImage imageNamed:@"share_icon"];
            moreCell.imvIcon.image = [moreCell.imvIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [moreCell.imvIcon setTintColor:kDefaultBlueColor];
            moreCell.lblIconName.text = [NSString stringWithFormat:kShareAppButton];
        }
        if (indexPath.row % 3 == 2) {
            moreCell.imvIcon.image = [UIImage imageNamed:@"contact_icon"];
            moreCell.imvIcon.image = [moreCell.imvIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [moreCell.imvIcon setTintColor:kDefaultBlueColor];
            moreCell.lblIconName.text = [NSString stringWithFormat:kContactSupportButton];
        }
    }
    
    return moreCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row % 3 == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id336353151"]];
    }
    if (indexPath.row % 3 == 1) {
        NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
        NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
        
        NSArray *objectsToShare = @[textToShare, myWebsite];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        
        NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                       UIActivityTypePrint,
                                       UIActivityTypePostToFacebook,
                                       UIActivityTypeMail,
                                       UIActivityTypeMessage,
                                       UIActivityTypeAssignToContact,
                                       UIActivityTypeSaveToCameraRoll,
                                       UIActivityTypeAddToReadingList,
                                       UIActivityTypePostToFlickr,
                                       UIActivityTypePostToVimeo];
        
        activityVC.excludedActivityTypes = excludeActivities;
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    if (indexPath.row % 3 == 2) {
        NSString *emailTitle = @"Test Email";
        NSString *messageBody = @"Soundify";
        NSArray *toRecipents = [NSArray arrayWithObject:@"quangdai.trinh@gmail.com"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        [self presentViewController:mc animated:YES completion:NULL];
    }

    [_tblMore deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (IBAction)showEmail:(id)sender {
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
