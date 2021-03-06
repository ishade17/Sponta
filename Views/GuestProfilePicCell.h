//
//  GuestProfilePicCell.h
//  Sponta
//
//  Created by Isaac Schaider on 7/29/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuestProfilePicCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *guestProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *guestUsername;


@end

NS_ASSUME_NONNULL_END
