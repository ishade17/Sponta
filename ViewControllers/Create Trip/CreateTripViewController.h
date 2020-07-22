//
//  CreateTripViewController.h
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateTripViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *selectedImage;

@end

NS_ASSUME_NONNULL_END
