//
//  DetailsViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 7/20/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "DetailsViewController.h"
#import "CommentCell.h"
#import "Comment.h"
#import <MapKit/MapKit.h>
#import "Post.h"
#import <Parse/Parse.h>
#import "JoinLeaveTrip.h"
#import "Notifications.h"
#import "UpcomingTrip.h"
#import "GuestProfilePicCell.h"

@interface DetailsViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *addGuestButton;
@property (weak, nonatomic) IBOutlet UILabel *tripTitleLabel;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILabel *timePeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAddress;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextField *commentMessageField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *spotsFilledIcon;
@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic, strong) NSMutableArray *guestsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tripTitleLabel.text = self.post.title;
    NSArray *daysOfWeek = @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:self.post.tripDate];
    self.timePeriodLabel.text = [NSString stringWithFormat:@"%@ – %@ on %@", self.post.startTime, self.post.endTime, [daysOfWeek objectAtIndex:weekday]];
    
    NSArray *chunks = [self.post.address componentsSeparatedByString: @", "];
    [(NSMutableArray *)chunks removeObjectAtIndex: chunks.count - 1];
    NSString *addressTitle = [chunks componentsJoinedByString:@", "];
    self.destinationAddress.text = [NSString stringWithFormat:@"%@", addressTitle];
    
    self.descriptionLabel.text = self.post.tripDescription;
    self.spotsCountLabel.text = [NSString stringWithFormat:@"%lu / %@", (unsigned long)self.post.guestList.count, self.post.spots];
    self.spotsCountLabel.textColor = [UIColor blueColor];
    
    self.addGuestButton.titleLabel.textColor = [UIColor whiteColor];
    self.addGuestButton.backgroundColor = [UIColor blueColor];
    [self.addGuestButton setTitle:@"Join Trip" forState:UIControlStateNormal];
    for (PFUser *guest in self.post.guestList) {
        if ([guest.objectId isEqual:PFUser.currentUser.objectId]) {
            self.addGuestButton.backgroundColor = [UIColor greenColor];
            [self.addGuestButton setTitle:@"Leave Trip" forState:UIControlStateNormal];
            [self.spotsFilledIcon setBackgroundImage:[UIImage systemImageNamed:@"person.3.fill"] forState:UIControlStateNormal];
            self.spotsFilledIcon.tintColor = [UIColor greenColor];
            self.spotsCountLabel.textColor = [UIColor greenColor];
        }
    }
    
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self fetchFeeds];
    [self configureCollectionView];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchComments) forControlEvents:UIControlEventValueChanged];
    [self.commentsTableView insertSubview:self.refreshControl atIndex:0];
    
    self.map.delegate = self;
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(self.post.latitude.floatValue, self.post.longitude.floatValue), MKCoordinateSpanMake(0.1, 0.1));
    [self.map setRegion:region animated:false];
        
    // Add map annotation
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.post.latitude.floatValue, self.post.longitude.floatValue);
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    [self.map addAnnotation:annotation];
}

- (void)fetchFeeds {
    [self fetchComments];
    [self fetchGuests];
}

- (void)fetchComments {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Comment"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"post"];
    [postQuery whereKey:@"post" equalTo:self.post];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable comments, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.commentsArray = (NSMutableArray *)comments;
            [self.refreshControl endRefreshing];
            [self.commentsTableView reloadData];
        }
    }];
}

- (void)fetchGuests {
    PFQuery *query = [PFQuery queryWithClassName:@"UpcomingTrip"];
    [query includeKey:@"trip"];
    [query includeKey:@"guest"];
    [query whereKey:@"trip" equalTo:self.post];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *tripGuests, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.guestsArray = (NSMutableArray *)tripGuests;
            [self.collectionView reloadData];
        }
    }];
}

- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = self.collectionView.frame.size.width / 3.4;
    CGFloat itemHeight = self.collectionView.frame.size.height;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    Comment *comment = self.commentsArray[indexPath.row];
    cell.commentLabel.text = comment.caption;
    cell.commentUserLabel.text = comment.author.username;
        
    return cell;
}

- (IBAction)tappedPostComment:(id)sender {
    [Comment postComments:self.commentMessageField.text onPost:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    if (succeeded) {
        self.commentMessageField.text = @"";
        [self fetchComments];
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
    }];
    
    [Notifications sendNotification:[PFUser currentUser] withReceiver:self.post.author withPost:self.post withType:@"comment"];
}

- (void)locationsViewController:(id)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    
    // Add annotation
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = coordinate;
    annotation.title = self.tripTitleLabel.text;
    [self.map addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
    }
    
    return annotationView;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GuestProfilePicCell *guestProfilePicCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GuestProfilePicCell" forIndexPath:indexPath];
    if (indexPath.row < self.guestsArray.count) {
        UpcomingTrip *upcomingTrip = self.guestsArray[indexPath.row];
        
        [self configureGuestProfilePic:guestProfilePicCell withUpcomingTrip:upcomingTrip];
        guestProfilePicCell.guestUsername.text = upcomingTrip.guest.username;
    } else {
        guestProfilePicCell.guestProfilePic.layer.cornerRadius = guestProfilePicCell.guestProfilePic.frame.size.height / 2;
        [guestProfilePicCell.guestProfilePic.layer setBorderColor: [[UIColor blueColor] CGColor]];
        [guestProfilePicCell.guestProfilePic.layer setBorderWidth: 0.5];
        guestProfilePicCell.guestUsername.text = @"Open";
    }
    
    return guestProfilePicCell;
}

- (void)configureGuestProfilePic:(GuestProfilePicCell *)guestProfilePicCell withUpcomingTrip:(UpcomingTrip *)upcomingTrip {
    guestProfilePicCell.guestProfilePic.file = [upcomingTrip.guest objectForKey:@"profileImage"];
    [guestProfilePicCell.guestProfilePic loadInBackground];
    guestProfilePicCell.guestProfilePic.layer.cornerRadius = guestProfilePicCell.guestProfilePic.frame.size.height / 2;
    [guestProfilePicCell.guestProfilePic.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [guestProfilePicCell.guestProfilePic.layer setBorderWidth: 1.0];
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.guestsArray.count;
    return [self.post.spots integerValue];
}

- (IBAction)tappedJoinTrip:(id)sender {
    [JoinLeaveTrip joinLeaveTrip:self.post withLabel:self.spotsCountLabel withButton:self.addGuestButton withIcon:self.spotsFilledIcon];
    [self fetchGuests];
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
