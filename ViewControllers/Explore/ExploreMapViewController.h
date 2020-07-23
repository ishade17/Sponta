//
//  ExploreMapViewController.h
//  Sponta
//
//  Created by Isaac Schaider on 7/21/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExploreMapViewController : UIViewController

@property (nonatomic, weak) Post *post;

@end

NS_ASSUME_NONNULL_END
