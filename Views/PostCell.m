//
//  PostCell.m
//  Sponta
//
//  Created by Isaac Schaider on 7/14/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "PostCell.h"
#import "BookmarkedTrip.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.spotsFilledIcon setBackgroundImage:[UIImage systemImageNamed:@"person.3"] forState:UIControlStateNormal];
    self.spotsFilledIcon.tintColor = [UIColor blueColor];
    self.spotsFilledLabel.textColor = [UIColor blueColor];
    
    //[self.likeButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
    //self.likeButton.tintColor = [UIColor blueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)tappedLike:(id)sender {
    //unlike
    for (PFUser *user in self.post.likedList) {
        if ([user.objectId isEqual:PFUser.currentUser.objectId]) {
            [self.post.likedList removeObject:user]; // CHANGE
            [self.post setObject:self.post.likedList forKey:@"likedList"]; // CHANGE
            [self.likeButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
            self.likeButton.tintColor = [UIColor systemBlueColor];
            if (self.post.likedList.count == 1) {
                self.likeCountLabel.text = [NSString stringWithFormat:@"%lu Bookmark", (unsigned long)self.post.likedList.count];
            } else {
                self.likeCountLabel.text = [NSString stringWithFormat:@"%lu Bookmarks", (unsigned long)self.post.likedList.count];
            }
            [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"Post unliked!");
                } else {
                    NSLog(@"Error updating post: %@", error.localizedDescription);
                }
            }];
            
            PFQuery *query = [PFQuery queryWithClassName:@"BookmarkedTrip"];
            [query includeKey:@"trip"];
            [query includeKey:@"user"];
            [query whereKey:@"trip" equalTo:self.post];
            [query whereKey:@"user" equalTo:PFUser.currentUser];
            [query findObjectsInBackgroundWithBlock:^(NSArray *bookmarkedTrips, NSError *error) {
                if (!error) {
                    for (PFObject *bookmarkedTrip in bookmarkedTrips) {
                        [bookmarkedTrip deleteInBackground];
                    }
                    NSLog(@"Upcoming trips (delete): %@", bookmarkedTrips);
                }
            }];
            
            return;
        }
    }
    
    //like
    [self.post.likedList addObject:PFUser.currentUser]; // CHANGE
    [self.post setObject:self.post.likedList forKey:@"likedList"];
    [self.likeButton setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
    self.likeButton.tintColor = [UIColor systemGreenColor];
    
    if (self.post.likedList.count == 1) {
        self.likeCountLabel.text = [NSString stringWithFormat:@"%lu Bookmark", (unsigned long)self.post.likedList.count];
    } else {
        self.likeCountLabel.text = [NSString stringWithFormat:@"%lu Bookmarks", (unsigned long)self.post.likedList.count];
    }
    
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Post liked!");
        } else {
            NSLog(@"Error updating post: %@", error.localizedDescription);
        }
    }];
    
    [BookmarkedTrip bookmarkTrip:[PFUser currentUser] withHost:self.post.author withTrip:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Trip bookmarked!");
        } else {
            NSLog(@"Error updating post: %@", error.localizedDescription);
        }
    }];
    
}

@end
