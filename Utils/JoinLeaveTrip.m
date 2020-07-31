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

@implementation JoinLeaveTrip

+ (nonnull NSString *)parseClassName {
    return @"JoinLeaveTrip";
}

+ (void)joinLeaveTrip:(Post *)post withLabel:(UILabel *)spotsCountLabel withLabelFormat:(BOOL)longFormat withButton:(UIButton *)addGuestButton {
    //if (![post.author isEqual: PFUser.currentUser]) {
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
    //}
}

@end
