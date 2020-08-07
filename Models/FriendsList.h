//
//  FriendsList.h
//  Sponta
//
//  Created by Isaac Schaider on 8/6/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendsList : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSMutableArray *friendsList;

+ (void)createFriendsList:(PFUser *)currUser withCompletion: (PFBooleanResultBlock _Nullable)completion;

+ (void)removeFriend:(PFUser *)friend fromUser:(PFUser *)user withCompletion:(PFBooleanResultBlock _Nullable)completion;

+ (void)addFriend:(PFUser *)friend toUser:(PFUser *)user withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
