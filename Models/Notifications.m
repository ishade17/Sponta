//
//  Notifications.m
//  Sponta
//
//  Created by Isaac Schaider on 7/30/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "Notifications.h"

@implementation Notifications

@dynamic type;
@dynamic targetPost;
@dynamic triggerUser;
@dynamic receiverUser;

+ (nonnull NSString *)parseClassName {
    return @"Notifications";
}

+ (void) createNotification:(PFUser *)triggerUser withReceiver:(PFUser *)receiverUser withPost:(Post *)targetPost withType:(NSString *)type withCompletion: (PFBooleanResultBlock _Nullable)completion {
    Notifications *newNotif = [Notifications new];
    newNotif.triggerUser = triggerUser;
    newNotif.receiverUser = receiverUser;
    newNotif.targetPost = targetPost;
    newNotif.type = type;
    
    [newNotif saveInBackgroundWithBlock:completion];
}

@end
