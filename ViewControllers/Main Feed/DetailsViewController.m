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

@interface DetailsViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addGuestButton;
@property (weak, nonatomic) IBOutlet UILabel *tripTitleLabel;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UILabel *timePeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAddress;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextField *commentMessageField;
@property (nonatomic, strong) NSMutableArray *commentsArray;
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
        }
    }
    
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    
    [self fetchComments];
    
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

- (IBAction)tappedJoinTrip:(id)sender {
    [JoinLeaveTrip joinLeaveTrip:self.post withLabel:self.spotsCountLabel withLabelFormat:NO withButton:self.addGuestButton];
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
