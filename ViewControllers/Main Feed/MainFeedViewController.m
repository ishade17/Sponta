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
#import "NonCurrentProfileViewController.h"

@interface MainFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *postsArray;
@property (weak, nonatomic) IBOutlet UITableView *mainFeedTableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSSet *friendsList;

@end

@implementation MainFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainFeedTableView.dataSource = self;
    self.mainFeedTableView.delegate = self;
    self.mainFeedTableView.rowHeight = 430;
    self.mainFeedTableView.layoutMargins = UIEdgeInsetsZero;
    self.mainFeedTableView.separatorInset = UIEdgeInsetsZero;

    [self fetchFriendsList];
        
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchFeed) forControlEvents:UIControlEventValueChanged];
    [self.mainFeedTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchFriendsList {
    PFQuery *query = [PFQuery queryWithClassName:@"FriendsList"];
    [query includeKey:@"user"];
    [query includeKey:@"friendsList"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable friendsList, NSError * _Nullable error) {
        if (friendsList.count == 1) {
            self.friendsList = (NSSet *)[friendsList[0] objectForKey:@"friendsList"];
            [self fetchFeed];
        } else if (error) {
            NSLog(@"Error retreiving profUser's friendships: %@", error.localizedDescription);
        }
    }];
    
}

- (void)fetchFeed {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];

    self.postsArray = [NSMutableArray new];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            for (Post *post in posts) {
                if ([self.friendsList containsObject:post.author.username] || [post.author.username isEqual:[PFUser currentUser].username]) {
                    //if ([post.tripDate compare:[NSDate date]] == NSOrderedDescending) {
                        [self.postsArray addObject:post];
                    //}
                }
            }
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
    cell.layoutMargins = UIEdgeInsetsZero;
    
    cell.profilePicImage.file = [postInfo.author objectForKey:@"profileImage"];
    [cell.profilePicImage loadInBackground];
    cell.profilePicImage.layer.cornerRadius = cell.profilePicImage.frame.size.height / 2;
    [cell.profilePicImage.layer setBorderColor: [[UIColor systemBlueColor] CGColor]];
    [cell.profilePicImage.layer setBorderWidth: 1.0];
    
    cell.tripTitleLabel.text = postInfo.title;
    [cell.usernameLabel setTitle:postInfo.author.username forState:UIControlStateNormal];
    cell.usernameLabel.tag = indexPath.row;
    cell.usernameLabel.titleLabel.textColor = [UIColor blackColor];
    
    cell.previewImage.file = postInfo[@"previewImage"];
    [cell.previewImage loadInBackground];
    
    if (postInfo.publicTrip) {
        cell.publicTag.text = @"Public";
        cell.publicTag.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.publicTag.textColor = [UIColor blackColor];
        cell.publicTag.layer.borderWidth = 0.5f;
        cell.publicTag.layer.cornerRadius = 8;
    } else {
        cell.publicTag.text = @"";
        cell.publicTag.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    
    // check if current user has bookmarked this post
    [cell.likeButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
    cell.likeButton.tintColor = [UIColor systemGrayColor];
    for (PFUser *user in postInfo.likedList) {
        if ([user.objectId isEqual:PFUser.currentUser.objectId]) {
            [cell.likeButton setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
            cell.likeButton.tintColor = [UIColor systemGrayColor];
        }
    }
    
    [cell.spotsFilledIcon setBackgroundImage:[UIImage systemImageNamed:@"person.3"] forState:UIControlStateNormal];
    cell.spotsFilledIcon.tintColor = [UIColor systemGrayColor];
    cell.spotsFilledLabel.textColor = [UIColor systemGrayColor];
    
    for (PFUser *guest in postInfo.guestList) { //create util
        if ([guest.objectId isEqual:PFUser.currentUser.objectId]) {
            [cell.spotsFilledIcon setBackgroundImage:[UIImage systemImageNamed:@"person.3.fill"] forState:UIControlStateNormal];
            cell.spotsFilledIcon.tintColor = [UIColor systemBlueColor];
            cell.spotsFilledLabel.textColor = [UIColor systemBlueColor];
        }
    }
    
    // util!
    NSArray *daysOfWeek = @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:postInfo.tripDate];
    cell.tripStartLabel.text = [NSString stringWithFormat:@"%@ on %@", postInfo.startTime, [daysOfWeek objectAtIndex:weekday]];
    int spotsRemaining = postInfo.spots.floatValue - postInfo.guestList.count;
    cell.spotsFilledLabel.text = [NSString stringWithFormat:@"%d Spots Remaining", spotsRemaining];
        
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toDetailsFromMain"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.mainFeedTableView indexPathForCell:tappedCell];
        Post *post = self.postsArray[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    } else if ([segue.identifier isEqualToString:@"toNonCurrentProfileFromMain"]) {
        UIButton *usernameLabel = sender;
        Post *post = self.postsArray[usernameLabel.tag];
        NonCurrentProfileViewController *nonCurrentProfileViewController = [segue destinationViewController];
        nonCurrentProfileViewController.profUser = post.author;
    }
}




@end
