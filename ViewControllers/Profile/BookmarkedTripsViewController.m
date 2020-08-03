//
//  BookmarkedTripsViewController.m
//  Sponta
//
//  Created by Isaac Schaider on 8/3/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "BookmarkedTripsViewController.h"
#import <Parse/Parse.h>

@interface BookmarkedTripsViewController ()

@property (nonatomic, strong) NSMutableArray *bookmarkedTrips;

@end

@implementation BookmarkedTripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)fetchBookmarkedTrips {
    PFQuery *query = [PFQuery queryWithClassName:@"BookmarkedTrip"];
    [query includeKey:@"trip"];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:PFUser.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *bookmarkedTrips, NSError *error) {
        if (!error) {
            self.bookmarkedTrips = (NSMutableArray *)bookmarkedTrips;
        }
    }];
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
