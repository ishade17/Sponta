//
//  BookmarkedTrip.h
//  Sponta
//
//  Created by Isaac Schaider on 8/3/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookmarkedTrip : PFObject<PFSubclassing>

@property (nonatomic, strong) Post *trip;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFUser *host;

+ (void)bookmarkTrip:(PFUser *)user withHost:(PFUser *)host withTrip:(Post *)trip withCompletion: (PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
