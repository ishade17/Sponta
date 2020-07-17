//
//  LocationCell.h
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationCell : UITableViewCell

- (void)updateWithLocation:(NSDictionary *)location;

@end

NS_ASSUME_NONNULL_END
