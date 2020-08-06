//
//  FriendRequest.h
//  Sponta
//
//  Created by Isaac Schaider on 8/5/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendRequest : PFObject<PFSubclassing>

@property (nonatomic, strong) PFUser *sender;
@property (nonatomic, strong) PFUser *receiver;

+ (void)makeFriendRequest:(PFUser *)sender withReceiver:(PFUser *)receiver withCompletion:(PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
