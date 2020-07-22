//
//  DetailsViewController.h
//  Sponta
//
//  Created by Isaac Schaider on 7/20/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *spotsCountLabel;
@property (nonatomic, strong) Post *post;

@end

NS_ASSUME_NONNULL_END
