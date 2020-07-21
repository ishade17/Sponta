//
//  CommentCell.h
//  Sponta
//
//  Created by Isaac Schaider on 7/20/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentUserLabel;


@end

NS_ASSUME_NONNULL_END
