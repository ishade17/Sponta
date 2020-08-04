//
//  JoinLeaveTrip.h
//  Sponta
//
//  Created by Isaac Schaider on 7/29/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface JoinLeaveTrip : NSObject
@property (nonatomic, strong) NSMutableArray *test;

+ (void)joinLeaveTrip:(Post *)post withLabel:(UILabel *)spotsCountLabel withButton:(UIButton *)addGuestButton withIcon:(UIButton *)spotsFilledIcon;

@end

NS_ASSUME_NONNULL_END
