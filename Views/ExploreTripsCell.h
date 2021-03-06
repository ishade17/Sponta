//
//  ExploreTripsCell.h
//  Sponta
//
//  Created by Isaac Schaider on 7/25/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PFImageView.h"
#import "Post.h"
#import "GuestProfilePicCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExploreTripsCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *tripTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotsFilledLabel;
@property (weak, nonatomic) IBOutlet PFImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *addGuestButton;
@property (weak, nonatomic) IBOutlet UIButton *spotsFilledIcon;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *usernameLabel;
@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) NSMutableArray *guestsArray;

- (void)updateCollectionView;

@end

NS_ASSUME_NONNULL_END
