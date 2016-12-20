//
//  ViewController.m
//  Soundify
//
//  Created by Quang Dai on 9/28/16.
//  Copyright © 2016 Quang Dai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tblGenre.delegate = self;
    _tblGenre.dataSource = self;
    _tblGenre.tableFooterView = [[UIView alloc] init];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Genres"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GenreCell *genreCell = [tableView dequeueReusableCellWithIdentifier:@"GenreCell"];
    if (!genreCell) {
        genreCell = [[NSBundle mainBundle] loadNibNamed:@"GenreCell" owner:nil options:nil].firstObject;
        
        genreCell.imvGenre.image = [UIImage imageNamed:@"placeholder"];
        genreCell.lblGenre.text = [NSString stringWithFormat:@"Genre %ld", indexPath.row];
    }
    [genreCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return genreCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ListSongViewController *listSongVC = [[ListSongViewController alloc] init];
    listSongVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ListSongViewController"];
    [[self navigationController] pushViewController:listSongVC animated:YES];
    GenreCell *genreCell = [tableView dequeueReusableCellWithIdentifier:@"GenreCell"];
    if (!genreCell) {
        genreCell = [[NSBundle mainBundle] loadNibNamed:@"GenreCell" owner:nil options:nil].firstObject;
        
        genreCell.imvGenre.image = [UIImage imageNamed:@"placeholder"];
        genreCell.lblGenre.text = [NSString stringWithFormat:@"Genre %ld", indexPath.row];
    }
    NSString *title = genreCell.lblGenre.text;
    [listSongVC.navigationItem setTitle:[NSString stringWithFormat:@"%@", title]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
