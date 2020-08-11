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
#import "UpcomingTripCell.h"
#import "UpcomingTrip.h"
#import "Post.h"
#import "NonCurrentProfileViewController.h"

@interface NotificationsViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *collectionViewBorder;
@property (nonatomic, strong) NSMutableArray<Notifications *> *notifsArray;
@property (nonatomic, strong) NSMutableArray<UpcomingTrip *> *upcomingTripsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSIndexPath *segueIndexPath;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self configureCollectionView];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchNotifications) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
        
}

- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = self.collectionView.frame.size.width / 1.8;
    CGFloat itemHeight = self.collectionView.frame.size.height * 0.85;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.collectionViewBorder.layer.borderColor = [[UIColor blueColor] CGColor];
    self.collectionViewBorder.layer.borderWidth = 0.5;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchNotifications];
    [self fetchUpcomingTrips];
}

- (void)fetchNotifications {
    PFQuery *query = [PFQuery queryWithClassName:@"Notifications"];
    [query includeKey:@"receiverUser"];
    [query includeKey:@"triggerUser"];
    [query includeKey:@"type"];
    [query includeKey:@"targetPost"];
    [query whereKey:@"receiverUser" equalTo:[PFUser currentUser]];
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

- (void)fetchUpcomingTrips {
    PFQuery *query = [PFQuery queryWithClassName:@"UpcomingTrip"];
    [query includeKey:@"trip"];
    [query includeKey:@"host"];
    [query includeKey:@"guest"];
    [query whereKey:@"guest" equalTo:PFUser.currentUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *upcomingTrips, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.upcomingTripsArray = (NSMutableArray *)upcomingTrips;
            [self.collectionView reloadData];
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
    if (![notif.type isEqualToString:@"friend request"]) {
        notifCell.post = notif.targetPost;
        notifCell.targetPostPreviewImage.file = notif.targetPost.previewImage;
        [notifCell.targetPostPreviewImage loadInBackground];
    } else {
        notifCell.post = notif.targetPost;
        notifCell.targetPostPreviewImage.file = [notif.triggerUser objectForKey:@"profileImage"];
        [notifCell.targetPostPreviewImage loadInBackground];
    }
}

- (void)configureType:(NotificationCell *)notifCell withNotif:(Notifications *)notif {
    if ([notif.type isEqualToString:@"join"]) {
        notifCell.notifTypeLabel.text = @"joined your trip!";
    } else if ([notif.type isEqualToString:@"left"]) {
        notifCell.notifTypeLabel.text = @"left your trip!";
    } else if ([notif.type isEqualToString:@"comment"]) {
        notifCell.notifTypeLabel.text = @"commented on your trip!";
    } else if ([notif.type isEqualToString:@"friend request"]) {
        notifCell.notifTypeLabel.text = @"sent you a friend request!";
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notifsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Notifications *notif = self.notifsArray[indexPath.row];
    self.segueIndexPath = indexPath;
    if (![notif.type isEqualToString:@"friend request"]) {
        [self performSegueWithIdentifier:@"toDetailsFromNotif2" sender:self];
    } else {
        [self performSegueWithIdentifier:@"toProfileFromNotif" sender:self];
    }
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UpcomingTripCell *upcomingTripCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UpcomingTripCell" forIndexPath:indexPath];
    UpcomingTrip *upcomingTrip = self.upcomingTripsArray[indexPath.row];
    
    [self configureUpcomingTripLabels:upcomingTripCell withUpcomingTrip:upcomingTrip];
    [self configureHostProfilePic:upcomingTripCell withUpcomingTrip:upcomingTrip];
    [self configureShadow:upcomingTripCell];
    
    return upcomingTripCell;
}

- (void)configureShadow:(UpcomingTripCell *)upcomingTripCell {
    upcomingTripCell.layer.cornerRadius = 15;
    upcomingTripCell.layer.borderWidth = 0.1;
    upcomingTripCell.layer.borderColor = [UIColor systemBlueColor].CGColor;
    
    upcomingTripCell.contentView.layer.cornerRadius = 20;
    upcomingTripCell.contentView.layer.borderWidth = 1.0f;
    upcomingTripCell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    upcomingTripCell.contentView.layer.masksToBounds = YES;

    upcomingTripCell.layer.backgroundColor = [UIColor whiteColor].CGColor;
    upcomingTripCell.layer.shadowColor = [UIColor systemBlueColor].CGColor;
    upcomingTripCell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    upcomingTripCell.layer.shadowRadius = 5;
    upcomingTripCell.layer.shadowOpacity = 0.25;
    upcomingTripCell.layer.masksToBounds = NO;
    upcomingTripCell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:upcomingTripCell.bounds cornerRadius:upcomingTripCell.contentView.layer.cornerRadius].CGPath;
}

- (void)configureHostProfilePic:(UpcomingTripCell *)upcomingTripCell withUpcomingTrip:(UpcomingTrip *)upcomingTrip {
    upcomingTripCell.hostProfilePic.file = [upcomingTrip.host objectForKey:@"profileImage"];
    [upcomingTripCell.hostProfilePic loadInBackground];
    upcomingTripCell.hostProfilePic.layer.cornerRadius = upcomingTripCell.hostProfilePic.frame.size.height / 2;
    [upcomingTripCell.hostProfilePic.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [upcomingTripCell.hostProfilePic.layer setBorderWidth: 1.0];
}

- (void)configureUpcomingTripLabels:(UpcomingTripCell *)upcomingTripCell withUpcomingTrip:(UpcomingTrip *)upcomingTrip {
    upcomingTripCell.hostNameLabel.text = upcomingTrip.host.username;
    upcomingTripCell.tripNameLabel.text = upcomingTrip.trip.title;
    NSArray *daysOfWeek = @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:upcomingTrip.trip.tripDate];
    upcomingTripCell.tripDateTimeLabel.text = [NSString stringWithFormat:@"%@ on %@", upcomingTrip.trip.startTime, [daysOfWeek objectAtIndex:weekday]];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.upcomingTripsArray.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"toDetailsFromNotif2"]) {
        Notifications *notif = self.notifsArray[self.segueIndexPath.row];
        if ([notif.type isEqualToString:@"friend request"]) return;
        Post *post = notif.targetPost;
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
        
    } else if ([segue.identifier isEqual:@"toDetailsFromUpcoming"]) {
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        
        UpcomingTrip *upcomingTrip = self.upcomingTripsArray[indexPath.row];
        Post *post = upcomingTrip.trip;
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    
    } else if ([segue.identifier isEqual:@"toProfileFromNotif"]) {
        Notifications *notif = self.notifsArray[self.segueIndexPath.row];
        PFUser *profUser = notif.triggerUser;
        
        NonCurrentProfileViewController *nonCurrentProfileViewController = [segue destinationViewController];
        nonCurrentProfileViewController.profUser = profUser;
    }
}



@end
