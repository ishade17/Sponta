//
//  FriendRequest.m
//  Sponta
//
//  Created by Isaac Schaider on 8/5/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "FriendRequest.h"

@implementation FriendRequest

@dynamic sender;
@dynamic receiver;

+ (nonnull NSString *)parseClassName {
    return @"FriendRequest";
}

+ (void)makeFriendRequest:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(PFBooleanResultBlock _Nullable)completion {
    FriendRequest *friendRequest = [FriendRequest new];
    friendRequest.sender = sender;
    friendRequest.receiver = receiver;
    
    [friendRequest saveInBackgroundWithBlock:completion];
}

@end
