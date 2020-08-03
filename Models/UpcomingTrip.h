//
//  UpcomingTrip.h
//  Sponta
//
//  Created by Isaac Schaider on 8/1/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN


@interface UpcomingTrip : PFObject<PFSubclassing>

@property (nonatomic, strong) Post *trip;
@property (nonatomic, strong) PFUser *guest;
@property (nonatomic, strong) PFUser *host;

+ (void)createUpcomingTrip:(PFUser *)guest withHost:(PFUser *)host withTrip:(Post *)trip withCompletion: (PFBooleanResultBlock _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
