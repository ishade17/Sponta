//
//  SearchLocationsViewController.h
//  Sponta
//
//  Created by Isaac Schaider on 7/15/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

//@class SearchLocationsViewController;

@protocol SearchLocationsViewControllerDelegate

@required

- (void)didSelectPreview:(nonnull UIImage *)preview withAddress:(nonnull NSString *)address withLatitude:(NSNumber *)latitude withLongitude:(NSNumber *)longitude;

@end

@interface SearchLocationsViewController : UIViewController

@property (weak, nonatomic) id<SearchLocationsViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *previewID;
@property (weak, nonatomic) UIImage *passedPreview;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@end

//@protocol SearchLocationsViewControllerDelegate
//
//- (void)searchLocationsViewController:(SearchLocationsViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;
//
//@end

NS_ASSUME_NONNULL_END
