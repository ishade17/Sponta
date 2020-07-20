//
//  Post.h
//  Sponta
//
//  Created by Isaac Schaider on 7/14/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) PFFileObject *previewImage;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSDate *tripDate;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSMutableArray *guestList;
@property (nonatomic, strong) NSNumber *spots;

+ (void) postUserTrip: ( NSString * _Nullable )title withDescription: ( NSString * _Nullable )description withImage: (UIImage * _Nullable )previewImage withAddress: ( NSString * _Nullable )address withTripDate:  ( NSString * _Nullable )tripDate withStartTime: ( NSString * _Nullable )startTime withEndTime: ( NSString * _Nullable )endTime withSpots: ( NSString * _Nullable )spots withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END