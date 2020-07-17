//
//  LocationPreviewCell.h
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocationPreviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *previewImage;

- (void)updateWithPreview:(NSDictionary *)photoObject;



@end

NS_ASSUME_NONNULL_END
