//
//  BookmarkedTripCell.h
//  Sponta
//
//  Created by Isaac Schaider on 8/3/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookmarkedTripCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *hostProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *hostUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripTimeLabel;
@property (weak, nonatomic) IBOutlet PFImageView *tripPreviewImageView;

@end

NS_ASSUME_NONNULL_END
