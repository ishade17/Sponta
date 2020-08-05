//
//  UpcomingTripCell.h
//  Sponta
//
//  Created by Isaac Schaider on 7/31/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpcomingTripCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *hostNameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *hostProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *tripNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripDateTimeLabel;

@end

NS_ASSUME_NONNULL_END
