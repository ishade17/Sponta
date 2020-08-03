//
//  JoinLeaveTrip.m
//  Sponta
//
//  Created by Isaac Schaider on 7/29/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "JoinLeaveTrip.h"
#import "Post.h"
#import <Parse/Parse.h>
#import "Notifications.h"
#import "UpcomingTrip.h"

@implementation JoinLeaveTrip


+ (nonnull NSString *)parseClassName {
    return @"JoinLeaveTrip";
}

+ (void)joinLeaveTrip:(Post *)post withLabel:(UILabel *)spotsCountLabel withLabelFormat:(BOOL)longFormat withButton:(UIButton *)addGuestButton {
    //if (![post.objectId isEqual: PFUser.currentUser.objectId]) { //change to object id
        for (PFUser *guest in post.guestList) {
            
            if ([guest.objectId isEqual:PFUser.currentUser.objectId]) {
                [post.guestList removeObject:guest];
                [post setObject:post.guestList forKey:@"guestList"];
                if (longFormat) {
                    spotsCountLabel.text = [NSString stringWithFormat:@"Spots Filled: %lu / %@", (unsigned long)post.guestList.count, post.spots];
                } else {
                    spotsCountLabel.text = [NSString stringWithFormat:@"%lu / %@", (unsigned long)post.guestList.count, post.spots];
                }
                addGuestButton.backgroundColor = [UIColor blueColor];
                [addGuestButton setTitle:@"Join Trip" forState:UIControlStateNormal];
                [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        NSLog(@"Guest removed from trip!");
                        [Notifications sendNotification:[PFUser currentUser] withReceiver:post.author withPost:post withType:@"left"];
                    } else {
                        NSLog(@"Error updating post: %@", error.localizedDescription);
                    }
                }];
                
                PFQuery *query = [PFQuery queryWithClassName:@"UpcomingTrip"];
                [query includeKey:@"trip"];
                [query includeKey:@"guest"];
                [query whereKey:@"trip" equalTo:post];
                [query whereKey:@"guest" equalTo:PFUser.currentUser];
                [query findObjectsInBackgroundWithBlock:^(NSArray *upcomingTrips, NSError *error) {
                    if (!error) {
                        for (PFObject *upcomingTrip in upcomingTrips) {
                            [upcomingTrip deleteInBackground];
                        }
                        NSLog(@"Upcoming trips (delete): %@", upcomingTrips);
                    }
                }];
                
                return;
            }
        }
        
        [post.guestList addObject:PFUser.currentUser];
        [post setObject:post.guestList forKey:@"guestList"];
        if (longFormat) {
            spotsCountLabel.text = [NSString stringWithFormat:@"Spots Filled: %lu / %@", (unsigned long)post.guestList.count, post.spots];
        } else {
            spotsCountLabel.text = [NSString stringWithFormat:@"%lu / %@", (unsigned long)post.guestList.count, post.spots];
        }
        addGuestButton.backgroundColor = [UIColor greenColor];
        [addGuestButton setTitle:@"Leave Trip" forState:UIControlStateNormal];
        [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Guest added to trip!");
                [Notifications sendNotification:[PFUser currentUser] withReceiver:post.author withPost:post withType:@"join"];
            } else {
                NSLog(@"Error updating post: %@", error.localizedDescription);
            }
        }];
            
        
        [UpcomingTrip createUpcomingTrip:[PFUser currentUser] withHost:post.author withTrip:post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"Added upcoming trip");
            } else {
                NSLog(@"Error updating post: %@", error.localizedDescription);
            }
        }];
    //}
}


/*
[PFUser.currentUser[@"upcomingTrips"] addObject:post];
[PFUser.currentUser setObject:PFUser.currentUser[@"upcomingTrips"] forKey:@"upcomingTrips"];
NSLog(@"upcoming trips (add): %@", PFUser.currentUser[@"upcomingTrips"]);
[PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
        NSLog(@"Upcoming trip list updated");
    } else {
        NSLog(@"Error updating upcoming trip list: %@", error.localizedDescription);
    }
}];
 */

@end
