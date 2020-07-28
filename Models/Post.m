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
@dynamic tripDescription;
@dynamic previewImage;
@dynamic address;
@dynamic tripDate;
@dynamic startTime;
@dynamic endTime;
@dynamic guestList;
@dynamic spots;
@dynamic publicTrip;
@dynamic latitude;
@dynamic longitude;
@dynamic likedList;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserTrip: ( NSString * _Nullable )title withDescription: ( NSString * _Nullable )description withImage: (UIImage * _Nullable )previewImage withAddress: ( NSString * _Nullable )address withTripDate:  ( NSString * _Nullable )tripDate withStartTime: ( NSString * _Nullable )startTime withEndTime: ( NSString * _Nullable )endTime withSpots: ( NSString * _Nullable )spots withPublicOption: ( BOOL ) publicOption withLatitude: ( NSNumber * _Nullable ) latitude withLongitude: ( NSNumber * _Nullable) longitude withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Post *newPost = [Post new];
    newPost.author = [PFUser currentUser];
    newPost.title = title;
    newPost.tripDescription = description;
    newPost.previewImage = [self getPFFileFromImage:previewImage];
    newPost.address = address;
    newPost.tripDate = [self stringToDate:tripDate];
    newPost.startTime = startTime;
    newPost.endTime = endTime;
    newPost.spots = [self stringToNumber:spots];
    newPost.guestList = [NSMutableArray<PFUser *> new];
    newPost.publicTrip = publicOption;
    newPost.latitude = latitude;
    newPost.longitude = longitude;
    newPost.likedList = [NSMutableArray<PFUser *> new];

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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}

+ (NSNumber *)stringToNumber: (NSString *)spotsString {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:spotsString];
    return myNumber;
}

@end
