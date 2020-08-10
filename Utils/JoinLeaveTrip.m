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

+ (void)joinLeaveTrip:(Post *)post withLabel:(UILabel *)spotsCountLabel withButton:(UIButton *)addGuestButton withIcon:(UIButton *)spotsFilledIcon {
    //if (![post.objectId isEqual: PFUser.currentUser.objectId]) {
        for (PFUser *guest in post.guestList) {
            if ([guest.objectId isEqual:PFUser.currentUser.objectId]) {
                [self configureSpotsFilled:post withLabel:spotsCountLabel withGuest:guest withAdd:NO];
                [self configureButtons:addGuestButton withIcon:spotsFilledIcon withState:@"Join Trip"];
                [self savePost:post withNotifType:@"left"];
                [self deleteUpcomingTrip:post];
                return;
            }
        }
        [self configureSpotsFilled:post withLabel:spotsCountLabel withGuest:PFUser.currentUser withAdd:YES];
        [self configureButtons:addGuestButton withIcon:spotsFilledIcon withState:@"Leave Trip"];
        [self savePost:post withNotifType:@"join"];
        [self addUpcomingTrip:post];
    //}
}

+ (void)configureSpotsFilled:(Post *)post withLabel:(UILabel *)spotsCountLabel withGuest:(PFUser *)guest withAdd:(BOOL)add {
    if (add) {
        [post.guestList addObject:guest];
        spotsCountLabel.textColor = [UIColor systemBlueColor];
    } else {
        [post.guestList removeObject:guest];
        spotsCountLabel.textColor = [UIColor systemGrayColor];
    }
    [post setObject:post.guestList forKey:@"guestList"];
    spotsCountLabel.text = [NSString stringWithFormat:@"%lu / %@", (unsigned long)post.guestList.count, post.spots];
}

+ (void)configureButtons:(UIButton *)addGuestButton withIcon:(UIButton *)spotsFilledIcon withState:(NSString *)state {
    [addGuestButton setTitle:state forState:UIControlStateNormal];
    if ([state isEqualToString:@"Leave Trip"]) {
        addGuestButton.backgroundColor = [UIColor whiteColor];
        addGuestButton.layer.borderColor = [[UIColor systemBlueColor] CGColor];
        addGuestButton.layer.borderWidth = 1.0;
        [addGuestButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        spotsFilledIcon.tintColor = [UIColor systemBlueColor];
        [spotsFilledIcon setBackgroundImage:[UIImage systemImageNamed:@"person.3.fill"] forState:UIControlStateNormal];
    } else {
        addGuestButton.backgroundColor = [UIColor systemBlueColor];
        [addGuestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        spotsFilledIcon.tintColor = [UIColor grayColor];
        [spotsFilledIcon setBackgroundImage:[UIImage systemImageNamed:@"person.3"] forState:UIControlStateNormal];
    }
}

+ (void)savePost:(Post *)post withNotifType:(NSString *)type {
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Guest %@ trip!", type);
            [Notifications sendNotification:[PFUser currentUser] withReceiver:post.author withPost:post withType:type];
        } else {
            NSLog(@"Error updating post: %@", error.localizedDescription);
        }
    }];
}

+ (void)deleteUpcomingTrip:(Post *)post {
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
}

+ (void)addUpcomingTrip:(Post *)post {
    [UpcomingTrip createUpcomingTrip:[PFUser currentUser] withHost:post.author withTrip:post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Added upcoming trip");
        } else {
            NSLog(@"Error updating post: %@", error.localizedDescription);
        }
    }];
}

@end
