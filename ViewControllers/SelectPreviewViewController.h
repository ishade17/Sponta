//
//  SelectPreviewViewController.h
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelectPreviewViewControllerDelegate

@required
- (void)didSelectPreview:(nonnull UIImage *)preview;

@end

@interface SelectPreviewViewController : UIViewController

@property (nonatomic, strong) NSString *previewID;
@property (nonatomic, strong) NSMutableArray *previewImagesArray;

@property (nonatomic, weak) id<SelectPreviewViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
