//
//  ProfilePostCell.h
//  Sponta
//
//  Created by Isaac Schaider on 7/27/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfilePostCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *postImage;

@end

NS_ASSUME_NONNULL_END
