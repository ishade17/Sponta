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
@dynamic title;
@dynamic description;
@dynamic preview;
@dynamic likeCount;
@dynamic startAddress;
@dynamic endAddress;
@dynamic tripDate;
@dynamic startTime;
@dynamic endTime;
@dynamic guestList;
@dynamic spots;


+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserTrip: ( NSString * _Nullable )title withDescription: ( NSString * _Nullable )description withImage: (UIImage * _Nullable )previewImage withStartAddress: ( NSString * _Nullable )startAddress withEndAddress: ( NSString * _Nullable )endAddress withTripDate:  ( NSDate * _Nullable )tripDate withStartTime: ( NSString * _Nullable )startTime withEndTime: ( NSString * _Nullable )endTime withSpots: ( NSNumber * _Nullable )spots withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Post *newPost = [Post new];
    newPost.author = [PFUser currentUser];
    newPost.title = title;
    newPost.description = description;
    newPost.preview = [self getPFFileFromImage:previewImage];
    newPost.startAddress = startAddress;
    newPost.endAddress = endAddress;
    newPost.startTime = startTime;
    newPost.endTime = endTime;
    newPost.spots = spots;
    newPost.guestList = [NSMutableArray new];
    newPost.likeCount = @(0);

    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
