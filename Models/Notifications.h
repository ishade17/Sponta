//
//  Notifications.h
//  Sponta
//
//  Created by Isaac Schaider on 7/30/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Notifications : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) Post *targetPost;
@property (nonatomic, strong) PFUser *triggerUser;
@property (nonatomic, strong) PFUser *receiverUser;

+ (void)createNotification:(PFUser *)triggerUser withReceiver:(PFUser *)receiverUser withPost:(Post *)targetPost withType:(NSString *)type withCompletion: (PFBooleanResultBlock _Nullable)completion;
+ (void)sendNotification:(PFUser *)triggerUser withReceiver:(PFUser *)receiverUser withPost:(Post *)post withType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
