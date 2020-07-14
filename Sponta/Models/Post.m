//
//  Post.m
//  Sponta
//
//  Created by Isaac Schaider on 7/14/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic previewImages;
@dynamic likeCount;
@dynamic startAddress;
@dynamic endAddress;
@dynamic tripDate;
@dynamic startTime;
@dynamic endTime;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

@end
