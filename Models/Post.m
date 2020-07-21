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
@dynamic previewImage;
@dynamic likeCount;
@dynamic address;
@dynamic tripDate;
@dynamic startTime;
@dynamic endTime;
@dynamic guestList;
@dynamic spots;
@dynamic publicTrip;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserTrip: ( NSString * _Nullable )title withDescription: ( NSString * _Nullable )description withImage: (UIImage * _Nullable )previewImage withAddress: ( NSString * _Nullable )address withTripDate:  ( NSString * _Nullable )tripDate withStartTime: ( NSString * _Nullable )startTime withEndTime: ( NSString * _Nullable )endTime withSpots: ( NSString * _Nullable )spots withPublicOption: ( BOOL ) publicOption withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Post *newPost = [Post new];
    newPost.author = [PFUser currentUser];
    newPost.title = title;
    newPost.description = description;
    newPost.previewImage = [self getPFFileFromImage:previewImage];
    newPost.address = address;
    newPost.tripDate = [self stringToDate:tripDate];
    newPost.startTime = startTime;
    newPost.endTime = endTime;
    newPost.spots = [self stringToNumber:spots];
    newPost.guestList = [NSMutableArray new];
    newPost.likeCount = @(0);
    newPost.publicTrip = publicOption;

    [newPost saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    NSLog(@"chegggg");
    // check if image is not nil
    if (!image) {
        NSLog(@"nil image1");
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        NSLog(@"nil image2");
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (NSDate *)stringToDate: (NSString *)dateString {
    //FIX BUG: returning nil
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    NSLog(@"%@", dateFromString);
    return dateFromString;
}

+ (NSNumber *)stringToNumber: (NSString *)spotsString {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:spotsString];
    return myNumber;
}

@end
