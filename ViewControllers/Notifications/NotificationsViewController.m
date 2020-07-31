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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchNotifications];
}

- (void)fetchNotifications {
    PFQuery *query = [PFQuery queryWithClassName:@"Notifications"];
    [query includeKey:@"receiverUser"];
    [query whereKey:@"receiverUser" equalTo:PFUser.currentUser];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable notifs, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.notifsArray = (NSMutableArray *)notifs;
            //[self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NotificationCell *notifCell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    Notifications *notif = self.notifsArray[indexPath.row];
    
    notifCell.triggerUserLabel.text = [NSString stringWithFormat:@"%@", notif.triggerUser];
    notifCell.profilePic.file = [notif.triggerUser objectForKey:@"profileImage"];
    [notifCell.profilePic loadInBackground];
    notifCell.post = notif.targetPost;
    
    if ([notif.type isEqualToString:@"joined"]) {
        notifCell.notifTypeLabel.text = @"joined your trip!";
    } else if ([notif.type isEqualToString:@"left"]) {
        notifCell.notifTypeLabel.text = @"left your trip!";
    } else if ([notif.type isEqualToString:@"commented"]) {
        notifCell.notifTypeLabel.text = @"commented on your trip!";
    }
    
    return notifCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notifsArray.count;
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
