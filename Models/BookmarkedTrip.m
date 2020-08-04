//
//  BookmarkedTrip.m
//  Sponta
//
//  Created by Isaac Schaider on 8/3/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "BookmarkedTrip.h"

@implementation BookmarkedTrip

@dynamic trip;
@dynamic user;
@dynamic host;

+ (nonnull NSString *)parseClassName {
    return @"BookmarkedTrip";
}

+ (void)bookmarkTrip:(PFUser *)user withHost:(PFUser *)host withTrip:(Post *)trip withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    BookmarkedTrip *bookmarkedTrip = [BookmarkedTrip new];
    bookmarkedTrip.trip = trip;
    bookmarkedTrip.user = user;
    bookmarkedTrip.host = host;

    [bookmarkedTrip saveInBackgroundWithBlock:completion];
}

@end
