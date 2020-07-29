//
//  PostCell.m
//  Sponta
//
//  Created by Isaac Schaider on 7/14/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tappedLike:(id)sender {
    //unlike
    for (PFUser *user in self.post.likedList) {
        if ([user.objectId isEqual:PFUser.currentUser.objectId]) {
            [self.post.likedList removeObject:user];
            [self.post setObject:self.post.likedList forKey:@"likedList"];
            self.likeButton.tintColor = [UIColor blueColor];
            self.likeCountLabel.text = [NSString stringWithFormat:@"%lu Likes", (unsigned long)self.post.likedList.count];
            [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"Post unliked!");
                } else {
                    NSLog(@"Error updating post: %@", error.localizedDescription);
                }
            }];
            return;
        }
    }
    
    //like
    [self.post.likedList addObject:PFUser.currentUser];
    [self.post setObject:self.post.likedList forKey:@"likedList"];
    self.likeButton.tintColor = [UIColor redColor];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%lu Likes", (unsigned long)self.post.likedList.count];
    
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Post liked!");
        } else {
            NSLog(@"Error updating post: %@", error.localizedDescription);
        }
    }];
    
}

@end
