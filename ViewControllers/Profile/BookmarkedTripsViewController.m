//
//  BookmarkedTripsViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 8/3/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "BookmarkedTripsViewController.h"
#import <Parse/Parse.h>
#import "BookmarkedTrip.h"
#import "BookmarkedTripCell.h"
#import "DetailsViewController.h"

@interface BookmarkedTripsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *bookmarkedTrips;

@end

@implementation BookmarkedTripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.rowHeight = 75;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchBookmarkedTrips];
}

- (void)fetchBookmarkedTrips {
    PFQuery *query = [PFQuery queryWithClassName:@"BookmarkedTrip"];
    [query includeKey:@"trip"];
    [query includeKey:@"user"];
    [query includeKey:@"host"];
    [query whereKey:@"user" equalTo:PFUser.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *bookmarkedTrips, NSError *error) {
        if (!error) {
            self.bookmarkedTrips = (NSMutableArray *)bookmarkedTrips;
            [self.tableView reloadData];
        }
    }];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BookmarkedTripCell *bookmarkedTripCell = [tableView dequeueReusableCellWithIdentifier:@"BookmarkedTripCell"];
    BookmarkedTrip *bookmarkedTrip = self.bookmarkedTrips[indexPath.row];
    
    bookmarkedTripCell.hostUsernameLabel.text = bookmarkedTrip.host.username;
    
    NSArray *daysOfWeek = @[@"",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:bookmarkedTrip.trip.tripDate];
    bookmarkedTripCell.tripTimeLabel.text = [NSString stringWithFormat:@"%@ on %@", bookmarkedTrip.trip.startTime, [daysOfWeek objectAtIndex:weekday]];
    
    bookmarkedTripCell.hostProfilePic.file = [bookmarkedTrip.host objectForKey:@"profileImage"];
    [bookmarkedTripCell.hostProfilePic loadInBackground];
    bookmarkedTripCell.hostProfilePic.layer.cornerRadius = bookmarkedTripCell.hostProfilePic.frame.size.height / 2;
    [bookmarkedTripCell.hostProfilePic.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [bookmarkedTripCell.hostProfilePic.layer setBorderWidth: 1.0];
    
    bookmarkedTripCell.tripPreviewImageView.file = [bookmarkedTrip.trip objectForKey:@"previewImage"];
    [bookmarkedTripCell.tripPreviewImageView loadInBackground];
    
    return bookmarkedTripCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookmarkedTrips.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"toDetailsFromBookmarked"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        
        BookmarkedTrip *bookmarkedTrip = self.bookmarkedTrips[indexPath.row];
        Post *post = bookmarkedTrip.trip;
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}


@end
