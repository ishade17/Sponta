//
//  SearchLocationsViewController.h
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SearchLocationsViewController;

@protocol SearchLocationsViewControllerDelegate

- (void)searchLocationsViewController:(SearchLocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

@end


@interface SearchLocationsViewController : UIViewController

@property (weak, nonatomic) id<SearchLocationsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *previewID;

@end

NS_ASSUME_NONNULL_END
