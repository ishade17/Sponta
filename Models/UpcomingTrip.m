//
//  UpcomingTrip.m
//  Sponta
//
//  Created by Isaac Schaider on 8/1/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "UpcomingTrip.h"

@implementation UpcomingTrip

@dynamic trip;
@dynamic guest;
@dynamic host;

+ (nonnull NSString *)parseClassName {
    return @"UpcomingTrip";
}

+ (void)createUpcomingTrip:(PFUser *)guest withHost:(PFUser *)host withTrip:(Post *)trip withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    UpcomingTrip *newUpcomingTrip = [UpcomingTrip new];
    newUpcomingTrip.trip = trip;
    newUpcomingTrip.guest = guest;
    newUpcomingTrip.host = host;
    
    [newUpcomingTrip saveInBackgroundWithBlock:completion];
}

@end
