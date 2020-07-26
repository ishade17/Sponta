//
//  ExploreTripsViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/25/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "ExploreTripsViewController.h"
#import "ExploreTripsCell.h"
#import "Post.h"

@interface ExploreTripsViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ExploreTripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 530;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ExploreTripsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExploreTripsCell"];
    Post *post = self.postsArray[indexPath.row];
    
    cell.tripTitleLabel.text = post.title;
    cell.usernameLabel.text = post.author.username;
    cell.profilePicImageView.layer.cornerRadius = cell.profilePicImageView.frame.size.height /2;
    [cell.profilePicImageView.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [cell.profilePicImageView.layer setBorderWidth: 1.0];
    NSArray *daysOfWeek = @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:post.tripDate];
    cell.timeDateLabel.text = [NSString stringWithFormat:@"%@ – %@ on %@", post.startTime, post.endTime, [daysOfWeek objectAtIndex:weekday]];
    cell.addressLabel.text = post.address;
    cell.descriptionLabel.text = post.tripDescription;
    cell.spotsFilledLabel.text = [NSString stringWithFormat:@"Spots filled: %lu / %@", (unsigned long)post.guestList.count, post.spots];
    [post.previewImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        cell.previewImageView.image = [UIImage imageWithData:data];
    }];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
