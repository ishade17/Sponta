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

+ (void)joinLeaveTrip:(Post *)post withLabel:(UILabel *)spotsCountLabel withLabelFormat:(BOOL)longFormat withButton:(UIButton *)addGuestButton;


@end

NS_ASSUME_NONNULL_END
