//
//  MainFeedViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/14/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "MainFeedViewController.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import "SignInViewController.h"
#import "PostCell.h"
#import "Post.h"
#import "DetailsViewController.h"

@interface MainFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *postsArray;
@property (weak, nonatomic) IBOutlet UITableView *mainFeedTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MainFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainFeedTableView.dataSource = self;
    self.mainFeedTableView.delegate = self;
    self.mainFeedTableView.rowHeight = 440;
    
    [self fetchFeed];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchFeed) forControlEvents:UIControlEventValueChanged];
    [self.mainFeedTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchFeed {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.postsArray = (NSMutableArray *)posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.mainFeedTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *postInfo = self.postsArray[indexPath.row];

    cell.post = postInfo;
    cell.profilePicImage.layer.cornerRadius = cell.profilePicImage.frame.size.height /2;
    [cell.profilePicImage.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [cell.profilePicImage.layer setBorderWidth: 1.0];
    cell.tripTitleLabel.text = postInfo.title;
    cell.usernameLabel.text = postInfo.author.username;
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%@ Likes", postInfo.likeCount];
    cell.previewImage.file = postInfo[@"previewImage"];
    [cell.previewImage loadInBackground];
    if (postInfo.publicTrip) {
        cell.publicTag.text = @"Public";
    } else {
        cell.publicTag.text = @"";
    }
    
    NSArray *daysOfWeek = @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:postInfo.tripDate];
    
    cell.tripStartLabel.text = [NSString stringWithFormat:@"%@ on %@", postInfo.startTime, [daysOfWeek objectAtIndex:weekday]];
    //NSLog(@"%@", postInfo.tripDate);
    //NSLog(@"%@", [daysOfWeek objectAtIndex:weekday]);
    cell.spotsFilledLabel.text = [NSString stringWithFormat:@"Spots filled: %lu / %@", (unsigned long)postInfo.guestList.count, postInfo.spots];
        
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.mainFeedTableView indexPathForCell:tappedCell];
    Post *post = self.postsArray[indexPath.row];

    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.post = post;
}




@end
