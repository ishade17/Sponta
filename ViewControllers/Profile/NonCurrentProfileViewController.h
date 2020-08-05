//
//  NonCurrentProfileViewController.h
//  Sponta
//
//  Created by Isaac Schaider on 8/5/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NonCurrentProfileViewController : UIViewController

@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END
