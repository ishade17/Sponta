//
//  Comment.m
//  Sponta
//
//  Created by Isaac Schaider on 7/20/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic author;
@dynamic post;
@dynamic caption;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

+ (void) postComments: (NSString * _Nullable)caption onPost: (Post *)post withCompletion: (PFBooleanResultBlock _Nullable)completion {
    
    Comment *newComment = [Comment new];
    newComment.post = post;
    newComment.author = [PFUser currentUser];
    newComment.caption = caption;
    
    [post incrementKey:@"commentCount"];
    
    [newComment saveInBackgroundWithBlock:completion];
}

@end
