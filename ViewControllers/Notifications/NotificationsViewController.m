//
//  NotificationsViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/30/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationCell.h"
#import "Notifications.h"
#import "PFImageView.h"
#import <Parse/Parse.h>
#import "DetailsViewController.h"

@interface NotificationsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *notifsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchNotifications) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.tableView.rowHeight = 75;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchNotifications];
}

- (void)fetchNotifications {
    PFQuery *query = [PFQuery queryWithClassName:@"Notifications"];
    [query includeKey:@"receiverUser"];
    [query includeKey:@"triggerUser"];
    [query includeKey:@"type"];
    [query includeKey:@"targetPost"];
    [query whereKey:@"receiverUser" equalTo:PFUser.currentUser];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable notifs, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.notifsArray = (NSMutableArray *)notifs;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NotificationCell *notifCell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    Notifications *notif = self.notifsArray[indexPath.row];
    
    notifCell.triggerUserLabel.text = [NSString stringWithFormat:@"%@", notif.triggerUser[@"username"]];
    
    [self configureProfilePic:notifCell withNotif:notif];
    [self configureTargetPost:notifCell withNotif:notif];
    [self configureType:notifCell withNotif:notif];
    
    return notifCell;
}

- (void)configureProfilePic:(NotificationCell *)notifCell withNotif:(Notifications *)notif {
    notifCell.profilePic.file = [notif.triggerUser objectForKey:@"profileImage"];
    [notifCell.profilePic loadInBackground];
    notifCell.profilePic.layer.cornerRadius = notifCell.profilePic.frame.size.height / 2;
    [notifCell.profilePic.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [notifCell.profilePic.layer setBorderWidth: 1.0];
}

- (void)configureTargetPost:(NotificationCell *)notifCell withNotif:(Notifications *)notif {
    notifCell.post = notif.targetPost;
    notifCell.targetPostPreviewImage.file = notif.targetPost.previewImage;
    [notifCell.targetPostPreviewImage loadInBackground];
}

- (void)configureType:(NotificationCell *)notifCell withNotif:(Notifications *)notif {
    if ([notif.type isEqualToString:@"join"]) {
        notifCell.notifTypeLabel.text = @"joined your trip!";
    } else if ([notif.type isEqualToString:@"left"]) {
        notifCell.notifTypeLabel.text = @"left your trip!";
    } else if ([notif.type isEqualToString:@"comment"]) {
        notifCell.notifTypeLabel.text = @"commented on your trip!";
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notifsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toDetailsFromNotif" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"toDetailsFromNotif"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Notifications *notif = self.notifsArray[indexPath.row];
        Post *post = notif.targetPost;
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}



@end
