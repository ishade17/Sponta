//
//  ExploreTripsCell.m
//  Sponta
//
//  Created by Isaac Schaider on 7/25/20.
//  Copyright © 2020 codepath. All rights reserved.
//

#import "ExploreTripsCell.h"
#import "JoinLeaveTrip.h"
#import "UpcomingTrip.h"
#import "GuestProfilePicCell.h"

@implementation ExploreTripsCell 
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateCollectionView {
    [self fetchGuests:self.post];
    [self configureCollectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
}


- (void)configureCollectionView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemWidth = self.collectionView.frame.size.width / 3.4;
    CGFloat itemHeight = self.collectionView.frame.size.height;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)fetchGuests:(Post *)post {
    PFQuery *query = [PFQuery queryWithClassName:@"UpcomingTrip"];
    [query includeKey:@"trip"];
    [query includeKey:@"guest"];
    [query whereKey:@"trip" equalTo:post];

    [query findObjectsInBackgroundWithBlock:^(NSArray *tripGuests, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.guestsArray = (NSMutableArray *)tripGuests;
            [self.collectionView reloadData];
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GuestProfilePicCell *guestProfilePicCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GuestProfilePicCell" forIndexPath:indexPath];
    if (indexPath.row < self.guestsArray.count) {
        UpcomingTrip *upcomingTrip = self.guestsArray[indexPath.row];
        
        [self configureGuestProfilePic:guestProfilePicCell withUpcomingTrip:upcomingTrip];
        guestProfilePicCell.guestUsername.text = upcomingTrip.guest.username;
    } else {
        guestProfilePicCell.guestProfilePic.layer.cornerRadius = guestProfilePicCell.guestProfilePic.frame.size.height / 2;
        [guestProfilePicCell.guestProfilePic.layer setBorderColor: [[UIColor blueColor] CGColor]];
        [guestProfilePicCell.guestProfilePic.layer setBorderWidth: 0.5];
        guestProfilePicCell.guestUsername.text = @"Open";
    }
    
    return guestProfilePicCell;
}

- (void)configureGuestProfilePic:(GuestProfilePicCell *)guestProfilePicCell withUpcomingTrip:(UpcomingTrip *)upcomingTrip {
    guestProfilePicCell.guestProfilePic.file = [upcomingTrip.guest objectForKey:@"profileImage"];
    [guestProfilePicCell.guestProfilePic loadInBackground];
    guestProfilePicCell.guestProfilePic.layer.cornerRadius = guestProfilePicCell.guestProfilePic.frame.size.height / 2;
    [guestProfilePicCell.guestProfilePic.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [guestProfilePicCell.guestProfilePic.layer setBorderWidth: 1.0];
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.guestsArray.count;
    return [self.post.spots integerValue];
}
 


@end
