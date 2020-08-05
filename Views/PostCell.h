//
//  PostCell.h
//  Sponta
//
//  Created by Isaac Schaider on 7/14/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet UILabel *tripTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotsFilledLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet PFImageView *previewImage;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicImage;
@property (weak, nonatomic) IBOutlet UILabel *publicTag;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *spotsFilledIcon;
@property (weak, nonatomic) IBOutlet UIButton *usernameLabel;

@end

NS_ASSUME_NONNULL_END
