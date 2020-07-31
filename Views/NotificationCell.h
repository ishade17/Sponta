//
//  NotificationCell.h
//  Sponta
//
//  Created by Isaac Schaider on 7/30/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationCell : UITableViewCell

@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *triggerUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *notifTypeLabel;
@property (weak, nonatomic) IBOutlet PFImageView *targetPostPreviewImage;

@end

NS_ASSUME_NONNULL_END
