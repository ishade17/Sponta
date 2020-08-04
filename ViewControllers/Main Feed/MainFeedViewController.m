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
    self.mainFeedTableView.rowHeight = 425;
    
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
    
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
//   [dateFormatter stringFromDate:[NSDate date]];
    
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
    
    // if current date/time is after trip date/time then return
    
    cell.post = postInfo;
    
    cell.profilePicImage.file = [postInfo.author objectForKey:@"profileImage"];
    [cell.profilePicImage loadInBackground];
    cell.profilePicImage.layer.cornerRadius = cell.profilePicImage.frame.size.height / 2;
    [cell.profilePicImage.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [cell.profilePicImage.layer setBorderWidth: 1.0];
    
    cell.tripTitleLabel.text = postInfo.title;
    cell.usernameLabel.text = postInfo.author.username;
    cell.usernameLabel.textColor = [UIColor blueColor];
    
    if (postInfo.likedList.count == 1) {
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%lu Bookmark", (unsigned long)postInfo.likedList.count];
    } else {
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%lu Bookmarks", (unsigned long)postInfo.likedList.count];
    }
    
    cell.previewImage.file = postInfo[@"previewImage"];
    [cell.previewImage loadInBackground];
    
    if (postInfo.publicTrip) {
        cell.publicTag.text = @"Public";
        cell.publicTag.layer.borderColor = [[UIColor blueColor] CGColor];
        cell.publicTag.textColor = [UIColor blueColor];
        cell.publicTag.layer.borderWidth = 0.5f;
        cell.publicTag.layer.cornerRadius = 8;
    } else {
        cell.publicTag.text = @"";
        cell.publicTag.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    
    // check if current user has bookmarked this post
    cell.likeButton.tintColor = [UIColor blueColor];
    for (PFUser *user in postInfo.likedList) {
        if ([user.objectId isEqual:PFUser.currentUser.objectId]) {
            cell.likeButton.tintColor = [UIColor greenColor];
        }
    }
    
    [cell.spotsFilledIcon setBackgroundImage:[UIImage systemImageNamed:@"person.3"] forState:UIControlStateNormal];
    cell.spotsFilledIcon.tintColor = [UIColor blueColor];
    cell.spotsFilledLabel.textColor = [UIColor blueColor];
    
    for (PFUser *guest in postInfo.guestList) { //create util
        if ([guest.objectId isEqual:PFUser.currentUser.objectId]) {
            [cell.spotsFilledIcon setBackgroundImage:[UIImage systemImageNamed:@"person.3.fill"] forState:UIControlStateNormal];
            cell.spotsFilledIcon.tintColor = [UIColor greenColor];
            cell.spotsFilledLabel.textColor = [UIColor greenColor];
        }
    }
        
    NSArray *daysOfWeek = @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:postInfo.tripDate];
    
    cell.tripStartLabel.text = [NSString stringWithFormat:@"%@ on %@", postInfo.startTime, [daysOfWeek objectAtIndex:weekday]];
    cell.spotsFilledLabel.text = [NSString stringWithFormat:@"%lu / %@", (unsigned long)postInfo.guestList.count, postInfo.spots];
        
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
