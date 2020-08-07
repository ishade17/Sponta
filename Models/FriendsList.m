//
//  FriendsList.m
//  Sponta
//
//  Created by Isaac Schaider on 8/6/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "FriendsList.h"

@implementation FriendsList

@dynamic user;
@dynamic friendsList;

+ (nonnull NSString *)parseClassName {
    return @"FriendsList";
}

+ (void)createFriendsList:(PFUser *)currUser withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    FriendsList *currUserList = [FriendsList new];
    currUserList.user = currUser;
    currUserList.friendsList = [NSMutableArray new];
    
    [currUserList saveInBackgroundWithBlock:completion];
}

+ (void)removeFriend:(PFUser *)friend fromUser:(PFUser *)user withCompletion:(PFBooleanResultBlock _Nullable)completion {
    
    PFQuery *query = [FriendsList query];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:user];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable user, NSError * _Nullable error) {
        if (user.count == 1) {
            FriendsList *userList = user[0];
            [userList.friendsList removeObject:friend.username];
            [userList setObject:userList.friendsList forKey:@"friendsList"];
            [userList saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"Friendship removed!");
                } else {
                    NSLog(@"Error removing friendship: %@", error.localizedDescription);
                }
            }];
        } else {
            NSLog(@"Error finding user's friendlist: %@", error.localizedDescription);
        }
    }];
}

+ (void)addFriend:(PFUser *)friend toUser:(PFUser *)user withCompletion:(PFBooleanResultBlock _Nullable)completion {
    
    PFQuery *query = [FriendsList query];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:user];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable user, NSError * _Nullable error) {
        if (user.count == 1) {
            FriendsList *userList = user[0];
            [userList.friendsList addObject:friend.username];
            [userList setObject:userList.friendsList forKey:@"friendsList"];
            [userList saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"Friend request approved!");
                } else {
                    NSLog(@"Error approving friend request: %@", error.localizedDescription);
                }
            }];
        } else {
            NSLog(@"Error finding user's friendlist: %@", error.localizedDescription);
        }
    }];
}

@end
